#import "RootViewController.h"
#import "GroupCell.h"
#import "WbCell.h"
#import "MoveWbViewController.h"
#import "SettingFontVC.h"
#import "UIFactory.h"
#import "ThatkoLib.h"
#import "TimeConverter.h"
#import "XMLReader.h"

#import "MyProcess.h";
#import "CommandList.pb.h"
#import "DocTypeIdList.pb.h"
#import "WbList.pb.h"
#import "ProcessTypeIdList.pb.h"
#import "Translator.h"

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated {		
	NSLog(@"*** viewWillAppear");
    [super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO];	
	self.navigationController.toolbar.tintColor=[UIColor blackColor];
	
	if (!firstLoading) {
		wbl=[connector getWbList_fetchServer:FALSE fetchPID:FALSE syncPID:TRUE syncGroup:TRUE];		
		[tableView reloadData];
	}	
	firstLoading=FALSE;
	NSLog(@"*** end: viewWillAppear");
}

-(void)firstLoading_BG{
	NSLog(@"*** firstLoading_BG");
	pool = [[NSAutoreleasePool alloc] init];	
	
	//IF NOT DECLARE, INIT NS_USER_DEFAULT
	prefs = [NSUserDefaults standardUserDefaults];	
	NSString *x=@"kec8";
	if (![prefs integerForKey:x]) {
		NSLog(@"INIT PREFS");
		[prefs setValue:@"en" forKey:@"Language"];		
		[prefs setInteger:1 forKey:x];		
		[prefs setInteger:2 forKey:@"GroupNameColor"];		
		[prefs setInteger:13 forKey:@"GroupNameSize"];
		[prefs setInteger:1 forKey:@"MandantNameColor"];		
		[prefs setInteger:15 forKey:@"MandantNameSize"];
		[prefs setInteger:5 forKey:@"WbNameColor"];		
		[prefs setInteger:19 forKey:@"WbNameSize"];
		[prefs setInteger:2 forKey:@"ProcessNameColor"];		
		[prefs setInteger:13 forKey:@"ProcessNameSize"];
		[prefs setInteger:3 forKey:@"DocumentNameColor"];		
		[prefs setInteger:15 forKey:@"DocumentNameSize"];
	}
	NSLog(@"db1 - language = %@",[prefs stringForKey:@"Language"]);	
	[Translator initWithDB:database];
	
	connector=[[Connector alloc] initWithDB:database];	
	ml=[connector getMandantList_fetchServer:TRUE syncDb:TRUE];		
	NSLog(@"db2");	
	if ([ml count]==0) {
		NSLog(@"NOT OK");
		[self performSelectorOnMainThread:@selector(firstLoading_MT_error) withObject:nil waitUntilDone:FALSE];			
	} else {
		NSLog(@"db3");					
		wbl=[[connector getWbList_fetchServer:TRUE fetchPID:TRUE syncPID:TRUE syncGroup:TRUE] copy];		
		//NSLog(@"&&&& TEST LASTBUILDDATE = %@",[[wbl objectAtIndex:0] lastBuildDate]);
		NSLog(@"db4");	
		[self performSelectorOnMainThread:@selector(firstLoading_MT) withObject:nil waitUntilDone:FALSE];			
		NSLog(@"db4?");	
	}
		
	[pool release];
}
-(void)firstLoading_MT_error{
	[self stopLoading];
	disableBackgroundView=TRUE;
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network error" delegate:self cancelButtonTitle:@"Try again !" otherButtonTitles:nil];	
	[errorAlert setDelegate:self];
	[errorAlert show];	
}
-(void)firstLoading_MT{
	NSLog(@"*** firstLoading_MT");
	[self stopLoading];
	
	groupList=[self getGroupListFromDB];	
	if (tableView !=nil)
		if ([tableView superview]!=nil) 
			[tableView removeFromSuperview];	
	[self.view addSubview:tableView];	
	[tableView reloadData];
}

- (void)viewDidLoad {			
	NSLog(@"*** viewDidLoad");
	firstLoading=TRUE;
	
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor blackColor];	
	[self checkDB];
	ml=[[NSMutableArray alloc] init];
	wbl=[[NSMutableArray alloc] init];
	
	// ====================== INIT INTERFACE =================================== //
	self.navigationItem.title=@"Oxplorer";
	UIBarButtonItem *btRefresh=[[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(btRefreshClicked)];        	
	self.navigationItem.rightBarButtonItem=btRefresh;
	
	btAddGroup = [[UIBarButtonItem alloc] initWithTitle:@"+ Group" style:UIBarButtonItemStyleBordered target:self action:@selector(btAddGroupClicked:)];
		btAddGroup.width=70;
	btMandant = [[UIBarButtonItem alloc] initWithTitle:@"Mandant" style:UIBarButtonItemStyleBordered target:self action:@selector(btMandantClicked:)];
		btMandant.width=72;
	btMoveWB = [[UIBarButtonItem alloc] initWithTitle:@"Move WB" style:UIBarButtonItemStyleBordered target:self action:@selector(btMoveWbClicked)];
	btMore = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStyleBordered target:self action:@selector(btMoreClicked)];
		btMore.width=60;
	
	NSArray *items = [[NSArray alloc] initWithObjects: btAddGroup,btMandant,btMoveWB,btMore,nil];
	[self setToolbarItems: items];		
	tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 375)];
	tableView.scrollEnabled=TRUE;
	[tableView setDelegate:self];
	[tableView setDataSource:self];				

	
	[self loading];
	[self performSelectorInBackground:@selector(firstLoading_BG) withObject:nil];
}

-(void)reloadAll{	
	NSLog(@"*** reloadAll");
	groupList=[self getGroupListFromDB];	
	ml=[connector getMandantList_fetchServer:FALSE syncDb:TRUE];
	wbl=[connector getWbList_fetchServer:TRUE fetchPID:TRUE syncPID:TRUE syncGroup:TRUE];
	
	if (tableView !=nil)
		if ([tableView superview]!=nil) 
			[tableView removeFromSuperview];	
	[self.view addSubview:tableView];	
	[tableView reloadData];
}

// ==================================================================================================
#								pragma mark TableView DataSource
// ==================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {	
	NSLog(@"*** nSections = %d",groupList.count);
    return groupList.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row==0) return 28;
	else return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {		
	NSString *groupID;
	for (int i=0;i<groupList.count;i++){
		if ([self sectionOfPosition:[[[groupList objectAtIndex:i] objectForKey:@"Position"] intValue]]==section) {
			if ([[[groupList objectAtIndex:i] objectForKey:@"Expanded"] intValue]==0) {
				return 1;
			}
			groupID=[[groupList objectAtIndex:i] objectForKey:@"ID"];
			break;
		}
	}
	
	int nWB=1; // group row;	
	for (Wb *wb in wbl){
		if (wb.inGroupId==[groupID intValue]) {
			nWB++;
		}
	}
	return nWB;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"*** cellForRowAtIndexPath");	
    static NSString *CellIdentifier = @"Cell";
	
	// Get Group (need for both Group row and WB row)
	NSDictionary *group=[[NSDictionary alloc] init];//=[groupList objectAtIndex:indexPath.section];
	for (int i=0;i<groupList.count;i++){			
		if ([self sectionOfPosition:[[[groupList objectAtIndex:i] objectForKey:@"Position"] intValue]]==indexPath.section) {
			group=[groupList objectAtIndex:i];		
			break;
		}			
	}	
	if (indexPath.row==0) {
		// ================== GROUP ROW ==================		
		GroupCell *groupCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (groupCell == nil) {
			groupCell =[[[GroupCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		//groupCell.lbGroupName.text=[NSString stringWithFormat:@"%@-ID:%@-Pos:%@-Sec:%d",[group objectForKey:@"Name"],[group objectForKey:@"ID"],[group objectForKey:@"Position"],indexPath.section];
		groupCell.lbGroupName.text=[NSString stringWithFormat:@"%@",[group objectForKey:@"Name"]];
		groupCell.lbGroupName.textColor=[ThatkoLib colorForCode:[prefs integerForKey:@"GroupNameColor"]];
		groupCell.lbGroupName.font=[UIFont boldSystemFontOfSize:[prefs integerForKey:@"GroupNameSize"]];			
		
		if ([[group objectForKey:@"ID"] intValue]==0) {
			groupCell.btEdit.alpha=0;			
			groupCell.btEdit.enabled=NO;
			groupCell.btDelete.alpha=0;			
			groupCell.btDelete.enabled=NO;
		} else {
			groupCell.btEdit.alpha=1;			
			groupCell.btEdit.enabled=YES;
			groupCell.btDelete.alpha=1;			
			groupCell.btDelete.enabled=YES;
			groupCell.btEdit.tag=[[group objectForKey:@"ID"] intValue];
			[groupCell.btEdit addTarget:self action:@selector(btEditClicked:) forControlEvents:UIControlEventTouchDown];
			groupCell.btDelete.tag=[[group objectForKey:@"ID"] intValue];
			[groupCell.btDelete addTarget:self action:@selector(btDeleteClicked:) forControlEvents:UIControlEventTouchDown];
		}		
		[groupCell expanded:[[group objectForKey:@"Expanded"] intValue]];		
		groupCell.btToggle.tag=[[group objectForKey:@"ID"] intValue];
		[groupCell.btToggle addTarget:self action:@selector(btToggleClicked:) forControlEvents:UIControlEventTouchDown];
		groupCell.btDown.tag=[[group objectForKey:@"ID"] intValue];
		[groupCell.btDown addTarget:self action:@selector(btDownClicked:) forControlEvents:UIControlEventTouchDown];	
		
		[groupCell setSelectionStyle:UITableViewCellSelectionStyleNone];		
		return groupCell;
	} else {
		// ==================== WB ROW ==================		
		NSLog(@"DB1- WB ROW");
		Wb *wb;				
		int tmpRow=indexPath.row;		
					
		for (Wb *aWb in wbl) {
			NSLog(@"DB4");
			NSLog(@"DB41");
			NSLog(@"DB42 - %d",[[group objectForKey:@"ID"] intValue]);
			if (aWb.inGroupId==[[group objectForKey:@"ID"] intValue]) {
				tmpRow--;
			}
			NSLog(@"DB5");
			if (tmpRow==0) {
				wb=aWb;								
				break;
			}
		}
		NSLog(@"DB51 - LastBuildDate = %@",wb.lastBuildDate);
		

		NSLog(@"DB6");				
		WbCell *wbCell = [tableView dequeueReusableCellWithIdentifier:@"AA"];
		if (wbCell == nil) {
			wbCell = [[[WbCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"AA"] autorelease];
		}		
		NSLog(@"DB7");
		wbCell.lbMandant.text=[NSString stringWithFormat:@"[%@]",wb.inMandantId];
		wbCell.lbMandant.textColor=[ThatkoLib colorForCode:[prefs integerForKey:@"MandantNameColor"]];
		wbCell.lbMandant.font=[UIFont boldSystemFontOfSize:[prefs integerForKey:@"MandantNameSize"]];			
				
		NSLog(@"DB8");
		wbCell.lbWbName.text=wb.name;
		wbCell.lbWbName.textColor=[ThatkoLib colorForCode:[prefs integerForKey:@"WbNameColor"]];
		wbCell.lbWbName.font=[UIFont boldSystemFontOfSize:[prefs integerForKey:@"WbNameSize"]];			
				
		// GET NEW#/READ#
		NSLog(@"DB9");		
		if (wb.unread>0){ //highlight
			wbCell.lbNewRead.font=[UIFont boldSystemFontOfSize:15];
			wbCell.lbNewRead.textColor=[UIColor redColor];
		} else {
			wbCell.lbNewRead.font=[UIFont systemFontOfSize:15];
			wbCell.lbNewRead.textColor=[UIColor blackColor];
		}			
		wbCell.lbNewRead.text=[NSString stringWithFormat:@"%d/%d",wb.unread,wb.total];				
	
		wbCell.lbLastBuildDate.text=[TimeConverter convert:wb.lastBuildDate];
		//wbCell.lbLastBuildDate.text=wb.lastBuildDate; // not able to convert Siva timestamp format yet
		
		//[wbCell.infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchDown];
		wbCell.infoButton.tag=wb.id;
		[wbCell setSelectionStyle:UITableViewCellSelectionStyleGray];		
		return wbCell;
	}	
}

// ==================================================================================================
#								pragma mark TableView Delegate
// ==================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    	
	NSLog(@"SELECTED ROW");	
	currentIndexPath=indexPath;
	if (indexPath.row==0) return; // Group Row: No action
	NSLog(@"SHOULD LOADing 1");
	[self loading];	
	NSLog(@"SHOULD LOADing 2");
	currentCombinedWbID=[[self convertIndexPathToID:indexPath] copy];
	Wb *wb=[self getWbWithCombinedId:currentCombinedWbID];
	if (wb.total==0) {
		[self showAlertWithTitle:@"Alert" andMessage:@"This WorkBasket has no process !"];
		[self stopLoading];
		return;
	}	
	[self performSelectorInBackground:@selector(changeToWbView_BG:) withObject:wb];
}
-(void)changeToWbView_BG:(Wb*)wb{
	pool = [[NSAutoreleasePool alloc] init];
	sleep(5);
	[self performSelectorOnMainThread:@selector(changeToWbView_MainThread:) withObject:wb waitUntilDone:FALSE];
	[pool release];
}
-(void)changeToWbView_MainThread:(Wb*)wb{
	//sleep(5);
	[self stopLoading];
	
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Oxplorer" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];			
	[newBackButton release];
	NSLog(@"DB4x");
	return;
	wbViewController=[[WbViewController alloc] initWithWb:wb];	
	[[self navigationController] pushViewController:wbViewController animated:YES];	
	//MyProcess *fakeProcess=[Process alloc] init 
}

// ==================================================================================================
#								pragma mark ACTION SHEET
// ==================================================================================================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {		
	NSLog(@"*** actionSheet: %@",[actionSheet title]);
	if (buttonIndex==[actionSheet cancelButtonIndex]) return;
	if ([[actionSheet title] isEqualToString:@"Mandant List"]) {		  // MANDANT LIST				
		Mandant *m=[ml objectAtIndex:buttonIndex];
		if (m.isAdded){ 
			NSLog(@"REMOVING MANDANT %@ !!!",m.id);
			[connector removeMandant:m.id];			
			[self reloadAll];			
		} else {
			NSLog(@"ADDING MANDANT %@ !!!",m.id);
			[connector addMandant:m.id];
			[self reloadAll];			
		}
	} else if ([[actionSheet title] isEqualToString:@"WorkBasket Info"]) { //WB ROW
		if (buttonIndex==0){ // Move To
			UIActionSheet *moveToActionSheet=[[UIActionSheet alloc] initWithTitle:@"Move To" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];	
			int count=0;
			for (NSDictionary * aGroup in groupList) {				
				[moveToActionSheet addButtonWithTitle: [aGroup objectForKey:@"Name"]];
				count++;
			}
			[moveToActionSheet addButtonWithTitle:@"Cancel"];
			moveToActionSheet.cancelButtonIndex=count;
			[moveToActionSheet showInView:[UIApplication sharedApplication].keyWindow];
			[moveToActionSheet release];		
		} else if (buttonIndex==1) { //REFRESH WB
			NSLog(@" CLICKING REFRESH WB BUTTON !");
			[self loading];
			[self performSelectorInBackground:@selector(refreshWB) withObject:NULL];
		}	
	} else if ([[actionSheet title] isEqualToString:@"More"]) { //MORE		
		if (buttonIndex==1) { //Setting font	
			UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStyleBordered target: nil action: nil];			
			[[self navigationItem] setBackBarButtonItem: newBackButton];			
			[newBackButton release];
			
			SettingFontVC *settingFontVC=[[SettingFontVC alloc] init];
			[[self navigationController] pushViewController:settingFontVC animated:YES];	
		} else if (buttonIndex==2) { //Setting Language
			UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Setting Language" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];			
			[actionSheet addButtonWithTitle: @"English"];	
			[actionSheet addButtonWithTitle: @"Deutsch"];	
			[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
			[actionSheet release];			
		}
	} else if ([[actionSheet title] isEqualToString:@"Setting Language"]) { //SETTING LANGUAGE		
		if (buttonIndex==1) [prefs setValue:@"en" forKey:@"Language"];
		else [prefs setValue:@"de" forKey:@"Language"];
	}
}


// ==================================================================================================
#								pragma mark BUTTON CLICKED
// ==================================================================================================
-(void)btMoreClicked{
	if (disableBackgroundView) return;
	UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"More" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];			
	[actionSheet addButtonWithTitle: @"Setting Font size/color"];	
	[actionSheet addButtonWithTitle: @"Setting Language"];	
	[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[actionSheet release];			
}
-(void)btRefreshClicked{
	if (disableBackgroundView) return;	
	[self loading];
	[self performSelectorInBackground:@selector(btRefreshClicked_BG) withObject:nil];	
}
-(void)btRefreshClicked_BG{
	/*
	[Connector fetchMandantList];	 
	[Connector syncMandant];
	[Connector fetchWorkBasket];
	[Connector syncWorkBasket];
	[Connector fetchProcessIdListForWorkBaskets];
	[Connector syncProcess];	
	ml=[Connector ml];	
	 */
	[self performSelectorOnMainThread:@selector(firstLoading_MT) withObject:nil waitUntilDone:FALSE];	 
}
-(void)btRefreshClicked_MT{
	[self stopLoading];
	
	groupList=[self getGroupListFromDB];	
	if (tableView !=nil)
		if ([tableView superview]!=nil) 
			[tableView removeFromSuperview];	
	[self.view addSubview:tableView];	
	[tableView reloadData];
	
}
-(void)btMandantClicked:(UIBarButtonItem *)sender{
	NSLog(@"*** btMandantClicked");
	if (disableBackgroundView) return;	
	UIActionSheet *mandantActionSheet=[[UIActionSheet alloc] initWithTitle:@"Mandant List" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];		
	int count=0;	
	for (Mandant *m in ml) {		
		NSString *s=[NSString stringWithFormat:@"%@   -  [%@]",m.id,m.isAdded?@"Remove":@"Add"];
		[mandantActionSheet addButtonWithTitle: s];
		count++;
	}
	[mandantActionSheet addButtonWithTitle:@"Cancel"];
	mandantActionSheet.cancelButtonIndex=count;
	[mandantActionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[mandantActionSheet release];		
}
- (void)btAddGroupClicked:(UIBarButtonItem *)sender {
	NSLog(@"*** btAddGroupClicked");	
	if (disableBackgroundView) return;
	[self addGroup:@"Unnamed" withExpanded:1 andPosition:highestPosition+1];
}
- (void)btEditClicked:(UIButton *)sender {
	NSLog(@"*** btEditClicked");
	currentTag=sender.tag;
	[self openEditGroupNameView];
}
- (void)btDeleteClicked:(UIButton *)sender {
	NSLog(@"*** btDeleteClicked");	
	currentTag=sender.tag;
	[self deleteGroupWithID:currentTag];
}
- (void)btOKClicked:(UIButton *)sender{
	[vEditGroupName removeFromSuperview];
	[self changeGroupName:vEditGroupName.tfEditGroupName.text atId:currentTag];
}
- (void)btCancelClicked:(UIButton *)sender{
	[vEditGroupName removeFromSuperview];
}
- (void)btDownClicked:(UIButton *)sender {
	for (NSDictionary *aGroup in groupList) {
		if ([[aGroup objectForKey:@"ID"] intValue]==sender.tag){
			if ([[aGroup objectForKey:@"Position"] intValue]==highestPosition) return; // already in bottom			
			int currentSection=[self sectionOfPosition:[[aGroup objectForKey:@"Position"] intValue]];
			int nextSection=currentSection+1;
			int currentGroupID=sender.tag;
			int nextGroupID=[[self getIdFromSection:nextSection andRow:0] intValue];
			[self changePositionOfGroupWithID:currentGroupID andGroupWithID:nextGroupID];
			return;
		}							
	}	
}
- (void)btToggleClicked:(UIButton *)sender {
	NSLog(@"*** btToggleClicked");	
	int newExpanded;	
	NSDictionary *oldGroup;	
	for (int i=0; i<groupList.count; i++) {
		if ([[[groupList objectAtIndex:i] objectForKey:@"ID"] intValue]==sender.tag) {		
			oldGroup=[[groupList objectAtIndex:i] copy];
			if ([[oldGroup objectForKey:@"Expanded"] intValue]==1) 
				newExpanded=0;
			else 
				newExpanded=1;
			NSDictionary * newGroup=[NSDictionary dictionaryWithObjectsAndKeys:
									 [oldGroup objectForKey:@"ID"], @"ID",
									 [oldGroup objectForKey:@"Name"], @"Name",
									 [NSString stringWithFormat:@"%d",newExpanded], @"Expanded",
									 [oldGroup objectForKey:@"Position"], @"Position",
									 nil];
			[groupList replaceObjectAtIndex:i withObject:newGroup];
			break;
		}		
	}
	sql = "UPDATE tb_Group SET xExpanded=? WHERE xID=?";	
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_int(compiledSql, 1, newExpanded);
	sqlite3_bind_int(compiledSql, 2, [[oldGroup objectForKey:@"ID"] intValue]);	
	sqlite3_step(compiledSql);	
	[tableView reloadData];		
}
-(void)btMoveWbClicked{
	if (disableBackgroundView) return;
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStyleBordered target: nil action: nil];			
	[[self navigationItem] setBackBarButtonItem: newBackButton];			
	[newBackButton release];
	
	MoveWbViewController *moveWbViewController=[[MoveWbViewController alloc] initWithConnector:connector];
	[[self navigationController] pushViewController:moveWbViewController animated:YES];	
}

// ==================================================================================================
#								pragma mark ALERT VIEW DELEGATE
// ==================================================================================================
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([actionSheet.title isEqualToString:@"Alert"]){
		 [tableView deselectRowAtIndexPath:currentIndexPath animated:YES];
		return;
	}
	if (buttonIndex == 0){		
		[self loading];
		[self performSelectorInBackground:@selector(firstLoading_BG) withObject:nil];
	} else {
		NSLog(@"cancel"); //actually it's "Try again";
	}
} 

// ==================================================================================================
#								pragma mark SUPPORTED 
// ==================================================================================================
-(int)sectionOfPosition:(int)position{ // SECTION (of Table) BASED ON POSITION (get from DB) of GROUP
	if (groupList.count==0) return 0;
	int count=0;
	for (int i=0; i<groupList.count; i++) {
		if ([[[groupList objectAtIndex:i] objectForKey:@"Position"] intValue]<position) {
			count++;
		}
	}
	return count;
}
-(Wb*)getWbWithCombinedId:(NSString*)input{
	NSLog(@"*** getWbWithCombinedId");
	NSLog(@"input=%@",input);
	NSString *combinedId=[input copy];
	for (Wb *wb in wbl) {
		NSLog(@"[] %@_%@",wb.id,wb.inMandantId);		
		if ([combinedId isEqualToString:[NSString stringWithFormat:@"%@_%@",wb.id,wb.inMandantId]]) return wb;
	}
}
- (NSString *)convertIndexPathToID:(NSIndexPath *)indexPath{
	return [self getIdFromSection:indexPath.section andRow:indexPath.row];
}
-(NSString *)getIdFromSection:(int)section andRow:(int)row{ //return either group id / wb id
	NSString *groupID;
	NSString *wbID;
	for (NSDictionary *aGroup in groupList) {
		if ([self sectionOfPosition:[[aGroup objectForKey:@"Position"] intValue]]==section) {
			groupID=[aGroup objectForKey:@"ID"];
			break;
		}
	}
	if (row==0) return groupID;
	
	int count=row;	
	for (Wb *wb in wbl) {
		if (wb.inGroupId==[groupID intValue]) {
			count--;
		}
		if (count==0) return [NSString stringWithFormat:@"%@_%@",wb.id,wb.inMandantId];
	}	
}
-(void)openEditGroupNameView{
	NSString *groupName;
	for (NSDictionary *aGroup in groupList) {
		if ([[aGroup objectForKey:@"ID"] isEqualToString:[NSString stringWithFormat:@"%d",currentTag]]){
			groupName=[aGroup objectForKey:@"Name"];
			break;
		}
	}
	vEditGroupName=[[[EditGroupNameView alloc] initWithGroupName:groupName] autorelease];
	[self.view addSubview:vEditGroupName];
	[vEditGroupName.tfEditGroupName setDelegate:self];
	[vEditGroupName.btOK addTarget:self action:@selector(btOKClicked:) forControlEvents:UIControlEventTouchDown];
	[vEditGroupName.btCancel addTarget:self action:@selector(btCancelClicked:) forControlEvents:UIControlEventTouchDown];
}


// ==================================================================================================
#								pragma mark OTHERS DELEGATE
// ==================================================================================================
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	NSLog(@"*** textFieldShouldReturn");
	[vEditGroupName removeFromSuperview];
	[self changeGroupName:theTextField.text atId:currentTag];
	return YES;
}


// ==================================================================================================
#										pragma mark GROUP 
// ==================================================================================================
-(void)addGroup:(NSString *)groupName withExpanded:(int)expanded andPosition:(int)position{
	NSLog(@"*** addGroup: %@,%d,%d",groupName,expanded,position);
	sql = "INSERT INTO tb_Group(xName,xExpanded,xPosition) VALUES (?,?,?)";	
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_text(compiledSql, 1, [groupName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(compiledSql, 2, expanded);
	sqlite3_bind_int(compiledSql, 3, position);	
	sqlite3_step(compiledSql);	
	
	groupList=[self getGroupListFromDB];
	
	// SET CURRENT TAG TO GROUP_ID OF NEW ADDED GROUP (FOR EDIT NAME)
	currentTag=[[[groupList objectAtIndex:groupList.count-1] objectForKey:@"ID"] intValue];
	[self openEditGroupNameView];	
	
}
-(void)changePositionOfGroupWithID:(int)ID1 andGroupWithID:(int)ID2{
	int position1,position2;
	for (NSDictionary *aGroup in groupList) {
		if ([[aGroup objectForKey:@"ID"] intValue]==ID1){
			position1=[[aGroup objectForKey:@"Position"] intValue];
		} else if ([[aGroup objectForKey:@"ID"] intValue]==ID2){
			position2=[[aGroup objectForKey:@"Position"] intValue];
		} 
	}
	sql = "UPDATE tb_Group SET xPosition=? WHERE xID=?";	
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_int(compiledSql, 1, position2);
	sqlite3_bind_int(compiledSql, 2, ID1);	
	sqlite3_step(compiledSql);
	
	sql = "UPDATE tb_Group SET xPosition=? WHERE xID=?";	
	sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
	sqlite3_bind_int(compiledSql, 1, position1);
	sqlite3_bind_int(compiledSql, 2, ID2);	
	sqlite3_step(compiledSql);	
	
	groupList=[self getGroupListFromDB];
	[tableView reloadData];
}

// ==================================================================================================
#										pragma mark WORKBASKET 
// ==================================================================================================
-(void) refreshWB{
	[self stopLoading];	
}
@end

// TEST SIVA PROCESS_ID_LIST PBF		
/*
 // FIRST SCREEN
 NSString *url=@"http://192.168.16.121:8080/moxseed/spring/basketapp?basketIds=inbox_ani23012012,storage_ani23012012&responseType=protobuf&action=getbasketsprocessidslist";	
 NSData  *d = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];	
 BasketProcessIdsList *basketProcessIdsList=[BasketProcessIdsList parseFromData:d];
 BasketProcessIds *basketProcessIds=[[basketProcessIdsList mutableBasketProcessIdsList] objectAtIndex:0];
 NSLog(@"*********** ****** DB PBF SIVA: Basket id = %@",[basketProcessIds basketId]);	 	
 NSLog(@"*********** FIRST PID = %@ ",[[basketProcessIds mutablePIdList] objectAtIndex:0]);
 // WB SCREEN (2nd screen)
 url=@"http://192.168.16.121:8080/moxseed/spring/basketapp?basketIds=inbox_ani23012012&responseType=protobuf&action=getbasketprocessinfolist";	
 d = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];	
 ProcessList *processList=[ProcessList parseFromData:d];
 Process *p=[[processList mutableProcessList] objectAtIndex:0];
 NSLog(@"*********pId=%@",[p pId]);
 Document *doc=[[[p documentList] mutableDocumentList] objectAtIndex:0];
 NSLog(@"*********dId=%@",[doc dId]);
 Index *i=[[[doc indexList] mutableIndexList] objectAtIndex:0];
 NSLog(@"*********indexId=%@",[i indexId]);
 */


//PBF OF DENIS
/*
 NSString *url;
 url=@"http://192.168.16.121:8888/oxseedadmin/ext/oxplorer?content=mandantList&login=admin&pass=oxseed"; //MandantList
 url=@"http://192.168.16.121:8888/denis/ext/oxplorer?content=wbTypeCommands&wbType=workflow&login=admin&pass=oxseed"; //CommandList	 
 url=@"http://192.168.16.121:8888/denis/ext/oxplorer?content=docTypeIdList&processType=generaldocument&login=admin&pass=oxseed";//DocTypeIdList	
 //url=@"http://192.168.16.121:8888/denis/ext/oxplorer?content=translation&language=de&login=admin&pass=oxseed&wbId=inbox";//Translation
 url=@"http://192.168.16.121:8888/denis/ext/oxplorer?content=wbList&login=admin&pass=oxseed"; //wbList
 url=@"http://192.168.16.121:8888/denis/ext/oxplorer?content=processTypeIdList&login=admin&pass=oxseed"; //processTypeId
 url=@"http://192.168.16.121:8888/denis/ext/oxplorer?content=indexList&login=admin&pass=oxseed&docTypeId=document";//indexList
 
 NSData  *d = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
 
 //MandantList *ml=[MandantList parseFromData:d];
 //Mandant *m=[[ml mutableMandantList] objectAtIndex:0];
 //NSLog(@"TEST MandantList = %@",[m id]);
 
 //CommandList *cl=[CommandList parseFromData:d];
 //Command *c=[[cl mutableCommandList] objectAtIndex:0];
 //NSLog(@"TEST CommandList = %@",[c id]);
 
 //DocTypeIdList *dtil=[DocTypeIdList parseFromData:d];
 //NSLog(@"TEST DocTypeIdList = %@",[[dtil mutableDocTypeIdList] objectAtIndex:0]);
 
 //WbList *wbl=[WbList parseFromData:d];
 //Wb *wb=[[wbl mutableWbList] objectAtIndex:0];
 //NSLog(@"TEST WbList = %@",[wb id]);
 
 //ProcessTypeIdList *ptil=[ProcessTypeIdList parseFromData:d];
 //NSLog(@"TEST ProcessTypeIdList = %@",[[ptil mutableProcessTypeIdList] objectAtIndex:0]);
 
 IndexList *il=[IndexList parseFromData:d];
 Index *i=[[il mutableIndexList] objectAtIndex:0];
 NSLog(@"TEST IndexList = %@",[i id]);
 */
