#import "Translator.h"

@implementation Translator
static NSString *confUrl=@"https://my-ea.oxseed.net"; 
//DATABASE		
static char *sql;
static sqlite3 *db;
static sqlite3_stmt *compiledSql;

+(void)initWithDB:(sqlite3*)input{
	db=input;	
}
+(NSMutableDictionary*)translateAll:(NSMutableDictionary*)inputDic{
	
}

+(NSString*)translate:(NSString*)keyPar type:(NSString*)typePar{
	NSLog(@"*** translate - keyPar=%@",keyPar);
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];		
	NSString *language=[prefs stringForKey:@"Language"];
	//NSLog(@"...with Language = %@",language);
	
	// LOOK UP IN LOCAL db FIRST
	//sql = [NSString stringWithFormat:@"select * from tb_Translation where (xTranslateType='%@') and (xKey='%@') and (xLanguage='%@')",typePar,keyPar,language]; 
	sql="select * from tb_Translation";
	if(sqlite3_prepare_v2(db, sql, -1, &compiledSql, NULL) == SQLITE_OK) {			
		while(sqlite3_step(compiledSql) == SQLITE_ROW) {
			//NSLog(@"LT A RECORD");
			NSString *tmpLanguage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 0)];
			NSString *tmpTranslateType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 1)];
			NSString *tmpKey=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 2)];
			NSString *tmpValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 3)];
			
			if (([tmpKey isEqualToString:keyPar])&&([tmpTranslateType isEqualToString:typePar])&&([tmpLanguage isEqualToString:language])) {
				//NSLog(@"SELECTED SUCCESSFULLY FROM DB: %@",tmpValue);
				return tmpValue;
			}
		}
		sqlite3_finalize(compiledSql);// Release the compiled statement from memory					
	}	
	
	// BECAUSE NOT EXIST IN LOCAL DB -> QUERY TO SERVER		
	NSLog(@"Translate ---> Server");
	NSString *url=[NSString stringWithFormat:@"%@/denis/ext/oxplorer?content=translation&language=%@&login=admin&pass=oxseed&%@=%@",confUrl,language,typePar,keyPar];//Translation
	//NSLog(@"&&&& TRANSLATION URL = %@",url);
	NSData *d=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];			
	NSString *value=[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];	
	if (([value length]>30)||([value length]==0)||([value isEqualToString:@"?"])){
		//NSLog(@"!!! Old value (%@) length > 30 || =0 || ='?'==> change to keyPar=%@",value,keyPar);
		value=keyPar;
	}

	// WRITE NEW VALUE TO DB
	sql = "INSERT INTO tb_Translation(xLanguage,xTranslateType,xKey,xValue) VALUES (?,?,?,?)";		
	sqlite3_prepare_v2(db, sql, -1, &compiledSql, NULL);
	sqlite3_bind_text(compiledSql, 1, [language UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(compiledSql, 2, [typePar UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(compiledSql, 3, [keyPar UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(compiledSql, 4, [value UTF8String], -1, SQLITE_TRANSIENT);	
	sqlite3_step(compiledSql);
	
	return value;
	
}

@end
