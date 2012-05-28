#import "TableIndexViewController.h"
#import "UIFactory.h"
#import "Connector.h"
#import "ThatkoLib.h"

@implementation TableIndexViewController
@synthesize dbIndexList;

#pragma mark -
#pragma mark Initialization

-(id)initWithDoc:(MyDocument*)docPar process:(MyProcess*)processPar allIndexList:(NSMutableArray*)allIndexListPar dbIndexList:(NSMutableArray*)dbIndexListPar mandantId:(NSString*)mandantIdPar{
	self=[super init];
	doc=docPar;
	process=processPar;
	allIndexList=[allIndexListPar copy];
	dbIndexList=[dbIndexListPar copy];
	selectedMandantId=mandantIdPar;
	return self;
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int nRows=1; //type row
	nRows+=[allIndexList count];
	NSLog(@"nRows ====== %d",nRows);
    return nRows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"&&&& Cell for row at index path");
    static NSString *CellIdentifier = @"DocIndexCell";    
    DocIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	NSString *title,*content;
	MyIndex *index,*local_selectedIndex;
    if (indexPath.row==0){
		title=@"Type:";
		content=doc.typeId;		
	} else {
		index=[allIndexList objectAtIndex:indexPath.row-1];
		local_selectedIndex=index;
		title=[NSString stringWithFormat:@"%@:",index.name];
		
		//get content of index (if available <-- from dbIndexList)
		NSString *indexId=index.id;
		content=@"";
		for (MyIndex *i in dbIndexList) {
			NSLog(@"loop index value=%@",i.value);
			if ([i.id isEqualToString:indexId]) {
				content=i.value;
				local_selectedIndex=i;
				break;
			}
		}		
	}
	NSLog(@"content====%@",content);
    cell = [[DocIndexCell alloc] initWithFrame:CGRectZero andTitle:title andContent:content reuseIdentifier:CellIdentifier];
	
	NSMutableDictionary *tagDict=[[NSMutableDictionary alloc] init];
	[tagDict setObject:cell forKey:@"cell"];
	[tagDict setObject:content forKey:@"Content"];
	//[tagDict setObject:local_selectedIndex forKey:@"local_selectedIndex"];
	if (indexPath.row!=0) 
		[tagDict setObject:local_selectedIndex forKey:@"local_selectedIndex"];

	if (indexPath.row==0) [tagDict setObject:@"DocumentType" forKey:@"type"];
	else if ([index.name isEqualToString:@"Currency"]) [tagDict setObject:@"IndexList" forKey:@"type"];
	else [tagDict setObject:@"" forKey:@"type"];
	
	cell.btChange.tag=tagDict;
	
	[cell.btChange addTarget:self action:@selector(btChangeClicked:) forControlEvents:UIControlEventTouchDown];		 	

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

// ==================================================================================================
#								pragma mark PICKER VIEW (DATASOURCE+DELEGATE)
// ==================================================================================================
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {	
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {	
	return [allIndexList count];
}
-(int)getInitRowOfPicker{	
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	MyIndex *index=[allIndexList objectAtIndex:row];
	//if (row==0) selectedIndex=[index copy]; 
	
	NSString *result,*id,*name,*value;
	id=index.id;
	name=index.name;	
	result=[name copy];
	
	//loop through dbIndexList to get index value (if available)
	for (MyIndex *index in dbIndexList) {
		if ([index.id isEqualToString:id]) {
			value=[index.value copy];			
			result=[NSString stringWithFormat:@"%@ [=%@]",name,value];
			break;
		}
	}
	
	NSLog(@"PICKER VIEW ROW %d = %@",row,result);
	return result;	
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {	
	NSLog(@"didSelectRow of Picker");
	selectedIndex=[allIndexList objectAtIndex:row];
}

// ==================================================================================================
#								pragma mark BUTTON CLICKED
// ==================================================================================================
-(void)btChangeClicked:(UIButton*)sender{
	NSLog(@"BT CHANGE CLICKED: Mandant Id = %@",selectedMandantId);
	NSMutableDictionary *tagDict=sender.tag;
	NSString *type=[tagDict objectForKey:@"type"];
	DocIndexCell *cell=[tagDict objectForKey:@"cell"];
	
	if ([type isEqualToString:@"DocumentType"]) {
		NSLog(@"DocumentType***");
		[self showAsSelectDocumentType];
		
	} else if ([type isEqualToString:@"IndexList"]) {			
		NSLog(@"IndexList");
		selectedIndex=[tagDict objectForKey:@"local_selectedIndex"];
		selectedCell=cell;
		UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Select Value" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];		
		int count=3;		
		[actionSheet addButtonWithTitle: @"EUR"];
		[actionSheet addButtonWithTitle: @"USD"];
		[actionSheet addButtonWithTitle: @"VND"];
		
		[actionSheet addButtonWithTitle:@"Cancel"];
		actionSheet.cancelButtonIndex=count;
		[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
		[actionSheet release];	
	} else {
		NSLog(@"normal");
				
		NSString *indexId=[[tagDict objectForKey:@"local_selectedIndex"] id];
		NSString *last3charsOfIndexId=[indexId substringFromIndex:[indexId length]-3];		
		NSLog(@" Last 3 chars = %@",last3charsOfIndexId);
		if ([last3charsOfIndexId isEqualToString:@"int"]) {
			NSLog(@"Equal");
			cell.tfContent.keyboardType = UIKeyboardTypeNumberPad;		
			tfCurrency=cell.tfContent;
			[tfCurrency addTarget:self action:@selector(tfCurrencyDidChange) forControlEvents:UIControlEventEditingChanged];
		} else {
			NSLog(@"Not equal");				  
			cell.tfContent.keyboardType= UIKeyboardTypeDefault;
		}
		cell.tfContent.enabled=TRUE;
		cell.tfContent.backgroundColor=[UIColor yellowColor];
		[cell.tfContent becomeFirstResponder];
		[cell.btChange removeFromSuperview];
		
		[cell addSubview:cell.btSave];
		cell.btSave.tag=tagDict;
		[cell.btSave addTarget:self action:@selector(btSaveClicked:) forControlEvents:UIControlEventTouchDown];		 	

		[cell addSubview:cell.btCancel];
		cell.btCancel.tag=tagDict;
		[cell.btCancel addTarget:self action:@selector(btCancelClicked:) forControlEvents:UIControlEventTouchDown];		 	
	}
}
-(void)btCancelClicked:(UIButton*)sender{
	NSMutableDictionary *tagDict=sender.tag;
	DocIndexCell *cell=[tagDict objectForKey:@"cell"];
	NSString *content=[tagDict objectForKey:@"Content"];
	
	cell.tfContent.text=content;
	cell.tfContent.enabled=FALSE;
	cell.tfContent.backgroundColor=[UIColor clearColor];
	[cell.btSave removeFromSuperview];
	[cell.btCancel removeFromSuperview];
	[cell addSubview:cell.btChange];
}
-(void)btSaveClicked:(UIButton*)sender{
	NSMutableDictionary *tagDict=sender.tag;
	DocIndexCell *cell=[tagDict objectForKey:@"cell"];	
	MyIndex *local_selectedIndex=[tagDict objectForKey:@"local_selectedIndex"];
	
	cell.tfContent.enabled=FALSE;
	cell.tfContent.backgroundColor=[UIColor clearColor];
	[cell.btSave removeFromSuperview];
	[cell.btCancel removeFromSuperview];
	[cell addSubview:cell.btChange];
	
	[Connector addIndexToDb:local_selectedIndex docId:doc.dId value:cell.tfContent.text segmentId:-1];	
	dbIndexList=[Connector getDbIndexListOfDoc:doc];
	//[self viewDidUnload];
	//[self viewDidLoad];
	
	/*
	cell.tfContent.enabled=FALSE;
	cell.tfContent.backgroundColor=[UIColor clearColor];
	[cell.btSave removeFromSuperview];
	[cell.btCancel removeFromSuperview];
	[cell addSubview:cell.btChange];
	 */
}

// ==================================================================================================
#								pragma mark TEXTFIELD DELEGATE
// ==================================================================================================
-(void)tfCurrencyDidChange{
    NSString *amt = [ThatkoLib formatCurrency:[ThatkoLib removeDot:[tfCurrency.text copy]]];
	if (![tfCurrency.text isEqualToString:amt]){
		tfCurrency.text=[amt copy];
	}
}


// ==================================================================================================
#								pragma mark ACTION SHEET
// ==================================================================================================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {		
	NSLog(@"*** actionSheet");
	if (buttonIndex==[actionSheet cancelButtonIndex]) return;
	if ([[actionSheet title] isEqualToString:@"Select Value"]) {		
		NSString *buttonString=[actionSheet buttonTitleAtIndex:buttonIndex];
		selectedCell.tfContent.text=buttonString;
		[Connector addIndexToDb:selectedIndex docId:doc.dId value:buttonString segmentId:-1];	
		dbIndexList=[Connector getDbIndexListOfDoc:doc];
		[self.tableView reloadData];
	} else if ([[actionSheet title] isEqualToString:@"Select Document Type"]) {
		if (buttonIndex==0) {
			UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Select Process Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Back" otherButtonTitles:nil];		
			int count=4;		
			[actionSheet addButtonWithTitle: @"ProcessType 1"];
			[actionSheet addButtonWithTitle: @"ProcessType 2"];
			[actionSheet addButtonWithTitle: @"ProcessType 3"];
			
			[actionSheet addButtonWithTitle:@"Cancel"];
			actionSheet.cancelButtonIndex=count;
			[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
			[actionSheet release];			
		}
	} else if ([[actionSheet title] isEqualToString:@"Select Process Type"]) {
		if (buttonIndex==0) {
			[self showAsSelectDocumentType];
		}
	}
}

// ==================================================================================================
#								pragma mark SUPPORT
// ==================================================================================================
-(void)showAsSelectDocumentType{
	UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Select Document Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Change Process Type" otherButtonTitles:nil];		
	int count=4;		
	[actionSheet addButtonWithTitle: @"DocType 1"];
	[actionSheet addButtonWithTitle: @"DocType 2"];
	[actionSheet addButtonWithTitle: @"DocType 3"];
	
	[actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.cancelButtonIndex=count;
	[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[actionSheet release];			
}

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

