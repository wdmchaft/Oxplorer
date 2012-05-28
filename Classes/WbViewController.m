#import "WbViewController.h"
#import "RssReader.h"
#import "RootViewController.h";
#import "UIFactory.h";
#import "ThatkoLib.h"
#import "TimeConverter.h"
#import "Translator.h"
#import "ProcessCell.h";
#import "DocumentCell.h"

#import "MyMandant.h"
#import "WorkBasket.h"
#import "MyProcess.h"
#import "MyDocument.h"
#import "MyIndex.h"

@implementation WbViewController
static int nCharsPerLine=45;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[spinner removeFromSuperview];
}
-(id)initWithWb:(Wb *)wbPar{
	self=[super init];
	if (self) {		
		wb=wbPar;
		NSString *combinedWbId=[NSString stringWithFormat:@"%@_%@",wb.id,wb.inMandantId];
		selectedMandantId=wb.inMandantId;
			
		//self.title=[NSString stringWithFormat:@"[%@] %@",wb.inMandantId,wb.name];
		UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
		tlabel.text=[NSString stringWithFormat:@"[%@] %@",wb.inMandantId,wb.name];
		NSLog(@"~~~ Mandant ID = %@",wb.inMandantId);
		tlabel.textColor=[UIColor whiteColor];
		tlabel.backgroundColor =[UIColor clearColor];
		tlabel.adjustsFontSizeToFitWidth=YES;
		self.navigationItem.titleView=tlabel;
		
		[self checkDB];	
		//[Connector fetchDocumentAndUpdateProcessOfWb:wb.id];
		connector=[[Connector alloc] initWithDB:database];	
		arrProcess=[connector getProcessListOfCombinedWbId:combinedWbId fetchServer:TRUE syncDb:TRUE];
		NSLog(@"TEST ARRDOC COUNT = %d",[[[arrProcess objectAtIndex:0] arrDoc] count]);
	}
	return self;
}
- (void)viewDidLoad {
	NSLog(@"*** WbVC- View did load");
    [super viewDidLoad];
	NSLog(@"DB1");
	[self.view setBackgroundColor:[UIColor blackColor]];	
	prefs=[NSUserDefaults standardUserDefaults];
	NSLog(@"DB2");		
		
	// CHANGE ALL PROCESS TO STATUS "READ"	
	[self changeAllProcessesToReadStatus];
	
	// GET DICT OF IMG THUMB
	UIImage *defaultThumbnail=[UIImage imageNamed:@"DefaultThumbnail.png"];
	dictImgThumb=[[NSMutableDictionary alloc] init];
	for (MyProcess *aP in arrProcess) {
		for (MyDocument *d in aP.arrDoc) {
			NSString *imgThumbURL=[NSString stringWithFormat:@"http://192.168.16.121:8080/services/ocr-archive?action=show_image&document_id=%@&mandant=%@&max_width=64&max_height=89",d.dId,selectedMandantId];
			//NSLog(@"imgThumbUrl = %@",imgThumbURL);
			UIImage *imgThumb=[[UIImage alloc] initWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgThumbURL]]];
			if (imgThumb==nil){			
				//NSLog(@"ERROR MANDANT = %@ ",selectedMandantId);
				//imgThumbURL=@"http://174.143.148.49/RssSample3.1/mandant/imgs/tn1.png";		
				//imgThumb=[[UIImage alloc] initWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgThumbURL]]];
				imgThumb=defaultThumbnail;
			} 
			[dictImgThumb setObject:imgThumb forKey:d.dId];
		}
	}
	
	// MAKE ALL PROCESS DESELECTED
	dictSelectedProcess=[[NSMutableDictionary alloc] init];
	for (MyProcess *aP in arrProcess) {
		[dictSelectedProcess setObject:@"0" forKey:aP.pid];
	}
	
	// MAKE ALL PROCESS EXPANSED
	dictExpandedProcess=[[NSMutableDictionary alloc] init];
	for (MyProcess *aP in arrProcess) {
		[dictExpandedProcess setObject:@"1" forKey:aP.pid];
	}	
	
	
	// TOOLBAR ITEMS
	btForward = [[UIBarButtonItem alloc] initWithTitle:@"Forward" style:UIBarButtonItemStyleBordered target:self action:@selector(btForwardClicked)];
	btReturn = [[UIBarButtonItem alloc] initWithTitle:@"Return" style:UIBarButtonItemStyleBordered target:self action:@selector(btReturnClicked)];
	btJoin = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStyleBordered target:self action:@selector(btJoinClicked)];
	NSArray *items = [[NSArray alloc] initWithObjects: btForward,btReturn,btJoin,nil];
	[self setToolbarItems: items];			
	NSLog(@"DB3");
	
	// INTERFACE
	v1=[UIFactory roundedViewWithFrame:CGRectMake(0, 0, 320, 30)];
	v1.backgroundColor=[UIColor blackColor];
	btSelectAll=[UIFactory roundedRectButtonWithTitle:@"Select All" frame:CGRectMake(5, 2, 80, 25)];
	[btSelectAll addTarget:self action:@selector(btSelectAllClicked) forControlEvents:UIControlEventTouchDown];
	btDeselectAll=[UIFactory roundedRectButtonWithTitle:@"Deselect All" frame:CGRectMake(5, 2, 80, 25)];
	[btDeselectAll addTarget:self action:@selector(btDeselectAllClicked) forControlEvents:UIControlEventTouchDown];
	btCollapseAll=[UIFactory roundedRectButtonWithTitle:@"Collapse All" frame:CGRectMake(88, 2, 80, 25)];
	[btCollapseAll addTarget:self action:@selector(btCollapseAllClicked) forControlEvents:UIControlEventTouchDown];
	btExpandAll=[UIFactory roundedRectButtonWithTitle:@"Expand All" frame:CGRectMake(176, 2, 70, 25)];
	[btExpandAll addTarget:self action:@selector(btExpandAllClicked) forControlEvents:UIControlEventTouchDown];
	btSorting=[UIFactory roundedRectButtonWithTitle:@"Sorting" frame:CGRectMake(255, 2, 65, 25)];
	[btSorting addTarget:self action:@selector(btSortingClicked) forControlEvents:UIControlEventTouchDown];
	NSLog(@"DB4");
	
	[v1 addSubview:btSelectAll];
	[v1 addSubview:btCollapseAll];
	[v1 addSubview:btExpandAll];	
	[v1 addSubview:btSorting];	
	[self.view addSubview:v1];	
	NSLog(@"DB5");
	
	tableView=[[UITableView alloc] init];	
	tableView.frame=CGRectMake(0, 35, 320, 400);
	[tableView setDelegate:self];
	[tableView setDataSource:self];
	[self.view addSubview:tableView];
	NSLog(@"DB6");
	
	// PROCESS FUNCTION VIEW
	disableBackgroundView=FALSE;
	vProcessFunction=[UIFactory viewTransparentWithFrame:CGRectMake(0, 0, 320, 420)];	
	UIPickerView *pickerView=[[UIPickerView alloc] init];
	pickerView.showsSelectionIndicator = YES;
	pickerView.frame=CGRectMake(0, 195, 320,180);		
	[pickerView setDataSource:self];
	[pickerView setDelegate:self];		
	UIView *vLowOpacity=[UIFactory viewLowOpacityWithFrame:CGRectMake(0, 0, 320, 420)];	
	UIView *vBlack=[UIFactory viewBlackWithFrame:CGRectMake(0, 375, 320, 50)];
	UIButton *btPfDone=[UIFactory roundedRectButtonWithTitle:@"Done" frame:CGRectMake(10, 2, 80, 25)]; // Pf stands for 'Process Function'
	[btPfDone addTarget:self action:@selector(btPfDoneClicked) forControlEvents:UIControlEventTouchDown];
	UIButton *btPfGo=[UIFactory roundedRectButtonWithTitle:@"Go" frame:CGRectMake(120, 2, 80, 25)];
	[btPfGo addTarget:self action:@selector(btPfGoClicked) forControlEvents:UIControlEventTouchDown];
	UIButton *btPfCancel=[UIFactory roundedRectButtonWithTitle:@"Cancel" frame:CGRectMake(230, 2, 80, 25)];
	[btPfCancel addTarget:self action:@selector(btPfCancelClicked) forControlEvents:UIControlEventTouchDown];
	[vBlack addSubview:btPfDone];
	[vBlack addSubview:btPfGo];
	[vBlack addSubview:btPfCancel];
	[vProcessFunction addSubview:vLowOpacity];
	[vProcessFunction addSubview:vBlack];
	[vProcessFunction addSubview:pickerView];	
	NSLog(@"DB6");
}


// ==================================================================================================
#								pragma mark TABLEVIEW DATASOURCE
// ==================================================================================================
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
	return 30;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSLog(@"numberOfSectionsInTableView: %d",[arrProcess count]);
    return [arrProcess count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row==0) return 26;
	else {
		MyProcess *process=[arrProcess objectAtIndex:indexPath.section];
		MyDocument *document=[process.arrDoc objectAtIndex:(indexPath.row-1)];	
		NSString *sIndex=[self getDocIndexStringOf:document];		
		int nLines=[self getNumberOfLinesForString:sIndex];	
		if (nLines<=2) return 53;
		else return (53+15*(nLines-2));
	} 	 
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//NSLog(@"*** numberOfRowsInSection: %d",section);
	MyProcess *process=[arrProcess objectAtIndex:section];
	//NSLog(@"GETTING nRows for PROCESS: %@ and expanded=%d",process.id,[[dictExpandedProcess objectForKey:process.id] intValue]);
	if ([[dictExpandedProcess objectForKey:process.pid] intValue]!=1) return 1;
	int result=[process.arrDoc count]+1; //+1 because of Process row;
	//NSLog(@"arrDoc count= %d /// result=%d",[process.arrDoc count],result);	
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {			
	static NSString *ProCellIdentifier = @"ProCell";
	static NSString *DocCellIdentifier = @"DocCell";
	MyProcess *process;
	for (MyProcess *p in arrProcess) {
		if ([self getPositionOfProcessId:p.pid]==(indexPath.section+1)) {
			process=p;
			break;
		}
	}
	//NSLog(@"TEST PID = %@",process.pid);
	if (indexPath.row==0) {
		// PROCESS CELLs		
		ProcessCell *processCell;
		BOOL isExpanded,isSelected;
		
		if ([[dictExpandedProcess objectForKey:process.pid] intValue]==1)
			isExpanded=TRUE;
		else 
			isExpanded=FALSE;
		
		if ([[dictSelectedProcess objectForKey:process.pid] intValue]==1)
			isSelected=TRUE;
		else 
			isSelected=FALSE;	
				
		processCell =[[ProcessCell alloc] initWithFrame:CGRectZero isExpanded:isExpanded isSelected:isSelected reuseIdentifier:ProCellIdentifier];
		
		//processCell.lbProcessName.text=[Translator translate:process.typeId type:@"processTypeId"];
		processCell.lbProcessName.text=[self translate_level2:process.typeId type:@"processTypeId"];
		
		processCell.lbProcessName.textColor=[ThatkoLib colorForCode:[prefs integerForKey:@"ProcessNameColor"]];
		processCell.lbProcessName.font=[UIFont boldSystemFontOfSize:[prefs integerForKey:@"ProcessNameSize"]];				

		processCell.selectionStyle = UITableViewCellSelectionStyleNone;

		processCell.lbDate.text=[NSString stringWithFormat:@"[%@]",[TimeConverter convert:process.entryDate]];
		
		// CHECK BOX 
		processCell.btCheck.tag=process.pid;
		[processCell.btCheck addTarget:self action:@selector(btCheckboxClicked:) forControlEvents:UIControlEventTouchDown];		
		
		// TOGGLE BUTTON 
		processCell.btToggle.tag=process.pid;
		[processCell.btToggle addTarget:self action:@selector(btToggleClicked:) forControlEvents:UIControlEventTouchDown];
		
		// btMORE
		//processCell.btMore.tag=process.id;
		//[processCell.btMore addTarget:self action:@selector(btMoreClicked:) forControlEvents:UIControlEventTouchDown];
		
		// btDown
		processCell.btDown.tag=process;
		[processCell.btDown addTarget:self action:@selector(btDownClicked:) forControlEvents:UIControlEventTouchDown];
		
		// btProcessFoward
		processCell.btForward.tag=process.pid;		
		[processCell.btForward addTarget:self action:@selector(btProcessForwardClicked:) forControlEvents:UIControlEventTouchDown];
		
		
		return processCell;
	} else { 
		// DOCUMENT CELLs
		
		MyDocument *document=[process.arrDoc objectAtIndex:(indexPath.row-1)];		
		//NSLog(@" &&&&&& DOC ID = %@",document.dId);
		UIImage *imgThumb=[dictImgThumb objectForKey:document.dId];
		//int nPages=indexPath.row+indexPath.section;				   
		int nPages=document.pageCount;				   
		
		NSString *docIndexString=[self getDocIndexStringOf:document];
		int nLines=[self getNumberOfLinesForString:docIndexString];
		DocumentCell *documentCell=[[DocumentCell alloc] initWithFrame:CGRectZero andNumberOfLines:nLines andThumbImage:imgThumb andNumberOfPages:nPages reuseIdentifier:DocCellIdentifier];			
		//documentCell.lbDocumentName.text=[Translator translate:document.typeId type:@"docTypeId"];
		documentCell.lbDocumentName.text=[self translate_level2:document.typeId type:@"docTypeId"];
		
		documentCell.lbDocumentName.textColor=[ThatkoLib colorForCode:[prefs integerForKey:@"DocumentNameColor"]];
		documentCell.lbDocumentName.font=[UIFont boldSystemFontOfSize:[prefs integerForKey:@"DocumentNameSize"]];				
		
		documentCell.lbNumPages.text=[NSString stringWithFormat:@"%d",nPages];
		
		documentCell.tvDocIndex.text=docIndexString;

		documentCell.btTransparent1.tag=document;
		[documentCell.btTransparent1 addTarget:self action:@selector(btTransparent1Clicked:) forControlEvents:UIControlEventTouchDown];		 	
		documentCell.btTransparent2.tag=document;
		[documentCell.btTransparent2 addTarget:self action:@selector(btTransparent2Clicked:) forControlEvents:UIControlEventTouchDown];
		[documentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
		return documentCell;
	}
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

// ==================================================================================================
#								pragma mark HANDLERs 
// ==================================================================================================
-(void)btTransparent1Clicked:(UIButton*)sender{
	[self loading];
	[self performSelectorInBackground:@selector(btTransparentClicked_BG:) withObject:sender];	
	shouldShowIndex=TRUE;
}
-(void)btTransparent2Clicked:(UIButton*)sender{
	[self loading];
	[self performSelectorInBackground:@selector(btTransparentClicked_BG:) withObject:sender];	
	shouldShowIndex=FALSE;
}
-(void)btTransparentClicked_BG:(UIButton*)sender{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	MyDocument *d=sender.tag;
	MyProcess *process;
	int docPosition;
	BOOL shouldBreak=FALSE;
	for (MyProcess *p in arrProcess) {
		for (int i=0; i<[p.arrDoc count]; i++) {
			if ([p.arrDoc objectAtIndex:i]==d) {
				docPosition=i;
				process=p;
				shouldBreak=TRUE;
				break;
			}
		}
		if (shouldBreak) break;
	}			
	DocViewController *docViewController=[[DocViewController alloc] initWithProcess:process docPosition:docPosition showIndex:shouldShowIndex mandantId:selectedMandantId];	
	[pool release];
	[self performSelectorOnMainThread:@selector(btTransparentClicked_MainThread:) withObject:docViewController waitUntilDone:FALSE];
}

-(void)btTransparentClicked_MainThread:(DocViewController*)docViewController{
	[self stopLoading];
	[[self navigationController] pushViewController:docViewController animated:YES];			
}

-(void)btToggleClicked:(UIButton *)sender{
	if ([[dictExpandedProcess objectForKey:sender.tag] intValue]==1) {
		[dictExpandedProcess setObject:@"0" forKey:sender.tag];
	} else {
		[dictExpandedProcess setObject:@"1" forKey:sender.tag];
	}
	[tableView reloadData];
}
-(void)btCollapseAllClicked{
	for (MyProcess *aP in arrProcess) {
		[dictExpandedProcess setObject:@"0" forKey:aP.pid];
	}	
	[tableView reloadData];
}
-(void)btExpandAllClicked{
	for (MyProcess *aP in arrProcess) {
		[dictExpandedProcess setObject:@"1" forKey:aP.pid];
	}
	[tableView reloadData];	
}

- (void)btCheckboxClicked:(UIButton *)sender{
	if ([[dictSelectedProcess objectForKey:sender.tag] intValue]==1) {
		[dictSelectedProcess setObject:@"0" forKey:sender.tag];
	} else {
		[dictSelectedProcess setObject:@"1" forKey:sender.tag];
	}
	[tableView reloadData];
}
-(void)btSortingClicked{
	UIActionSheet *mandantActionSheet=[[UIActionSheet alloc] initWithTitle:@"Sorting Processes" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"By Date",@"By Type",nil];	
	[mandantActionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[mandantActionSheet release];				
}
-(void)btSelectAllClicked{
	for (MyProcess *aP in arrProcess) {
		[dictSelectedProcess setObject:@"1" forKey:aP.pid];
	}
	[tableView reloadData];	
	[btSelectAll removeFromSuperview];
	[v1 addSubview:btDeselectAll];
}
-(void)btDeselectAllClicked{
	for (MyProcess *aP in arrProcess) {
		[dictSelectedProcess setObject:@"0" forKey:aP.pid];
	}
	[tableView reloadData];	
	[btDeselectAll removeFromSuperview];
	[v1 addSubview:btSelectAll];
}

-(void)btForwardClicked{	
	if (disableBackgroundView) return;
	NSLog(@"****btForwardClicked");
}
-(void)btProcessForwardClicked:(UIButton*)sender{		
	currentProcessId=sender.tag;
	[self.navigationController setToolbarHidden:YES];	
	disableBackgroundView=TRUE;		
	[self.view addSubview:vProcessFunction];
}
-(void)btPfDoneClicked{
	[dictSelectedProcess setObject:@"1" forKey:currentProcessId];
	[self btPfCancelClicked];
	[tableView reloadData];
}
-(void)btPfGoClicked{
	[self btPfCancelClicked];
}
-(void)btPfCancelClicked{
	[self.navigationController setToolbarHidden:NO];
	disableBackgroundView=FALSE;
	[vProcessFunction removeFromSuperview];
}

-(void)btReturnClicked{
	if (disableBackgroundView) return;
	NSLog(@"***btReturnClicked");
}
-(void)btJoinClicked{
	if (disableBackgroundView) return;
	NSLog(@"***btJoinClicked");
}
-(void)btMoreClicked:(UIButton*)sender{
	UIActionSheet *mandantActionSheet=[[UIActionSheet alloc] initWithTitle:@"More functions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Split Process",nil];	
	[mandantActionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[mandantActionSheet release];			
}
/*
-(void)btDownClicked:(UIButton*)sender{	
	NSLog(@"***btDownClicked");
	MyProcess *p1,*p2;
	p1=sender.tag;
	if ([self getPositionOfProcessId:p1.pid]==[arrProcess count]) {
		NSLog(@"Clicked on the last process");
		return; // process duoi cung
	}	
	for (MyProcess *p in arrProcess) {
		if ([self getPositionOfProcessId:p.pid]==([self getPositionOfProcessId:p1.pid]+1)) {
			p2=p;
			break;
		}
	}
	NSLog(@"Vi tri truoc khi chuyen: %d-%d",p1.position,p2.position);
	p1.position++;
	p2.position--;
	NSLog(@"Vi tri sau khi chuyen: %d-%d",p1.position,p2.position);
	[Connector syncProcess];
	[tableView reloadData];
}
*/

// ==================================================================================================
#								pragma mark PICKER VIEW (DATASOURCE+DELEGATE)
// ==================================================================================================
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {	
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {	
	return 4;
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (row==0) return @"Checked";
	else if (row==1) return @"1st Approval";
	else if (row==2) return @"2nd Approval";
	else if (row==3) return @"Booked";
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {	
	NSLog(@"scrolled");
}


// ==================================================================================================
#								pragma mark ACTION SHEET
// ==================================================================================================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {		
	NSLog(@"*** actionSheet");
	if (buttonIndex==[actionSheet cancelButtonIndex]) return;
	if ([[actionSheet title] isEqualToString:@"More functions"]) {		// MANDANT LIST				
		NSLog(@"MORE FUNCTIONS --- button index = %d",buttonIndex);
	} 
}


// ==================================================================================================
#								pragma mark SUPPORTs
// ==================================================================================================
-(int)getPositionOfProcessId:(NSString*)pIdPar{
	int count=0;
	for (MyProcess *myP in arrProcess) {
		count++;
		if ([myP.pid isEqualToString:pIdPar]) {
			return count;
		}
	}
	return -1;
}
-(int)getNumberOfLinesForString:(NSString*)input{
	if ([input length]<=2*nCharsPerLine) return 2;
	else {		
		for (int j=3; j<=10; j++) {
			if ([input length]<=j*nCharsPerLine) {
				return j;
			}
		}			
	}
}
-(NSString*)getDocIndexStringOf:(MyDocument *)document{
	//return @"Number: 123456. Type: 123456 123456. Amount: 1.000.000 USD. Creditor: Cocacola. Thinh: thatko. Halo: Danke. Couldten apentis: Nice meal. Number: 123456. Type: 123456 123456. Amount: 1.000.000 USD. Creditor: Cocacola. Thinh: thatko. Halo: Danke. Couldten apentis: Nice meal.";
	NSString *s=@"";
	//NSLog(@"GET DOC INDEX STRING OF DOCUMENT ~ %d",[document.arrIndex count]);
	for (int i=0;i<[document.arrIndex count];i++){
		MyIndex *index=[document.arrIndex objectAtIndex:i];
		//NSLog(@"r: %@",index.name);
		//NSString *translation=[Translator translate:[self getIndexIdFromCombinedId:index.id] type:@"indexId"];			
		NSString *translation=[self translate_level2:[self getIndexIdFromCombinedId:index.id] type:@"indexId"];			
		s=[NSString stringWithFormat:@"%@ %@: %@.",s,translation,index.value];
	}
	return s;
}
/*
- (void)touchThumb:(UIButton *)sender {
	NSLog(@"F1");
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(160, 200)]; 	
	[spinner setBackgroundColor: [UIColor blackColor]];
	[self.view addSubview:spinner];
	[spinner startAnimating];
	[self performSelectorInBackground:@selector(doAfterSpin:) withObject:sender];
}
-(void)doAfterSpin:(UIButton *)sender{
	//NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
	MyProcess * touchedProcess=(MyProcess *)sender.tag;
	processViewController=[[ProcessViewController alloc] initWithProcess:touchedProcess];	
	[[self navigationController] pushViewController:processViewController animated:YES];
	//[pool release];
}
*/

-(void)addProcessToDB:(NSString*)processIdPar withReadStatus:(int)readStatusPar{
	NSLog(@"DO INSERT PROCESS SQL");
	sql = "INSERT INTO tb_Process(xID,xRead) VALUES(?,?)";	
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_text(compiledSql, 1, [processIdPar UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(compiledSql, 2, readStatusPar);
	sqlite3_step(compiledSql);							
}
-(void)changeAllProcessesToReadStatus{
	// CHECK IF THIS PROCESS EXIST IN DB OR NOT
	NSMutableArray *arrProcessIdExisted=[[NSMutableArray alloc] init];
	sql = "select * from tb_Mandant"; 
	if(sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL) == SQLITE_OK) {			
		while(sqlite3_step(compiledSql) == SQLITE_ROW) {
			NSString *tmpPId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledSql, 0)];	
			[arrProcessIdExisted addObject:[[Mandant alloc] initWithId:tmpPId]];
		}
		sqlite3_finalize(compiledSql);// Release the compiled statement from memory					
	}		

	// UPDATE OR INSERT PROCESS, BASED ON IT EXISTS OR NOT
	BOOL exists;
	for (MyProcess *aP in arrProcess) {
		exists=FALSE;
		for (NSString *pid in arrProcessIdExisted) {
			if ([aP.pid isEqualToString:pid]) {
				exists=TRUE;
				break;
			}
		}
		if (exists) {
			sql = "UPDATE tb_Process SET xIsRead=? WHERE xID=?";	
			sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
			sqlite3_bind_int(compiledSql, 1, 1);
			sqlite3_bind_text(compiledSql, 2, [aP.pid UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_step(compiledSql);							
		} else {
			sql = "INSERT INTO tb_Process(xPID,xIsRead,xTypeId) VALUES(?,?,?)";	
			sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
			sqlite3_bind_text(compiledSql, 1, [aP.pid UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(compiledSql, 2, 1);
			sqlite3_bind_text(compiledSql, 3, [aP.typeId UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_step(compiledSql);										
		}

	}
	
}

/*
 -(void)viewDidAppear:(BOOL)animated{	
 [self.navigationController setToolbarHidden:YES];	
 }
 -(void)viewWillDisappear:(BOOL)animated{
 [self.navigationController setToolbarHidden:NO];
 }
 */

@end
