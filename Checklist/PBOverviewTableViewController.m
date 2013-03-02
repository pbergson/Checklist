
#import "PBOverviewTableViewController.h"
#import "PBChecklistTableViewController.h"
#import "ChecklistItemTableViewCell.h"
#import "PBOverviewModel.h"
#import "PBListModel.h"
#import "constants.h"


@interface PBOverviewTableViewController ()

@property (strong, nonatomic) PBOverviewModel *overviewModel;
@property NSInteger indexToDelete;

@end

@implementation PBOverviewTableViewController

-(void)viewDidLoad{
  
  [self setOverviewModel:[[PBOverviewModel alloc] init]];
  [[self navigationController] setToolbarHidden:YES animated:NO];
  [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
  [self setTitle:@"Checklist"];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveChanges) name:PBModelDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [[self navigationController] setToolbarHidden:YES animated:YES];
}
-(void)saveChanges{
  [[self overviewModel] saveData];
}

#pragma mark - DATA SOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [[self overviewModel] numberOfLists];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  ChecklistItemTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"OverviewCell"];
  NSInteger index = indexPath.row;
  NSString *cellText = [[[self overviewModel] listAtIndex:index] listTitle];//cellText just made for clarity
  [[aCell textField] setText:cellText];
  [[aCell textField] setUserInteractionEnabled:[[self tableView] isEditing]];
  
  [aCell.textField setDelegate:self];
  
  return aCell;
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
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCellEditingStyle style = editingStyle;
  [self setIndexToDelete:indexPath.row];
  
  if (style == UITableViewCellEditingStyleDelete){
    UIActionSheet *cancelSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this list?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    [cancelSheet showFromToolbar:[[self navigationController] toolbar]];
  }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
  NSInteger sourceIndex = [sourceIndexPath row];
  NSInteger destinationIndex = [destinationIndexPath row];
  [[self overviewModel] moveListAtIndex:sourceIndex toIndex:destinationIndex];
}

-(void)addChecklistItem{
  [[self overviewModel] addNewList];
  [self toggleTextFieldEditingTo:YES];
  [[self tableView] reloadData];
}

-(void)toggleTextFieldEditingTo:(BOOL)state{
  NSArray *visibleCells = [[self tableView] visibleCells];
  
  for (UITableViewCell *enumCell in visibleCells) {
    [[(ChecklistItemTableViewCell *)enumCell textField] setUserInteractionEnabled:state];
  }
}

#pragma mark - TEXTFIELD DELEGATE

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  [[self overviewModel] saveData];
  return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
  NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
  NSString *string = [textField text];
  NSInteger index = [indexPath row];
  [[[self overviewModel] listAtIndex:index] setListTitle:string];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
}

#pragma mark - ACTIONSHEET DELEGATE

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{

  if (buttonIndex == 0) {
    [[self overviewModel] deleteListAtIndex:[self indexToDelete]];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
  }
  [[self tableView] reloadData];
}

#pragma mark - SEGUE

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([[segue identifier] isEqualToString:@"ChecklistSegue"]){
    PBChecklistTableViewController *destinationController = [segue destinationViewController];
    NSInteger index = [[[self tableView] indexPathForCell:sender] row];
    [destinationController setListModel:[[self overviewModel] listAtIndex:index]];
  }
}
@end
