#import "SettingFontVC.h"
#import "ThatkoLib.h"

@implementation SettingFontVC

-(void)initSettingArray{
	NSLog(@"x1");
	arrSetting=[[NSMutableArray alloc] init];
	NSLog(@"x2");
	[self add2Arr_id:@"GroupName" name:@"Group Name"];
	[self add2Arr_id:@"MandantName" name:@"Mandant Name"];
	[self add2Arr_id:@"WbName" name:@"WB Name"];
	[self add2Arr_id:@"ProcessName" name:@"Process Name"];
	[self add2Arr_id:@"DocumentName" name:@"Document Name"];
	NSLog(@"x3");
}
-(void)add2Arr_id:(NSString*)id name:(NSString*)name{
	NSLog(@"y1");
	NSMutableDictionary *dictValue=[[NSMutableDictionary alloc] init];
	NSLog(@"y2");
	[dictValue setObject:id forKey:@"ID"];
	[dictValue setObject:name forKey:@"Name"];
	NSLog(@"y3");
	[dictValue setObject:[prefs stringForKey:[NSString stringWithFormat:@"%@Size",id]] forKey:@"Size"];
	[dictValue setObject:[prefs stringForKey:[NSString stringWithFormat:@"%@Color",id]] forKey:@"Color"];
	NSLog(@"y4");
	[arrSetting addObject:dictValue];	
	NSLog(@"y5");
}
- (void)viewDidLoad {
	NSLog(@"DB1");
    [super viewDidLoad];
	NSLog(@"DB2");
	prefs = [NSUserDefaults standardUserDefaults];	
	NSLog(@"DB3");
	[self initSettingArray];	
	NSLog(@"DB4");
	self.navigationItem.title=@"Oxplorer";
	UIBarButtonItem *btSave=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(btSaveClicked)];        	
	self.navigationItem.rightBarButtonItem=btSave;		
	self.view.backgroundColor=[UIColor blackColor];	
	NSLog(@"DB5");
	pickerView=[[UIPickerView alloc] init];
	pickerView.showsSelectionIndicator = YES;
	pickerView.opaque=YES;
	pickerView.frame=CGRectMake(0, 80, 320,216);		
	NSLog(@"DB6");
	[pickerView setDataSource:self];
	[pickerView setDelegate:self];				
	NSLog(@"DB7");
	[self.view addSubview:pickerView];	
	NSLog(@"DB8");	
	[self changePickerByFirstComponentRow];
	NSLog(@"DB9");
}

// ==================================================================================================
#								pragma mark PICKER VIEW (DATASOURCE+DELEGATE)
// ==================================================================================================
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {	
	return 3;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {	
	if (component==0) return [arrSetting count];
	else if (component==1) return 7;
	else if (component==2) return 5;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return 32;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
	switch (component){
		case 0: 
			return 140;
		case 1: 
			return 66;
		case 2:
			return 108;
	}
	return 0;
}
-(void)changePickerByFirstComponentRow{	
	int r=[pickerView selectedRowInComponent:0]; // r == firstRow (first Component Row)
	NSLog(@"First row== %d",r);
	NSDictionary *d=[arrSetting objectAtIndex:r];
	
	int colorCode=[[d objectForKey:@"Color"] intValue];
	NSLog(@"Color code== %d",colorCode);	
	int secondRow=colorCode-1;
	NSLog(@"Second row == %d",secondRow);
	[pickerView selectRow:secondRow inComponent:1 animated:TRUE];
	
	int size=[[d objectForKey:@"Size"] intValue];
	if (size==11) [pickerView selectRow:0 inComponent:2 animated:TRUE];
	else if (size==13) [pickerView selectRow:1 inComponent:2 animated:TRUE];
	else if (size==15) [pickerView selectRow:2 inComponent:2 animated:TRUE];
	else if (size==17) [pickerView selectRow:3 inComponent:2 animated:TRUE];
	else if (size==19) [pickerView selectRow:4 inComponent:2 animated:TRUE];	
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
		
	UILabel *lbl = (UILabel *)view;
	lbl = [[[UILabel alloc] init] autorelease];
	lbl.backgroundColor=[UIColor clearColor];
	CGRect frame;

	if (component==0) {
		frame = CGRectMake(10, 0.0, 130, 22);			
		lbl.font=[UIFont boldSystemFontOfSize:16];
		lbl.textColor = [UIColor blackColor];
		lbl.text=[[arrSetting objectAtIndex:row] objectForKey:@"Name"];		
		/*if (row==0) lbl.text = @"Group name";
		else if (row==1) lbl.text = @"Mandant name"; 
		else if (row==2) lbl.text = @"WorkBasket name";*/
	} else if (component==1) {
		frame = CGRectMake(18, 0.0, 56, 22);			
		lbl.font=[UIFont boldSystemFontOfSize:15];
		int colorCode=row+1;
		lbl.text=[ThatkoLib colorTextForCode:colorCode];
		lbl.textColor=[ThatkoLib colorForCode:colorCode];
	} else if (component==2) {
		frame = CGRectMake(15, 0.0, 95, 22);					
		lbl.textColor = [UIColor blackColor];		
		int i=[self convertRowToFontSize:row];
		float f=(float)i;
		lbl.font=[UIFont systemFontOfSize:f];
		if (row==0) lbl.text=@"Very Small";
		else if (row==1) lbl.text=@"Small";
		else if (row==2) lbl.text=@"Medium";
		else if (row==3) lbl.text=@"Large";
		else if (row==4) lbl.text=@"X.Large";
	}		

	lbl.frame=frame;
	return lbl; 
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {	
	NSLog(@"didSelectRow of Picker");
	if (component==0) [self changePickerByFirstComponentRow];
	else if (component==1) { //COLOR
		NSMutableDictionary *d=[arrSetting objectAtIndex:[pickerView selectedRowInComponent:0]];
		[d setObject:[NSString stringWithFormat:@"%d",row+1] forKey:@"Color"];
	}
	else if (component==2) { //SIZE
		NSMutableDictionary *d=[arrSetting objectAtIndex:[pickerView selectedRowInComponent:0]];
		[d setObject:[NSString stringWithFormat:@"%d",[self convertRowToFontSize:row]] forKey:@"Size"];
	}
}

// ==================================================================================================
#								pragma mark BUTTON CLICKED
// ==================================================================================================
-(void)btSaveClicked{
	// WRITE arrSetting to NSUserDefaults
	for (NSDictionary *d in arrSetting) {
		NSString *id=[d objectForKey:@"ID"];
		int color=[[d objectForKey:@"Color"] intValue];
		int size=[[d objectForKey:@"Size"] intValue];
		
		[prefs setInteger:color forKey:[NSString stringWithFormat:@"%@Color",id]];		
		[prefs setInteger:size forKey:[NSString stringWithFormat:@"%@Size",id]];		
	}
	
	// BACK TO FIRST SCREEN
	[[self navigationController]  popViewControllerAnimated:TRUE];
}

// ==================================================================================================
#								pragma mark SUPPORT
// ==================================================================================================
-(int)convertRowToFontSize:(int)row{
	if (row==0) return 11;
	else if (row==1) return 13;
	else if (row==2) return 15;
	else if (row==3) return 17;
	else if (row==4) return 19;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)dealloc {
    [super dealloc];
}


@end
