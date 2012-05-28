#import <UIKit/UIKit.h>

@interface ProcessCell : UITableViewCell {
	UILabel *lbProcessName,*lbDate;
	UIButton *btToggle,*btEdit,*btDown,*btCheck,*btForward,*btSplit;
	UIImage *imgCheckBoxOn,*imgCheckBoxOff;	
}
@property(nonatomic,retain)UILabel *lbProcessName,*lbDate;
@property(nonatomic,retain)UIButton *btToggle,*btMore,*btDown,*btCheck,*btForward;
@end
