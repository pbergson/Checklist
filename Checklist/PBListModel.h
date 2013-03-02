

#import <Foundation/Foundation.h>

@class PBItemModel;

@interface PBListModel : NSObject

@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) NSString *listTitle;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)objectForSerialization;

-(NSInteger)numberOfItems;
-(PBItemModel *)itemAtIndex:(NSInteger)index;

-(void)deleteItemAtIndex:(NSInteger)index;
-(void)addNewItem;
-(void)moveObjectAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
-(void)resetCheckedStatus;

@end
