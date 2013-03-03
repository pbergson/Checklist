
#import <Foundation/Foundation.h>

@interface PBItemModel : NSObject

@property (strong, nonatomic) NSString *itemTitle;
@property BOOL checkedStatus;

+(PBItemModel *)blankItemModel;
-(id)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)objectForSerialization;

@end
