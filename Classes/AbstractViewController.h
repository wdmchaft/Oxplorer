#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "RssReader.h"

@interface AbstractViewController : UIViewController {
	//INTERFACE
	UIActivityIndicatorView *spinner; 
	UIView *loadingBG;
	
	//DATA
	NSUserDefaults *prefs;
	BOOL disableBackgroundView;
	NSData *rawData;
	UITableView *tableView;
	NSAutoreleasePool * pool;
	RssReader *rssReader;
	int highestPosition; //getGroupListFromDB
	NSMutableArray *groupList,*wbl,*ml;//,*dbWbList,*pbfWbList,*dbProcessList,*pbfMandantList,*dbMandantList; => FOR ROOTVC & MOVE_WB_VC
	NSMutableDictionary *dictTranslator;
	NSString *selectedMandantId;
	
	//DATABASE
	NSString *databaseName,*databasePath;
	sqlite3 *database;
	char *sql;
	sqlite3_stmt *compiledSql;
	
}

@end
