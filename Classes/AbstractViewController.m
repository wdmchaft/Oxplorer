#import "AbstractViewController.h"
#import "UIFactory.h"
#import "Translator.h"

@implementation AbstractViewController

-(void)viewDidLoad{
	//SPINNER
	spinner=[UIFactory spinner];	
		
	//RssReader
	rssReader=[[[RssReader alloc] init] retain];	
	
	//dictTranslator
	dictTranslator=[[NSMutableDictionary alloc] init];
	
}


// ==================================================================================================
#										pragma mark GROUP 
// ==================================================================================================
-(NSMutableArray *)getGroupListFromDB{
	NSLog(@"*** getGroupListFromDB");
	highestPosition=0;
	NSMutableArray *gl=[[NSMutableArray array] retain];			
	sql = "select * from tb_Group"; 
	if(sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL) == SQLITE_OK) {			
		while(sqlite3_step(compiledSql) == SQLITE_ROW) {
			NSLog(@"[]");
			int tmpPosition=sqlite3_column_int(compiledSql, 3);
			if (tmpPosition>highestPosition) highestPosition=tmpPosition;
			[gl addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
						   [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 0)], @"ID",
						   [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 1)], @"Name",
						   [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 2)], @"Expanded",
						   [NSString stringWithFormat:@"%d",tmpPosition], @"Position",
						   nil]];
		}
		sqlite3_finalize(compiledSql);// Release the compiled statement from memory					
	}
	NSLog(@"GL count=%d",[gl count]);
	return gl;
}
-(void)deleteGroupWithID:(int)ID{
	NSLog(@"*** deleteGroupWithID");
	//Delete Group
	sql = "DELETE FROM tb_Group WHERE xID=?";	
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_int(compiledSql, 1, ID);
	sqlite3_step(compiledSql);
	
	//Move all WB in that deleted group to NO GROUP		
	sql = "UPDATE tb_WB SET xInGroupID=0 WHERE xInGroupID=?";	
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_int(compiledSql, 1, ID);
	sqlite3_step(compiledSql);
	
	[self reloadAll];
}
-(void)changeGroupName:(NSString *)newGroupName atId:(int)ID{
	NSLog(@"*** changeGroupName");	
	sql = "UPDATE tb_Group SET xName=? WHERE xID=?";	
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_text(compiledSql, 1, [newGroupName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(compiledSql, 2, ID);	
	sqlite3_step(compiledSql);
	[self reloadAll];
}


// ==================================================================================================
#								pragma mark HANDLER & SUPPORTED METHODs
// ==================================================================================================
-(NSMutableDictionary*)translateAll_level2:(NSMutableDictionary*)inputDic{
	NSMutableArray *arrProcessTypeId=[inputDic objectForKey:@"processTypeId"];
	NSMutableArray *arrDocTypeId=[inputDic objectForKey:@"docTypeId"];
	NSMutableArray *arrIndexId=[inputDic objectForKey:@"indexId"];
}
-(NSString*)translate_level2:(NSString*)keyPar type:(NSString*)typePar{
	//NSLog(@"*** translate level 2 w/ key= %@ & type= %@",keyPar,typePar);
	if ([dictTranslator objectForKey:typePar]==NULL) {
		//NSLog(@" ~~~~~~~~~ NO SUB DICT");
		NSMutableDictionary *newDict=[[NSMutableDictionary alloc] init];
		[dictTranslator setObject:newDict forKey:typePar];
	} 
	
	NSMutableDictionary *subDict=[dictTranslator objectForKey:typePar];
	if ([subDict objectForKey:keyPar]==NULL) {
		//NSLog(@" ~~~~~~~~~ NO VALUE");
		NSString *tmpValue=[Translator translate:keyPar type:typePar];		
		[subDict setValue:tmpValue forKey:keyPar];
		return tmpValue;		
	} else {
		//NSLog(@" ~~~~~~~~~ HAVE VALUE");
		return [subDict objectForKey:keyPar];
	}

}

-(NSString*)getIndexIdFromCombinedId:(NSString*)combinedId{ // CombinedId = wbId_mandantId
	//NSLog(@"*** getIndexIdFromCombinedId: %@",combinedId);	
	return [self getWbIdFromCombinedId:combinedId];
}
-(NSString*)getIndexTypeFromCombinedId:(NSString*)combinedId{
	return [self getMandantIdFromCombinedId:combinedId];
}
-(NSString*)getWbIdFromCombinedId:(NSString*)combinedId{ // CombinedId = wbId_mandantId
	//NSLog(@"*** getWbIdFromCombinedId: %@",combinedId);
	NSRange stopRange = [combinedId rangeOfString:@"_"];
	NSString *result=[combinedId substringWithRange:NSMakeRange(0, stopRange.location)];	
	//NSLog(@"result= %@",result);
	return result;
}
-(NSString*)getMandantIdFromCombinedId:(NSString*)combinedId{
	NSLog(@"*** getMandantIdFromCombinedId: %@",combinedId);
	NSRange startRange = [combinedId rangeOfString:@"_"];
	//NSRange stopRange = [combinedId rangeOfString:@"_"];
	NSString *result=[combinedId substringWithRange:NSMakeRange(startRange.location+1,[combinedId length]-startRange.location-1)];	
	//NSLog(@"result= %@",result);
	return result;
}

-(void)checkDB{	
	//DB
	databaseName = @"db_RSSReader.sqlite";	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];	
	NSLog(@"DBPath=%@",databasePath);
	
	//if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) return;
	
	BOOL dbExisted;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	dbExisted = [fileManager fileExistsAtPath:databasePath];
	
	if(!dbExisted){
		NSLog(@"First run ! DB is not existed ! Loaded");
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
		[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];	
	}
	if(sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
		NSLog(@"CANNOT CONNECT TO DB !");
		return;
	}
	[fileManager release];
}

-(void)showAlertWithTitle:(NSString *)xTitle andMessage:(NSString *)message{
    if (xTitle==NULL) xTitle=@"Error";
    if (message==NULL) message=@"Connection errors !";
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:xTitle message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];	
	[errorAlert show];
	[errorAlert release];
}
 
-(void)loading{
    NSLog(@"yea, been loading !");
	disableBackgroundView=TRUE;
	
    loadingBG=[UIFactory loadingBG];
    [self.view addSubview:loadingBG];	
	[self.view addSubview:spinner];	
	[spinner startAnimating];
	
	NSLog(@"yea, done loading");
}
-(void)stopLoading{
	NSLog(@"yea, been STOP loading");
	disableBackgroundView=FALSE;
	[spinner stopAnimating];
	[spinner removeFromSuperview];
    [loadingBG removeFromSuperview];
	NSLog(@"yea, done STOP loading");
}





- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
