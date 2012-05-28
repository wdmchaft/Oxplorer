#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "Connector.h"

@interface MoveWbViewController : AbstractViewController {
	// INTERFACE
	UIButton *btCheckBox,*btSelectGroup;	
	UIImage *imgCheckBoxOn, *imgCheckBoxOff;
	UILabel *lbGroupName;
	NSMutableArray *arrChangedWbCombinedId;
	NSMutableDictionary *destGroup,*changedWbList;
	UIScrollView *scrollView;
	
	//DATA
	Connector *connector;	
}

@end
