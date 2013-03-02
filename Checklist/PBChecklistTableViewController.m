

#import "PBChecklistTableViewController.h"
#import "ChecklistItemTableViewCell.h"
#import "constants.h"

@interface PBChecklistTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PBChecklistTableViewController

-(void)viewDidLoad{
  [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
  [self setTitle:[[self listModel] listTitle]];
  [[self navigationController] setToolbarHidden:NO animated:YES];
}


#pragma mark - DATA SOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [[self listModel] numberOfItems];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  ChecklistItemTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistCell"];
  NSInteger index = indexPath.row;
  NSString *cellText = [[[self listModel] itemAtIndex:index] itemTitle];//cellText just made for clarity
  BOOL checkedStatus = [[[self listModel] itemAtIndex:index] checkedStatus];
  
  [[aCell textField] setText:cellText];
  [[aCell textField] setUserInteractionEnabled:[[self tableView] isEditing]];
  
  if (checkedStatus == YES){
    [aCell setAccessoryType:UITableViewCellAccessoryCheckmark];
  } else [aCell setAccessoryType:UITableViewCellAccessoryNone];

  [aCell.textField setDelegate:self];

  return aCell;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
  NSInteger sourceIndex = [sourceIndexPath row];
  NSInteger destinationIndex = [destinationIndexPath row];
  [[self listModel] moveObjectAtIndex:sourceIndex toIndex:destinationIndex];
}

#pragma mark - EDITING

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
  [super setEditing:editing animated:animated];
  
  if (editing) {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addChecklistItem)];
    [[self navigationItem] setLeftBarButtonItem:addButton animated:animated];
    [self toggleTextFieldEditingTo:YES];
  } else {
    [[self navigationItem] setLeftBarButtonItem:nil animated:animated];
    [self toggleTextFieldEditingTo:NO];
    [[self tableView] endEditing:YES];
    
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCellEditingStyle style = editingStyle;
  NSInteger index = indexPath.row;
     
  if (style == UITableViewCellEditingStyleDelete){
    [[self listModel] deleteItemAtIndex:index];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
    [[self tableView] reloadData];
  }
}

-(void)addChecklistItem{
  [[self listModel] addNewItem];
  [[self tableView] reloadData];
  [self toggleTextFieldEditingTo:YES];
}

-(void)toggleTextFieldEditingTo:(BOOL)state{
  NSArray *visibleCells = [[self tableView] visibleCells];
  
  for (UITableViewCell *enumCell in visibleCells){
  [[(ChecklistItemTableViewCell *)enumCell textField] setUserInteractionEnabled:state];
  }
}

#pragma mark - DELEGATES

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
  NSInteger index = indexPath.row;
  
    if ([aCell accessoryType] == UITableViewCellAccessoryCheckmark){
      [aCell setAccessoryType:UITableViewCellAccessoryNone];
      [[[self listModel] itemAtIndex:index] setCheckedStatus:NO];
    } else {
      [aCell setAccessoryType:UITableViewCellAccessoryCheckmark];
      [[[self listModel] itemAtIndex:index] setCheckedStatus:YES];
    }
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
  [aCell setSelected:NO animated:NO];
  
}

//for the textField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  //[[NSNotificationCenter defaultCenter] postNotificationName:@"modelDidChangeNotification" object:self];
  return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
  NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
  NSString *string = [textField text];
  NSInteger index = [indexPath row];
  [[[self listModel] itemAtIndex:index] setItemTitle:string];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
}


#pragma mark - ACTIONS

- (IBAction)resetPressed:(UIBarButtonItem *)sender {
  [[self listModel] resetCheckedStatus];
  [[self tableView] reloadData];
}


@end
