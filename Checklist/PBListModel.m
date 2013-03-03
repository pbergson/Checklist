
#import "PBListModel.h"
#import "PBItemModel.h"
#import "constants.h"

@interface PBListModel()


@end

@implementation PBListModel

+(PBListModel *)blankListModel{
  NSMutableDictionary *blankDictionary = [[NSMutableDictionary alloc] init];
  [blankDictionary setValue:@"" forKey:@"Name"];
  [blankDictionary setValue:@[] forKey:@"Items"];
  return [[PBListModel alloc] initWithDictionary:blankDictionary];
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
  self = [super init];
  if (self){
    [self setListTitle:[dictionary valueForKey:@"Name"]];
    [self setListArray:[[NSArray alloc] init]];
    
    NSArray *array = [dictionary valueForKey:@"Items"];
    NSMutableArray *mutableListArray = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    for (i=0; i<[array count]; i++) {
      NSDictionary *itemDictionary = [array objectAtIndex:i];
      itemDictionary = [array objectAtIndex:i];
      PBItemModel *itemModel = [[PBItemModel alloc] initWithDictionary:itemDictionary];
      [mutableListArray addObject:itemModel];
    }
    [self setListArray:mutableListArray];
  }
  return self;
}


#pragma mark - PUBLIC

-(NSDictionary *)objectForSerialization{
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  [dictionary setObject:[self listTitle] forKey:@"Name"];
  NSMutableArray *plistArray = [[NSMutableArray alloc] init];
 
  NSInteger i = 0;
  for (i=0; i<[[self listArray] count]; i++) {
    NSDictionary *plistDictionary = [[[self listArray] objectAtIndex:i] objectForSerialization];
    [plistArray addObject:plistDictionary];
  }
  [dictionary setObject:plistArray forKey:@"Items"];
  return [dictionary copy];
}

-(NSInteger)numberOfItems{
  return [[self listArray] count];
}

-(PBItemModel *)itemAtIndex:(NSInteger)index{
  return [[self listArray] objectAtIndex:index];
}

-(void)deleteItemAtIndex:(NSInteger)index{
  NSMutableArray *array = [[self listArray] mutableCopy];
  [array removeObjectAtIndex:index];
  [self setListArray:array];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
}

-(void)addNewItem{
  PBItemModel *newItemModel = [[PBItemModel class] blankItemModel];
  NSMutableArray *mutableListArray = [[self listArray] mutableCopy];
  [mutableListArray addObject:newItemModel];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
  [self setListArray:mutableListArray];
}

-(void)moveObjectAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex{
  PBItemModel *itemToMove = [[self listArray] objectAtIndex:sourceIndex];
  NSMutableArray *mutableListArray = [[self listArray] mutableCopy];
  [mutableListArray removeObjectAtIndex:sourceIndex];
  [mutableListArray insertObject:itemToMove atIndex:destinationIndex];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
  [self setListArray:mutableListArray];
}

-(void)resetCheckedStatus{
  
  for (PBItemModel *itemModel in [self listArray]) {
    [itemModel setCheckedStatus:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
  }
}
@end
