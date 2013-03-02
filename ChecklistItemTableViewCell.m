
#import "ChecklistItemTableViewCell.h"

@implementation ChecklistItemTableViewCell

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
  [super setHighlighted:highlighted animated:animated];
  if (highlighted) {
    [[self textField] setTextColor:[UIColor whiteColor]];
  } else {
    [[self textField] setTextColor:[UIColor blackColor]];
  }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
  [super setSelected:selected animated:animated];
  if (selected){
    [[self textField] setTextColor:[UIColor whiteColor]];
  } else {
    [[self textField] setTextColor:[UIColor blackColor]];
  }
}
@end
