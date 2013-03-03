
#import "PBItemModel.h"

@interface PBItemModel ()


@end

@implementation PBItemModel

-(id)initWithDictionary:(NSDictionary *)dictionary{
  self = [super init];
  
  [self setItemTitle:[dictionary valueForKey:@"Title"]];
  [self setCheckedStatus:[[dictionary valueForKey:@"CheckedStatus"] boolValue]];
  
  return self;
}

-(NSDictionary *)objectForSerialization{
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  [dictionary setObject:[self itemTitle] forKey:@"Title"];
  [dictionary setObject:[NSNumber numberWithBool:[self checkedStatus]] forKey:@"CheckedStatus"];
  return dictionary;
}

+(PBItemModel *)blankItemModel{
  NSDictionary *blankDictionary = [[NSDictionary alloc] init];
  [blankDictionary setValue:@"" forKey:@"Title"];
  [blankDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"CheckedStatus"];
  PBItemModel *blankModel = [[PBItemModel alloc] initWithDictionary:blankDictionary];
  return blankModel;
}
@end
