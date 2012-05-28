#import <UIKit/UIKit.h>
//#import "MandantCollection.pb.h"
#import <sqlite3.h>
//#import "MyMandant.h"
#import "WorkBasket.h"
#import "MyProcess.h"
#import "MyDocument.h"
#import "MyIndex.h"
#import "MandantList.pb.h"
#import "WbList.pb.h"
#import "Sivapbf.pb.h"

@interface Connector : NSObject {		
	// DATA
	NSMutableArray *ml,*sv_ml,*db_ml,*wbl,*sv_wbl,*db_wbl,*db_pl,*sv_pl,*pl,*db_dl,*db_il; // [sv=server, db=database]
	ProcessList *processList;
	All_Baskets_ProcessId_And_Date *allBasketsProcessIdAndDate;
	NSMutableArray *arrABasketPidAndDate;
	
	//DATABASE		
	char *sql;
	sqlite3 *database;
	sqlite3_stmt *compiledSql;	
}

/*
+(void)initWithDB:(sqlite3*)input;
+(NSMutableArray *)getDbIndexListOfDoc:(MyDocument*)doc;
+(void)fetchDocumentAndUpdateProcessOfWb:(NSString*)wbId;
+(void)fetchProcessDict:(NSMutableDictionary*)dict forWb:(WorkBasket*)wb;
+(MyDocument*)getDocumentOfDict:(NSMutableDictionary*)dictDoc;
+(void)fetchProcessIdListForWorkBaskets;
+(void)syncProcess;
+(NSMutableArray *)getProcessListFromDB;
+(void)fetchWorkBasket;
+(void)syncWorkBasket;
+(NSString *)getNameOfWbID:(NSString*)wbID;
 */
@end
