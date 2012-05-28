#import <UIKit/UIKit.h>

@interface DocIndexCell : UITableViewCell {
	UILabel *lbTitle,*lbContent;
	UITextField *tfContent;
	UIButton *btChange,*btSave,*btCancel;
}
@property(nonatomic,retain)UILabel *lbTitle,*lbContent;
@property(nonatomic,retain)UIButton *btChange,*btSave,*btCancel;
@property(nonatomic,retain)UITextField *tfContent;

@end
