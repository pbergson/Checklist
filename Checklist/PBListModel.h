

#import <Foundation/Foundation.h>

@class PBItemModel;

@interface PBListModel : NSObject

@property (strong, nonatomic) NSArray *listArray;
@property (strong, nonatomic) NSString *listTitle;

+(PBListModel *)blankListModel;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)objectForSerialization;

-(NSInteger)numberOfItems;
-(PBItemModel *)itemAtIndex:(NSInteger)index;

-(void)deleteItemAtIndex:(NSInteger)index;
-(void)addNewItem;
-(void)moveObjectAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
-(void)resetCheckedStatus;

@end
