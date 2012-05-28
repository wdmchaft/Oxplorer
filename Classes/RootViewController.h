#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "EditGroupNameView.h"
#import "RssReader.h"
#import "AbstractViewController.h"
#import "WbViewController.h"
#import "DocViewController.h" // for develop (when WbViewController is down)
#import "MandantList.pb.h"
#import "Connector.h"
#import "Sivapbf.pb.h"

@interface RootViewController : AbstractViewController <UIAlertViewDelegate> {
	// INTERFACE	
	UIActivityIndicatorView *spinner2;
	UIBarButtonItem *btMandant,*btAddGroup,*btMoveWB,*btMore;	
	EditGroupNameView *vEditGroupName;

	// GENERAL DATA
	//*wbl,*ml in AbstractVC
	NSIndexPath *currentIndexPath;
	Connector *connector;
	WbViewController *wbViewController;
	int currentTag;
	NSString *currentCombinedWbID;
	BOOL firstLoading;
}
@end
