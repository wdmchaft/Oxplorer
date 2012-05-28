#import "MoveWbViewController.h"
#import "UIFactory.h"

#import "MandantList.pb.h";
#import "WbList.pb.h"


@implementation MoveWbViewController

-(id)initWithConnector:(Connector*)conn{
	if (self=[super init]){
		connector=conn;
	}
	return self;
}

-(void)viewDidAppear:(BOOL)animated{
	[self.navigationController setToolbarHidden:YES];	
}
-(void)viewWillDisappear:(BOOL)animated{
	[self.navigationController setToolbarHidden:NO];
}
-(void)viewDidLoad{
	[super viewDidLoad];
	self.navigationItem.title=@"Move WorkBasket";	
	self.view.backgroundColor=[UIColor blackColor];
	imgCheckBoxOff = [UIImage imageNamed:@"checkbox_off.png"];
	imgCheckBoxOn = [UIImage imageNamed:@"checkbox_on.png"];
	destGroup=[[NSMutableDictionary alloc] init];	
	
	
	[self checkDB];
	groupList=[self getGroupListFromDB];
	
	//ml=[connector getMandantList_fetchServer:FALSE syncDb:FALSE];	
	wbl=[connector getWbList_fetchServer:FALSE fetchPID:FALSE syncPID:FALSE syncGroup:FALSE]; 
	
	
	// SCROLL VIEW
	int scrollViewHeight=310;
	scrollView=[UIFactory scrollViewWithFrame:CGRectMake(0, 45, 320, scrollViewHeight)];
	scrollView.delegate = self;
	
	// TABLE VIEW
	
    tableView=[UIFactory roundedTableViewWithFrame:CGRectMake(10, 5, 300, 1)];
	[tableView setDelegate:self];
	[tableView setDataSource:self];	
    
	
	// Select Destination Group box
	UIView * vSelectGroup=[UIFactory roundedViewWithFrame:CGRectMake(10, 5, 300, 35)];	
	UILabel *lbSelectGroup=[UIFactory smallBoldLabelWithTitle:@"Move to group:" frame:CGRectMake(8, 7, 100, 20)];
	[vSelectGroup addSubview:lbSelectGroup];	
	lbGroupName=[UIFactory redLabelWithTitle:@"" frame:CGRectMake(110, 8, 120, 20)];	
	[vSelectGroup addSubview:lbGroupName];	
	btSelectGroup=[UIFactory roundedRectButtonWithTitle:@"Select" frame:CGRectMake(245, 7, 50,20)];	
	[btSelectGroup addTarget:self action:@selector(btSelectGroupClicked) forControlEvents:UIControlEventTouchDown];
	[vSelectGroup addSubview:btSelectGroup];
	
	// 3 buttons: Apply / OK / Cancel
	UIButton *btApply=[UIFactory roundedRectButtonWithTitle:@"Apply" frame:CGRectMake(50, 380, 60,25)];
	[btApply addTarget:self action:@selector(btApplyClicked) forControlEvents:UIControlEventTouchDown];
	UIButton *btOK=[UIFactory roundedRectButtonWithTitle:@"OK" frame:CGRectMake(130, 380, 60,25)];
	[btOK addTarget:self action:@selector(btOkClicked) forControlEvents:UIControlEventTouchDown];
	UIButton *btCancel=[UIFactory roundedRectButtonWithTitle:@"Cancel" frame:CGRectMake(210, 380, 60,25)];	
	[btCancel addTarget:self action:@selector(btCancelClicked) forControlEvents:UIControlEventTouchDown];
	
	[self.view addSubview:vSelectGroup];
	[self.view addSubview:btApply];
	[self.view addSubview:btOK];
	[self.view addSubview:btCancel];
	
	[tableView setDelegate:self];
	[tableView setDataSource:self];	
	[tableView reloadData];
	
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
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	arrChangedWbCombinedId=[[NSMutableArray alloc] init]; //EMPTY ARR_CHANGED_WBID
	
	// CHANGE HEIGHT OF TABLEVIEW AND SCROLL VIEW CONTENT
	int tableHeight=(int)[self amountOfRowsInTableView];
	tableHeight*=30; //height of a row;
	tableView.frame=CGRectMake(10, 5, 300, tableHeight);
	[scrollView setContentSize:CGSizeMake(320, tableHeight)];	
	
	return [self amountOfRowsInTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {			
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.textLabel.font=[UIFont boldSystemFontOfSize:14];	

	
	
	if ([[self typeOfRow:indexPath.row] isEqualToString:@"group"]) {
		[btCheckBox removeFromSuperview];
		cell.textLabel.text=[self contentOfRow:indexPath.row];
	} else {
		btCheckBox=[UIFactory buttonCheckBoxWithFrame:CGRectMake(270, 5, 20, 20)];
		btCheckBox.tag=[[self wbCombinedIdOfRow:indexPath.row] copy]; // CombinedId = wbId_inMandantId
		NSLog(@"TEST btCheckBox.tag=%@",btCheckBox.tag);
		[btCheckBox addTarget:self action:@selector(btCheckboxClicked:) forControlEvents:UIControlEventTouchDown];
		
		cell.textLabel.text=[NSString stringWithFormat:@"     + %@",[self contentOfRow:indexPath.row]];
		[cell.contentView addSubview:btCheckBox];
	}	
    return cell;
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

// ==================================================================================================
#								pragma mark ACTION SHEET
// ==================================================================================================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {		
	NSLog(@"*** actionSheet");	
	if (buttonIndex==[actionSheet cancelButtonIndex]){
		NSLog(@"Clicking Cancel");
		return;
	}
	if ([[actionSheet title] isEqualToString:@"Group List"]) {		// MANDANT LIST				
		//GET GROUP dictionary
		
		int count=buttonIndex+1; //start from 1;
		for (NSMutableDictionary * aGroup in groupList) {		
			NSString *groupName=[aGroup objectForKey:@"Name"];
			if (![groupName isEqualToString:@"No Group"]){			
				count--;					
			}
			if (count==0){
				destGroup=aGroup;
				break;
			}				
		}
		NSLog(@"CLICKED GROUP: %@",[destGroup objectForKey:@"Name"]);
		lbGroupName.text=[destGroup objectForKey:@"Name"];
		[self removeCheckBox];
		if ([scrollView superview]==nil){			
			NSLog(@"Scroll view nil");
			[scrollView addSubview:tableView];
			[self.view addSubview:scrollView];
		}
		[tableView reloadData];
	} 
	
}
// ==================================================================================================
#								pragma mark EVENT HANDLER
// ==================================================================================================
-(void)btSelectGroupClicked{
	NSLog(@"Click Select Button");
	
	UIActionSheet *mandantActionSheet=[[UIActionSheet alloc] initWithTitle:@"Group List" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];	
	int count=0;
	for (NSMutableDictionary * aGroup in groupList) {				
		NSString *groupName=[aGroup objectForKey:@"Name"];
		if (![groupName isEqualToString:@"No Group"]){			
			[mandantActionSheet addButtonWithTitle: [aGroup objectForKey:@"Name"]];
			count++;
		}
	}
	[mandantActionSheet addButtonWithTitle:@"Cancel"];
	mandantActionSheet.cancelButtonIndex=count;
	[mandantActionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[mandantActionSheet release];			
}
-(void)btApplyClicked{
	NSLog(@"*** btApplyClicked");
	if ([lbGroupName.text isEqualToString:@""]) return;
	if ([arrChangedWbCombinedId count]==0) return;
	else NSLog(@"ARR CHANGE COUNT = %d",[arrChangedWbCombinedId count]);
	
	NSString *tmpWbId,*tmpMandantId;
	for (NSString *s in arrChangedWbCombinedId) {
		tmpWbId=[self getWbIdFromCombinedId:s];
		tmpMandantId=[self getMandantIdFromCombinedId:s];
		for (Wb *wb in wbl){
			if ( ([wb.id isEqualToString:tmpWbId]) && ([wb.inMandantId isEqualToString:tmpMandantId]) ) {
				[wb setInGroupId:[[destGroup objectForKey:@"ID"] intValue]];
			}			
		}
	}
	
	// TEST APPLY
	/*
	NSLog(@"TEST APPLY ****");
	for (NSDictionary *aWB in changedWbList) {
		NSLog(@"So, WB %@ - group %@",[aWB objectForKey:@"ID"],[aWB objectForKey:@"InGroupID"]);
	}*/
	
	[self removeCheckBox];
	//[tableView removeFromSuperview];
	[tableView reloadData];
}
-(void)removeCheckBox{	
	for (Wb *wb in wbl){
		UIButton *button = (UIButton *)[self.view viewWithTag:wb.id];
		[button removeFromSuperview];	
	}	
}
-(void)btOkClicked{
	if ([arrChangedWbCombinedId count]>0) [self btApplyClicked];
	[self saveNewWbListToDB];
	//[Connector syncWorkBasket];
	[self btCancelClicked];
}
-(void)saveNewWbListToDB{
	for (Wb *wb in wbl){
		NSLog(@"DO UPDATE - SET xInGroupID=%d WHERE xID=%@ AND xInMandantId=%@)",wb.inGroupId,wb.id,wb.inMandantId);
		sql = "UPDATE tb_WB SET xInGroupID=? WHERE xID=? AND xInMandantId=?";	
		sqlite3_prepare_v2(database, sql, -1, &compiledSql, NULL);
		sqlite3_bind_int(compiledSql, 1, wb.inGroupId);
		sqlite3_bind_text(compiledSql, 2, [wb.id UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledSql, 3, [wb.inMandantId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_step(compiledSql);		
	}
}

- (void)btCancelClicked{
	[[self navigationController] popToRootViewControllerAnimated:TRUE];				
}
- (void)btCheckboxClicked:(UIButton *)sender{
	NSLog(@"*** btCheckboxClicked");
	NSLog(@"sender.tag=%@",sender.tag);
	UIButton *bt = sender;
    bt.selected = !bt.selected; // toggle the selected property, just a simple BOOL	
	
    if (bt.selected){        
		NSLog(@"DB1");
		NSLog(@"SELECTED at WB ID = %@",sender.tag);
		NSLog(@"DB2");
		[bt setImage:imgCheckBoxOn forState:nil];		
		[arrChangedWbCombinedId addObject:sender.tag];
    } else {
		NSLog(@"NOT SELECTED");
		[bt setImage:imgCheckBoxOff forState:nil];
		[arrChangedWbCombinedId removeObject:sender.tag];
    }
}

// ==================================================================================================
#								pragma mark SUPPORT
// ==================================================================================================
-(int)amountOfRowsInTableView{
	int nRows=0;
	nRows+=groupList.count; // Group rows;
	for (NSMutableDictionary *aGroup in groupList) {
		if ([self amountOfWbInGroup:[aGroup objectForKey:@"ID"]]==0) {
			nRows--; // exclude EMPTY group;
		}
	}
	NSLog(@"**** nRows 1 = %d",nRows);
	
	// ADD WB ROWS	
	for (Wb *wb in wbl) {
		nRows++;
	}
			
	NSLog(@"**** nRows 2 = %d",nRows);
	
	// EXCEPT DESTINATION GROUP
	NSLog(@"DEST GROUP ID = %@",[destGroup objectForKey:@"ID"]);
	if (![lbGroupName.text isEqualToString:@""]) {
		int nWbInDestGroup=[self amountOfWbInGroup:[destGroup objectForKey:@"ID"]];
		NSLog(@" ** nWbInDestGroup = %d",nWbInDestGroup);
		if (nWbInDestGroup>0) {
			nRows=nRows-1-nWbInDestGroup;
		}
	}
	NSLog(@"**** nRows 3 = %d",nRows);
    return nRows;
}

-(NSString *)typeOfRow:(int)rowNo{ //return "group" / "workbasket"
	rowNo++; // count from 1, instead of 0 as default;
	int row=0; //already set row
	for (NSMutableDictionary *aGroup in groupList) {
		if ([[aGroup objectForKey:@"ID"] isEqualToString:[destGroup objectForKey:@"ID"]]) continue;
		if ([self amountOfWbInGroup:[aGroup objectForKey:@"ID"]]==0) continue;
		int tmp=[self amountOfWbInGroup:[aGroup objectForKey:@"ID"]];		
		tmp=tmp+1+row;		
		if (rowNo>tmp){ 
			row=tmp;
			continue;
		} else if (rowNo==(row+1)) return @"group";
		else return @"workbasket";			
	}
}
-(NSString *)contentOfRow:(int)rowNo{
	NSLog(@"START GETTING CONTENT OF ROW: %d",rowNo);
	rowNo++; // count from 1, instead of 0 as default;
	int row=0; //already set row
	for (NSMutableDictionary *aGroup in groupList) {
		if ([[aGroup objectForKey:@"ID"] isEqualToString:[destGroup objectForKey:@"ID"]]) continue;
		if ([self amountOfWbInGroup:[aGroup objectForKey:@"ID"]]==0) continue;
		int tmp=[self amountOfWbInGroup:[aGroup objectForKey:@"ID"]];		
		tmp=tmp+1+row;
		
		if (rowNo>tmp){ 
			row=tmp;
			continue;
		} else if (rowNo==(row+1)){
			return [aGroup objectForKey:@"Name"];			
		} else {
			//NSLog(@"Case3 - AtIndex:%d, ofGroupID:%@, wbID=%@",rowNo-row-1,[aGroup objectForKey:@"ID"],[self getWbAtIndex:rowNo-row-1 ofGroupID:[aGroup objectForKey:@"ID"]]);			
			//return [Connector getNameOfWbID:[self getWbAtIndex:rowNo-row-1 ofGroupID:[aGroup objectForKey:@"ID"]]];
			Wb *tmpWb=[self getWbAtIndex:rowNo-row-1 ofGroupID:[aGroup objectForKey:@"ID"]];
			return [NSString stringWithFormat:@"[%@] %@",tmpWb.inMandantId,tmpWb.id];
		}
	}	
}
-(NSString *)wbCombinedIdOfRow:(int)rowNo{ // CombinedId= wbId_inMandantId
	rowNo++; // count from 1, instead of 0 as default;
	int row=0; //already set row
	for (NSMutableDictionary *aGroup in groupList) {
		if ([[aGroup objectForKey:@"ID"] isEqualToString:[destGroup objectForKey:@"ID"]]) continue;
		if ([self amountOfWbInGroup:[aGroup objectForKey:@"ID"]]==0) continue;
		int tmp=[self amountOfWbInGroup:[aGroup objectForKey:@"ID"]];		
		tmp=tmp+1+row;
		
		if (rowNo>tmp){ 
			row=tmp;
			continue;
		} else if (rowNo==(row+1)){
			return nil; //NOT INVALID (this method is only for WB row)
		} else {	
			Wb *tmpWb=[self getWbAtIndex:rowNo-row-1 ofGroupID:[aGroup objectForKey:@"ID"]];
			NSLog(@"~~~~~ tmpWbCombinedId ====== %@_%@",tmpWb.id,tmpWb.inMandantId);
			return [[NSString stringWithFormat:@"%@_%@",tmpWb.id,tmpWb.inMandantId] copy];
		}
	}	
}

-(int)amountOfWbInGroup:(NSString*)groupID{
	int amount=0;	
	for (Wb *wb in wbl) {
		//NSLog(@"GETTING AMOUNT OF WB: %@ in GROUP: %d",wb.name,wb.inGroupId);
		if (wb.inGroupId==[groupID intValue]) {
			amount++;
		}
	}	
	return amount;
}
-(Wb *)getWbAtIndex:(int)wbNo ofGroupID:(NSString*)groupID{
	for (Wb *wb in wbl) {
		if (wb.inGroupId==[groupID intValue]) wbNo--;
		if (wbNo==0) return wb;
	}
	return nil;	
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}
@end
