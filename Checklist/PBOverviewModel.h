
#import <Foundation/Foundation.h>
@class PBListModel;

@interface PBOverviewModel : NSObject

-(NSInteger)numberOfLists;
-(void)moveListAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
-(void)deleteListAtIndex:(NSInteger)index;
-(void)addNewList;
-(void)saveData;
-(PBListModel *)listAtIndex:(NSInteger)index;

@end
