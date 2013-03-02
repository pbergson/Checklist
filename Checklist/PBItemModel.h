
#import <Foundation/Foundation.h>

@interface PBItemModel : NSObject

@property (strong, nonatomic) NSString *itemTitle;
@property BOOL checkedStatus;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)objectForSerialization;

@end
