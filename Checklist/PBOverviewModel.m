
#import "PBOverviewModel.h"
#import "PBListModel.h"
#import "constants.h"

@interface PBOverviewModel ()

-(NSString *)plistFilePath;

@property (strong, nonatomic) NSMutableArray *overviewArray;

@end

@implementation PBOverviewModel

-(id)init{
  self = [super init];
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSData *plistData;
  NSError *error;
  
  //look for plist file in the documents directory
  NSString *fileName = [self plistFilePath];
  
  if ( ! [fileManager fileExistsAtPath:fileName]){
    NSString *mainBundlePath = [[NSBundle mainBundle] pathForResource:@"TestFile" ofType:@"plist"];
    [fileManager copyItemAtPath:mainBundlePath toPath:fileName error:&error];
  }
  
  plistData = [NSData dataWithContentsOfFile:fileName];
  NSArray *array = [NSPropertyListSerialization propertyListWithData:plistData options:0 format:NULL error:&error];
  
  [self setOverviewArray:[[NSMutableArray alloc] init]];
  for (NSDictionary *dictionary in array) {
    PBListModel *model = [[PBListModel alloc] initWithDictionary:dictionary];
    [[self overviewArray] addObject:model];
  }
  return self;
}


#pragma mark - PUBLIC

-(NSInteger)numberOfLists{
  return [[self overviewArray] count];
}

-(NSString *)listNameAtIndex:(NSInteger)index{
  NSString *title;
  PBListModel *list = [[self overviewArray] objectAtIndex:index];
  title = [list listTitle];
  return title;
}

-(PBListModel *)listAtIndex:(NSInteger)index{
  PBListModel *listModel = [[self overviewArray] objectAtIndex:index];
  return listModel;
}

-(void)moveListAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex{
  PBListModel *listModelToMove = [[self overviewArray] objectAtIndex:sourceIndex];
  [[self overviewArray] removeObjectAtIndex:sourceIndex];
  [[self overviewArray] insertObject:listModelToMove atIndex:destinationIndex];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
}

-(void)deleteListAtIndex:(NSInteger)index{
  [[self overviewArray] removeObjectAtIndex:index];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
}

-(void)addNewList{
  //???: It'd be cleaner to have a class method that took care of this. Like: «[PBListModel blankList]».
  NSMutableDictionary *blankDictionary = [[NSMutableDictionary alloc] init];
  [blankDictionary setValue:@"" forKey:@"Name"];
  NSMutableArray *blankArray = [[NSMutableArray alloc] init];
  [blankDictionary setValue:blankArray forKey:@"Items"];
  PBListModel *newItemListModel = [[PBListModel alloc] initWithDictionary:blankDictionary];
  [[self overviewArray] addObject:newItemListModel];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
}

-(void)saveData{
  NSMutableArray *arrayForPlist = [[NSMutableArray alloc] init];
  
  for (PBListModel *listModel in [self overviewArray]){
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    dictionary = [listModel objectForSerialization];
    [arrayForPlist addObject:dictionary];
  }

  //make the XML file
  NSError *error;
  NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:arrayForPlist format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
  NSString *filePathWithName = [self plistFilePath];
  
  if (plistData) {
    // NSLog(@"XML file created");
    [plistData writeToFile:filePathWithName atomically:YES];
  } else NSLog(@"error writing XML file");
}

#pragma mark - PRIVATE

-(NSString *)plistFilePath{
  NSString *name;
  
  //get filepath and create complete filename
  NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
  NSString *filePath = [arrayPaths objectAtIndex:0];
  name = [filePath stringByAppendingPathComponent:@"data.plist"];
  
  return name;
}
@end
