#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Connector.h"
#import "AbstractViewController.h"
#import "MandantCollection.pb.h"

#import "MyMandant.h"
#import "WorkBasket.h"
#import "MyProcess.h"
#import "Sivapbf.pb.h"

@class ProcessViewController;
@interface WbViewController : AbstractViewController {
	// INTERFACE
	UIButton *btForward,*btReturn,*btJoin,*btSorting;
	UIImage *imgCheckBoxOff,*imgCheckBoxOn;
	UIView *v1; // contains 3 buttons: Select/deselect all + Collapse all + Expand all
	UIView *vProcessFunction;
	UIButton *btSelectAll,*btDeselectAll,*btExpandAll,*btCollapseAll;
	
	// DATA
	BOOL shouldShowIndex;
	NSString *currentProcessId;
	NSIndexPath* currentIndexPath;
	NSMutableDictionary *dictExpandedProcess,*dictSelectedProcess,*dictImgThumb;	
	Wb *wb;		
	Connector *connector;
	NSMutableArray *arrProcess; 
}

@end
