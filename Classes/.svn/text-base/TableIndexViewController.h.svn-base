#import <UIKit/UIKit.h>
//#import "MandantCollection.pb.h"
#import "MyDocument.h"
#import "MyProcess.h"
#import "MyIndex.h"
#import "DocIndexCell.h"

@interface TableIndexViewController : UITableViewController {
	//INTERFACE			
	UITextField *tfCurrency;
	
	// DATA
	//BOOL disableBackgroundView;
	NSString *selectedMandantId;
	UIPickerView *pickerView;
	MyDocument *doc;
	MyProcess *process;
	NSMutableArray *allIndexList,*dbIndexList;
	MyIndex *selectedIndex;
	DocIndexCell *selectedCell;
}
@property NSMutableArray *dbIndexList;

-(id)initWithDoc:(MyDocument*)docPar;
@end
