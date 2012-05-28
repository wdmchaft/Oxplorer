#import "Connector.h"
#import "XMLReader.h"
#import "ThatkoLib.h"

@implementation Connector 

NSString *const MODE=@"PBF"; // PBF/XML/TEST
NSString *rootUrl=@"http://174.143.148.49/Oxplorer_TestData_XML/";
NSString *confUrl=@"https://my-ea.oxseed.net"; 
//NSString *confUrl=@"http://192.168.16.121:8888"; 
//NSString *sivaUrl=@"http://192.168.16.121:8080";
NSString *sivaUrl=@"https://my-dev.oxseed.net";
//NSString *sivaUrl=@"https://my.oxseed.testdev/moxseed";


-(id)initWithDB:(sqlite3*)input{
	if (self=[super init]){
		NSLog(@"***initWithDB");
		database=input;
	}
	return self;
}
// ==================================================================================================
#										pragma mark MANDANT
// ==================================================================================================
-(NSMutableArray*)getMandantList_fetchServer:(BOOL)fetchServer syncDb:(BOOL)syncDb{ 	
	NSLog(@"*** getMandantList");
	if (fetchServer) [self getServerMandantList];
	if (syncDb) [self getDbMandantList];
	if ((!fetchServer)&&(!syncDb)) return ml;
	NSLog(@"DB X 1");
	ml=[[NSMutableArray alloc] init];		
	
	for (Mandant *m in sv_ml) {
		[ml addObject:[[Mandant alloc] initWithId:m.id name:m.name]]; // cannot use ml=[sv_ml copy] because it only copies address
	}	
//	[ml addObject:[[Mandant alloc] initWithId:@"test" name:@"test"]]; 
//	[ml addObject:[[Mandant alloc] initWithId:@"denis" name:@"denis"]]; 
//	[ml addObject:[[Mandant alloc] initWithId:@"rajan2410" name:@"rajan2410"]]; 
	
	
	NSLog(@"DB X 2");
	NSLog(@"db_ml count = %d",[db_ml count]);
	for (Mandant *m in ml) {				
		for (Mandant *db_m in db_ml) {			
			if ([m.id isEqualToString:db_m.id]) {
				[m setIsAdded:TRUE];
				break;   
			}
		}
	}
	NSLog(@"DB X 3");
	//NSLog(@"return ml with count=%d",[ml count]);
	return ml;
}
-(BOOL)getServerMandantList{ //and delete db mandants which server doesn't have	
	NSLog(@"*** getServerMandantList");
	sv_ml=[[NSMutableArray alloc] init];
	NSString *url=[NSString stringWithFormat:@"%@/oxseedadmin/ext/oxplorer?content=mandantList&login=admin&pass=oxseed",confUrl]; //MandantList
	NSLog(@" url = %@",url);
	NSData  *d;	
	@try { d = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];}
	@catch (id theException) {
		NSLog(@"~~~~~~~~~~ [EXCEPTION] GETTING MANDANT LIST = %@", theException);				
		return FALSE;
	} 
	@finally {}
	
	if (!d){
		NSLog(@"Network Error ???");
		return FALSE; 
	}
	
	sv_ml=[[[MandantList parseFromData:d] mutableMandantList] copy];
	NSLog(@" SV_ML COUNT = %d",[sv_ml count]);
	// DELETE DB MANDANTS THAT SERVER DOESN'T HAVE --> DONT NEED ANYMORE, maybe server'll have it again 
	/*
	[self getDbMandantList];
	for (Mandant *db_m in db_ml) {
		BOOL existsInServer=FALSE;
		for (Mandant *sv_m in sv_ml) {
			if ([db_m.id isEqualToString:sv_m.id]){
				existsInServer=TRUE;
			}
		}
		if (!existsInServer) [self deleteDbMandantId:db_m.id];
	}	*/
	return TRUE;
}

-(NSMutableArray*)getDbMandantList{		
	NSLog(@"*** getDbMandantList");
	db_ml=[[NSMutableArray alloc] init];		
	sql = "select * from tb_Mandant"; 
	if(sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL) == SQLITE_OK) {			
		while(sqlite3_step(compiledSql) == SQLITE_ROW) {
			NSString *tmpMandantId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 0)];
			NSLog(@"[] dbMandantId=%@",tmpMandantId);
			[db_ml addObject:[[Mandant alloc] initWithId:tmpMandantId]];
		}
		sqlite3_finalize(compiledSql);// Release the compiled statement from memory					
	}		

	NSLog(@" XXXXXXXXXX DB_ML COUNT = %d",[db_ml count]);
	return db_ml;
}
			 
-(void) deleteDbMandantId:(NSString *)mandantID{
	NSLog(@"*** deleteDbMandantId: %@",mandantID);
	sql = "DELETE FROM tb_Mandant WHERE xID=?";	
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_text(compiledSql, 1, [mandantID UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_step(compiledSql);	
}
			 
-(void) removeMandant:(NSString *)mandantID{ 
	[self deleteDbMandantId:mandantID];
	//[self getDbMandantList];
}
			 
-(void) addMandant:(NSString *)mandantID{
	sql = "INSERT INTO tb_Mandant(xID) VALUES (?)";		
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_text(compiledSql, 1, [mandantID UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_step(compiledSql);
	//[self getDbMandantList];	
}						

// ==================================================================================================
#										pragma mark WORKBASKET
// ==================================================================================================
-(NSMutableArray*)getWbList_fetchServer:(BOOL)fetchServer fetchPID:(BOOL)fetchPID syncPID:(BOOL)syncPID syncGroup:(BOOL)syncGroup {
	// NOTE:  + fetchPID here means fetch BOTH PID (unread/total) & LastBuildDate	
	//        + syncGroup here means both SYNC NAME and inGroupId from local DB
	NSLog(@"*** getWbList");
	if ((!fetchServer)&&(!fetchPID)&&(!syncPID)&&(!syncGroup)) return wbl; 
	NSLog(@"DB1");
	// DENIS: ***ID (name tmp)***, ***inMandantId***, ***type***
	if (fetchServer){
		if (![self getServerWbList]) return NULL;
	} else {
		if (sv_wbl==NULL) return NULL;
	}
	NSLog(@"DB2");
	wbl=[[NSMutableArray alloc] init];
	NSLog(@"DB3");
	for (Wb *wb in sv_wbl) {
		NSLog(@"[] wb %@",wb.id);
		[wbl addObject:[[Wb alloc] initWithId:wb.id inMandantId:wb.inMandantId type:wb.type]];
	}	
	NSLog(@"DB4 getWbList");
	if ([wbl count]==0){
		NSLog(@"wbl count==0");
		return wbl;
	}
	NSLog(@"DB5");
	// SIVA:  *** LASTBUILDDATE *** , *** UNREAD ***, ***TOTAL***
	if (fetchPID){
		if (![self getAllBasketsPidAndDate]) return NULL;
	} else {
		if (arrABasketPidAndDate==NULL) return NULL;
	}
	NSLog(@"DB6");
	
	NSLog(@" count = %d",[arrABasketPidAndDate count]);
	for (A_Basket_ProcessId_And_Date *aBasketProcessIdAndDate in arrABasketPidAndDate) {
		NSLog(@"DB61 -- %@",[aBasketProcessIdAndDate lastBuildDate]);
		for (Wb *wb in wbl) {						
			NSLog(@"DB62");
			if ([[aBasketProcessIdAndDate basketId] isEqualToString:[NSString stringWithFormat:@"%@_%@",wb.id,wb.inMandantId]]) {
			//if ([[aBasketProcessIdAndDate basketId] isEqualToString:wb.id]) {				
				NSLog(@"DB63");
				[wb setLastBuildDate:[aBasketProcessIdAndDate lastBuildDate]];
			}
			NSLog(@"DB64");
		}
		NSLog(@"DB65");
	}	
	NSLog(@"DB7");	
	// LOCAL DB: *** NAME ***, *** IN GROUP ID ***
	if (syncGroup) [self getDbWorkbasketList];
	else if (db_wbl==NULL) return NULL;
	NSLog(@"DB8");		 		 
	for (Wb *db_wb in db_wbl) {
		for (Wb *wb in wbl) {
			if ( ([[db_wb id] isEqualToString:[wb id]]) && ([[db_wb inMandantId] isEqualToString:[wb inMandantId]]) ) {
				[wb setName:[db_wb name]];
				[wb setInGroupId:[db_wb inGroupId]];
			}
		}
	}
	NSLog(@"DB9");
	// INSERT NEW WB TO DB (if (fetchServer==TRUE) )
	NSLog(@"~~~ Insert new WB to DB");
	if (fetchServer){
		NSLog(@"YES");
		BOOL existsInDb;
		for (Wb *wb in wbl) {
			existsInDb=FALSE;
			for (Wb *db_wb in db_wbl) {
				if ( ([[db_wb id] isEqualToString:[wb id]]) && ([[db_wb inMandantId] isEqualToString:[wb inMandantId]]) ) {
					existsInDb=TRUE;
					break;
				}
			}
			if (existsInDb) continue;
			// else
			
			sql = "INSERT INTO tb_WB(xID,xInMandantId,xName,xInGroupID) VALUES (?,?,?,0)";				
			sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);			
			sqlite3_bind_text(compiledSql, 1, [[wb id] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledSql, 2, [wb.inMandantId UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledSql, 3, [[wb name] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_step(compiledSql);					
		}
	}
	NSLog(@"DB10");	
	// [Siva + LocalDB] ***UNREAD/TOTAL*** 
	NSLog(@"~~~ [Siva + LocalDB] ***UNREAD/TOTAL***");
	if (syncPID) [self getDbProcessList];
	else if (db_pl==NULL) return NULL;
		 
	for (Wb *wb in wbl) {
		for (A_Basket_ProcessId_And_Date *aBasketProcessIdAndDate in arrABasketPidAndDate) {
			if ([[aBasketProcessIdAndDate basketId] isEqualToString:[NSString stringWithFormat:@"%@_%@",wb.id,wb.inMandantId]]) {
			//if ([[aBasketProcessIdAndDate basketId] isEqualToString:wb.id]) {
				NSMutableArray *pidList=[aBasketProcessIdAndDate mutablePIdList];
				[wb setTotal:[pidList count]];
				int unread=[pidList count];
				for (NSString *pId in pidList) {
					for (MyProcess *myProcess in db_pl) {
						if ([myProcess.pid isEqualToString:pId]) {
							if (myProcess.isRead) {
								unread--;
							}
						}
					}
				}
				[wb setUnread:unread];
			}
		}
	}	
	NSLog(@"&&& TEST LASTBUILDDATE B4 RETURN: %@",[[wbl objectAtIndex:0] lastBuildDate]);
	return wbl;
}

-(BOOL)getServerWbList{
	 NSLog(@"*** getServerWbList");
	 sv_wbl=[[NSMutableArray alloc] init]; //Note: sv_wbl is wbl of all mandants
	 if ([ml count]==0){
		NSLog(@" !!!! ml count == 0");
		return sv_wbl;
	 }	
	 NSString *url;	
	 for (Mandant *m in ml){
		 //NSLog(@"[] m=%@ , isAdded=%@",m.id,m.isAdded);
		 if (m.isAdded) {
			 url=[NSString stringWithFormat:@"%@/%@/ext/oxplorer?content=wbList&login=admin&pass=oxseed",confUrl,m.id]; //wbList						
			 NSLog(@"NEW LOG *********** url=%@",url);
			 NSData  *d = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];	
			 if (!d) return FALSE;
			 NSLog(@"xx1");
			 WbList *pbfWbList=[WbList parseFromData:d];	
			 NSLog(@"xx2");
			 for (Wb *wb in [pbfWbList mutableWbList]) {						
				 NSLog(@"xx3");					
				 //[wb setName:wb.id]; //temporarily set wb name = wb id
				 [wb setInMandantId:m.id];
				 [sv_wbl addObject:wb];
			 }
		 }
	 }	
	 return TRUE;
}
		 
-(BOOL)getAllBasketsPidAndDate{
	 // -- NOTE: Response BasketId (siva) = wbid_mandantId		 
	 NSString *wbsString; // (~WBs string) to query LastBuildDate and process id list (Siva's service)
	 int count=0;
	 for (Wb *wb in sv_wbl){
		 if (count==0) wbsString=[NSString stringWithFormat:@"%@_%@",wb.id,wb.inMandantId];
		 else {
			 wbsString=[NSString stringWithFormat:@"%@,%@_%@",wbsString,wb.id,wb.inMandantId];
		 }
		 count++;
	 }
	 NSString *url=[NSString stringWithFormat:@"%@/moxseed/spring/basketapp?basketIds=%@&responseType=protobuf&action=getbasketsprocessidslist",sivaUrl,wbsString];	
	 NSLog(@"Siva URL = %@",url);
	 NSData  *d = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];		
	 if (!d){
		 NSLog(@"SIVA DATA ERROR !!!");
		 return FALSE;
	 }	
	 //allBasketsProcessIdAndDate=[All_Baskets_ProcessId_And_Date parseFromData:d];	
	 arrABasketPidAndDate=[[[All_Baskets_ProcessId_And_Date parseFromData:d] mutableABasketProcessIdAndDateList] copy];
}		 
			 
-(void)getDbWorkbasketList{	
	db_wbl=[[NSMutableArray alloc] init];
	sql = "select * from tb_WB"; 
	if(sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL) == SQLITE_OK) {			
		while(sqlite3_step(compiledSql) == SQLITE_ROW) {
			NSString *tmpId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 0)];
			NSString *tmpInMandantId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 1)];
			NSString *tmpName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 2)];
			int *tmpInGroupId=(int)sqlite3_column_int(compiledSql, 3);
			[db_wbl addObject:[[Wb alloc] initWithId:tmpId inMandantId:tmpInMandantId name:tmpName inGroupId:tmpInGroupId]];
		}
		sqlite3_finalize(compiledSql);// Release the compiled statement from memory					
	}		
}
			 
// ==================================================================================================
#										pragma mark PROCESS
// ==================================================================================================
-(NSMutableArray *)getProcessListOfCombinedWbId:(NSString*)combinedWbId fetchServer:(BOOL)fetchServer syncDb:(BOOL)syncDb{
	NSLog(@"*** getProcessListOfCombinedWbId");
	
	// CHECK PARAMETERs
	if ((!syncDb)&&(db_pl==NULL)){
		NSLog(@"### ERR ### DB_PL = NULL");
		return NULL;
	}
	if ((!fetchServer)&&(sv_pl==NULL)){
		NSLog(@"### ERR ### SV_PL = NULL");
		return NULL;
	}
	if ((!fetchServer)&&(!syncDb)) return pl;
	
	// MAIN
	if (syncDb) {
		[self getDbProcessList];  // [- PROCESS TYPE MAYBE CHANGED -]
		[self getDbDocumentList]; // [- DOC TYPE MAYBE CHANGED -]
		[self getDbIndexList];	  // [- INDEX VALUE MAYBE CHANGED -]
	}
	if (fetchServer) {
		[self fetchSvProcessListOfCombinedWbId:combinedWbId];
	}
	pl=[[NSMutableArray alloc] init];
	for (Process *p in [processList mutableProcessList]) {
		NSLog(@"[] %@",p.pId);
		NSString *tmpPId=[p pId];
		NSString *tmpOrderId=[p orderId];
		NSString *tmpTypeId=[p typeId];
		NSString *tmpEntryDate=[p entryDate];
		NSString *tmpResubmitDate=[p resubmitDate];		
		NSMutableArray *tmpArrMyDoc=[self convertPbfDocumentList:[p documentList] withOrderId:tmpOrderId];
		MyProcess *newMyProcess=[[MyProcess alloc] initWithPId:tmpPId orderId:tmpOrderId typeId:tmpTypeId entryDate:tmpEntryDate resubmitDate:tmpResubmitDate arrDoc:tmpArrMyDoc];
		[pl addObject:newMyProcess];		
	}
	
	// TO-DO: COMPARE WITH LOCAL DB TO OVERWRITE TYPE ID
	
	NSLog(@"PL COUNT = %d",[pl count]);
	return pl;
}
-(void)fetchSvProcessListOfCombinedWbId:(NSString*)combinedWbId{
	NSLog(@"*** fetchSvProcessListOfCombinedWbId");
	NSString *url=[NSString stringWithFormat:@"%@/moxseed/spring/basketapp?basketIds=%@&responseType=protobuf&action=getbasketprocessinfolist",sivaUrl,combinedWbId];	
	NSLog(@"URL=%@",url);
	NSData *d = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];	
	processList=[ProcessList parseFromData:d];
	NSLog(@"TEST PBF PROCESS LIST = %d",[[processList mutableProcessList] count]);
}
-(void)getDbProcessList{
	NSLog(@"*** getDbProcessList");
	db_pl=[[NSMutableArray alloc] init];
	sql = "select * from tb_Process";
	if(sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL) == SQLITE_OK) {			
		while(sqlite3_step(compiledSql) == SQLITE_ROW) {
			NSString *tmpPID=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 0)];
			NSString *tmpTypeId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 1)];			
			BOOL *tmpIsRead=(BOOL)sqlite3_column_int(compiledSql, 3);
			[db_pl addObject:[[MyProcess alloc] initWithPId:tmpPID isRead:tmpIsRead typeId:tmpTypeId]];
		}
		sqlite3_finalize(compiledSql);// Release the compiled statement from memory					
	}
}
			 
// ==================================================================================================
#										pragma mark DOCUMENT
// ==================================================================================================													   
-(void)getDbDocumentList{
	NSLog(@"*** getDbDocumentList");
	db_dl=[[NSMutableArray alloc] init];
	sql = "select * from tb_Document";
	if(sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL) == SQLITE_OK) {			
		while(sqlite3_step(compiledSql) == SQLITE_ROW) {
			NSString *tmpDId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 0)];
			NSString *tmpTypeId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 1)];			
			[db_dl addObject:[[MyDocument alloc] initWithId:tmpDId typeId:tmpTypeId]];
		}
		sqlite3_finalize(compiledSql);// Release the compiled statement from memory					
	}
}
-(NSMutableArray*)convertPbfDocumentList:(DocumentList*)documentList withOrderId:(NSString*)orderIdPar{
	NSLog(@"*** convertPbfDocumentList");
	NSMutableArray *arrMyDoc=[[NSMutableArray alloc] init];
	for (Document *doc in [documentList mutableDocumentList]) {
		[arrMyDoc addObject:[self convertPbfDocument:doc withOrderId:orderIdPar]];
	}
	return arrMyDoc;
}													   
-(MyDocument*)convertPbfDocument:(Document *)doc withOrderId:(NSString*)orderIdPar{
	NSLog(@"*** convertPbfDocument");
	NSString *tmpDId=[doc dId];
	NSString *tmpTypeId=[doc typeId];
	int *tmpPageCount=[doc pageCount];
	IndexList *tmpIndexList=[doc indexList];
	NSMutableArray *tmpArrMyIndex=[self convertPbfIndexList:tmpIndexList withDocId:tmpDId];
	
	// TO-DO:
	// COMPARE WITH LOCAL DATABASE TO:	
	//	+ OVERWRITE DOC TYPE (CHANGED)	
	
	return [[MyDocument alloc] initWithId:tmpDId typeId:tmpTypeId pageCount:tmpPageCount arrIndex:tmpArrMyIndex];
}

// ==================================================================================================
#										pragma mark INDEX 
// ==================================================================================================			 
-(void)getDbIndexList{
	NSLog(@"*** getDbIndexList");
	db_il=[[NSMutableArray alloc] init];
	sql = "select * from tb_Document";
	if(sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL) == SQLITE_OK) {			
		while(sqlite3_step(compiledSql) == SQLITE_ROW) {
			NSString *tmpId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 0)];
			NSString *tmpDocId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 1)];
			NSString *tmpName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 2)];
			NSString *tmpValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 3)];
			int tmpSegmentId=(int)sqlite3_column_int(compiledSql, 4);			
			[db_il addObject:[[MyIndex alloc] initWithId:tmpId docId:tmpDocId name:tmpName value:tmpValue segmentId:tmpSegmentId]];
		}
		sqlite3_finalize(compiledSql);// Release the compiled statement from memory
	}
}
-(NSMutableArray*)convertPbfIndexList:(IndexList*)indexList withDocId:(NSString*)docId{
	NSLog(@"*** convertPbfIndexList");
	NSMutableArray *arrMyIndex=[[NSMutableArray alloc] init];
	for (Index *i in [indexList mutableIndexList]) {
		NSString *tmpId=[i indexId];
		NSString *tmpDocId=docId;
		NSString *tmpName=[i indexId]; // TEMP. NEED TO GET TRANSLATED
		NSString *tmpValue=[i indexValue];		
		int *tmpSegmentId=-1;
		
		// CHECK IF INDEX EXIST IN DATABASE. If EXIST, get [Name], [SegmentId] and overwrite [value]			
		for (MyIndex *myI in db_il) {
			if (([myI.docId isEqualToString:docId])&&([myI.id isEqualToString:[i indexId]])) {
				tmpValue=myI.value;
				tmpName=myI.name;
				tmpSegmentId=myI.segmentId;
			}
		}		
		MyIndex *tmpMyIndex=[[MyIndex alloc] initWithId:tmpId docId:tmpDocId name:tmpName value:tmpValue segmentId:tmpSegmentId];
		[arrMyIndex addObject:tmpMyIndex];
	}
	return arrMyIndex;
}
-(NSMutableArray*)getAllPossibleIndexesForDocTypeId:(NSString*)docTypeId{
	NSString *url=[NSString stringWithFormat:@"%@/denis/ext/oxplorer?content=indexList&login=admin&pass=oxseed&docTypeId=%@",confUrl,docTypeId]; 	
	NSLog(@" Denis-All Possible Indexes For DocType %@: %@",docTypeId,url);
	NSData  *d;	
	@try { d = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];}
	@catch (id theException) {
		NSLog(@"~~~~~~~~~~ [EXCEPTION] ALL POSSIBLE INDEXES LIST");				
		return FALSE;
	} 
	@finally {}
	
	if (!d){
		NSLog(@"Network Error- All Possible Indexes");
		return FALSE; 
	}
	
}
@end
