
#import "PBListModel.h"
#import "PBItemModel.h"
#import "constants.h"

@interface PBListModel()


@end

@implementation PBListModel

//???: You very rarely want to pass a mutable anything into a public-facing method. Passing a mutable thing means the method can modify it behind the back of the thing that passed it (this is what's known as a "leaky abstraction"). That means the thing that passed it would need to be aware that the thing it passed could change in unexpected ways, wich is really hard to do and harder to do corretly.

// The solution is to always declare methods with immutable arguments («NSDictionary *» instead of «NSMutableDictionary *»), and if you need to mutate it in the method, make a mutable copy. The copy will get changed, not the original that's passed in, and therefor the caller doesn't need to worry about it.

-(id)initWithDictionary:(NSDictionary *)dictionary{
  //???: to be technically correct, you should check to make sure «self» isn't «nil». The idiomatic way to do this is:
  // if((self = [super init])){
  //   [stuff here]
  // }
  // return self;
  self = [super init];
  [self setListTitle:[dictionary valueForKey:@"Name"]];
  [self setListArray:[[NSArray alloc] init]];
  
  //???: We don't ever mutate this array, so there's no reason for it to be mutable.
  NSArray *array = [dictionary valueForKey:@"Items"];
  //???: «itemDictionary» is never mutated nor is it used outside the for statement. No reason not to make it local to the loop.
  NSInteger i = 0;
  for (i=0; i<[array count]; i++) {
    NSDictionary *itemDictionary = [array objectAtIndex:i];
    itemDictionary = [array objectAtIndex:i];
    PBItemModel *itemModel = [[PBItemModel alloc] initWithDictionary:itemDictionary];
    [[self listArray] addObject:itemModel];
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
  NSLog(@"dictionary is mutable? %@", [dictionary isKindOfClass:[NSDictionary class]]);
  return [dictionary copy];
}

-(NSInteger)numberOfItems{
  return [[self listArray] count];
}

-(PBItemModel *)itemAtIndex:(NSInteger)index{
  return [[self listArray] objectAtIndex:index];
}

-(void)deleteItemAtIndex:(NSInteger)index{
  //???: «NSMutableArray *array = [[self listArray] mutableCopy]» is more idiomatic.
  NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[self listArray]];
  [array removeObjectAtIndex:index];
  [self setListArray:array];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
}

-(void)addNewItem{
  //???: This totally works. But it would be more clear (and DRY) if you added a class method like: «[PBItemModel blankItem]» and called that instead of making the blank dictionary here.
  NSMutableDictionary *blankDictionary = [[NSMutableDictionary alloc] init];
  [blankDictionary setValue:@"" forKey:@"Title"];
  [blankDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"CheckedStatus"];
  PBItemModel *newItemModel = [[PBItemModel alloc] initWithDictionary:blankDictionary];

  [[self listArray] addObject:newItemModel];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
}

-(void)moveObjectAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex{
  PBItemModel *itemToMove = [[self listArray] objectAtIndex:sourceIndex];
  [[self listArray] removeObjectAtIndex:sourceIndex];
  [[self listArray] insertObject:itemToMove atIndex:destinationIndex];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
}

-(void)resetCheckedStatus{
  
  for (PBItemModel *itemModel in [self listArray]) {
    [itemModel setCheckedStatus:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBModelDidChangeNotification object:self];
  }
}
@end
