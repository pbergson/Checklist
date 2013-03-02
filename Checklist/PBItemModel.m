
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
@end
