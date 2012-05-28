#import "UIFactory.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIFactory

// ========================= HYPERLINK ====================== //
+(UITextView*)hyperlinkWithURL:(NSString*)urlPar frame:(CGRect)framePar{
	UITextView *link = [[UITextView alloc] initWithFrame:framePar];
	[link setFont:[UIFont boldSystemFontOfSize:12]];
	[link setBackgroundColor:[UIColor clearColor]];			
	[link setEditable:NO];
	[link setScrollEnabled:NO];
	[link setDataDetectorTypes:UIDataDetectorTypeLink];	
	[link setText:urlPar];  	
	return link;
}

// ========================= VIEW =========================== //
+(UIView*)viewTransparentWithFrame:(CGRect)framePar{
	UIView *view=[[UIView alloc] initWithFrame:framePar];
	view.backgroundColor=[UIColor clearColor];
	return view;
}
+(UIView*)viewBlackWithFrame:(CGRect)framePar{
	UIView *view=[[UIView alloc] initWithFrame:framePar];
	view.backgroundColor=[UIColor blackColor];
	return view;
}
+(UIView*)viewLowOpacityWithFrame:(CGRect)framePar{
	UIView *view=[[UIView alloc] initWithFrame:framePar];
	view.backgroundColor=[UIColor blackColor];
	view.layer.opacity=0.4;
	return view;
}
+(UIView*)borderedOrangeViewWithFrame:(CGRect)framePar{
	UIView *view=[[UIView alloc] initWithFrame:framePar];
	view.backgroundColor=[UIColor orangeColor];
	view.layer.cornerRadius=10.0;
	return view;
}
+(UIView*)whiteViewWithFrame:(CGRect)framePar{
	UIView *view=[[UIView alloc] initWithFrame:framePar];
	view.backgroundColor=[UIColor whiteColor];
	return view;
}
+(UIView*)roundedViewWithFrame:(CGRect)framePar{
	UIView *view=[[UIView alloc] init];
	view.layer.cornerRadius=10.0;
	view.backgroundColor=[UIColor whiteColor];
	view.frame=framePar;	
	return view;
}

// ========================= SCROLL VIEW =========================== //
+(UIScrollView*)scrollViewWithFrame:(CGRect)framePar{
	UIScrollView *scrollView=[[UIScrollView alloc] init];
	scrollView.frame=framePar;	
	[scrollView setScrollEnabled:YES];
	scrollView.autoresizesSubviews = NO;	
	scrollView.clipsToBounds = YES;
	return scrollView;
}

// ========================= TABLE VIEW =========================== //
+(UITableView *)tableViewWithFrame:(CGRect)framePar{
	UITableView *tableView=[[UITableView alloc] init];	
	tableView.frame=framePar;	
	tableView.scrollEnabled=FALSE;			
	return tableView;
}
+(UITableView *)roundedTableViewWithFrame:(CGRect)framePar{
	UITableView *tableView=[[UITableView alloc] init];	
	tableView.frame=framePar;
	tableView.scrollEnabled=FALSE;			
	tableView.layer.cornerRadius=10.0;	
	return tableView;
}
+(UITableView *)scrollableTableViewWithFrame:(CGRect)framePar{
	UITableView *tableView=[[UITableView alloc] init];	
	tableView.frame=framePar;	
	tableView.scrollEnabled=TRUE;			
	return tableView;
}
+(UITableView *)scrollableRoundedTableViewWithFrame:(CGRect)framePar{
	UITableView *tableView=[[UITableView alloc] init];	
	tableView.frame=framePar;	
	tableView.scrollEnabled=TRUE;			
	tableView.layer.cornerRadius=10.0;	
	return tableView;
}




// ========================= TEXT FIELD =========================== //
+(UITextField *)bigSecuredTextFieldWithPlaceHolderAtFrame:(CGRect)framePar{
    UITextField *tf=[self textFieldSecuredWithPlaceHolderAtFrame:framePar];
	tf.font=[UIFont boldSystemFontOfSize:20];
	tf.textAlignment=UITextAlignmentCenter;
	tf.textColor=[UIColor redColor];	
	tf.layer.cornerRadius=10.0;
	return tf;
}
+(UITextField*)textFieldWithFrame:(CGRect)framePar{
	UITextField *tf=[[UITextField alloc] initWithFrame:framePar];
	tf.autocorrectionType = UITextAutocorrectionTypeNo;
	tf.font=[UIFont systemFontOfSize:14];
	tf.backgroundColor=[UIColor whiteColor];
	return tf;
}
+(UITextField*)textFieldCenteredWithFrame:(CGRect)framePar{
	UITextField *tf=[self textFieldWithFrame:framePar];
	tf.textAlignment=UITextAlignmentCenter;
	return tf;
}

+(UITextField*)disabledTextFieldWithFrame:(CGRect)framePar{
	UITextField *tf=[self textFieldWithFrame:framePar];
	tf.enabled=FALSE;
	return tf;
}
+(UITextField*)textFieldWithPlaceHolderAtFrame:(CGRect)framePar{
	UITextField *tf=[self textFieldWithFrame:framePar];
	tf.placeholder = @"Nhập";
    return tf;
}
+(UITextField*)textFieldSecuredWithPlaceHolderAtFrame:(CGRect)framePar{
    UITextField *tf=[self textFieldWithPlaceHolderAtFrame:framePar];
    tf.secureTextEntry=TRUE;
    return tf;
}

// ========================= SPINNER & LOADING BACKGROUND =========================== //
+(UIActivityIndicatorView *) spinner{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(160, 180)]; 			
    [spinner setBackgroundColor:[UIColor clearColor]];
    return spinner;
}
+(UIView *)loadingBG{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(70, 120, 180, 90)];
    UILabel *label=[UIFactory boldLabelWithTitle:@"Processing..." frame:CGRectMake(10, 4, 160, 25)];
    [view addSubview:label];
    view.backgroundColor=[UIColor blackColor];
    view.layer.cornerRadius=10.0;
    view.alpha=0.8;
    return view;
}

// ========================= TEXT VIEW =========================== //
+(UITextView*)textViewWhiteRoundCornerWithFrame:(CGRect)framePar{
	UITextView *tv=[[UITextView alloc] initWithFrame:framePar];
	tv.backgroundColor=[UIColor whiteColor];
	tv.layer.cornerRadius=10;
	tv.editable=FALSE;
	return tv;	
}
+(UITextView*)whiteFontTextViewWithContent:(NSString*)contentPar frame:(CGRect)framePar{
	UITextView *tv=[[UITextView alloc] initWithFrame:framePar];
	tv.text =contentPar;
	tv.font=[UIFont boldSystemFontOfSize:15];
	tv.backgroundColor=[UIColor clearColor];
	tv.textColor=[UIColor whiteColor];
	tv.textAlignment=UITextAlignmentCenter;
	return tv;
}
+(UITextView*)textViewWithContent:(NSString*)contentPar frame:(CGRect)framePar{
    UITextView *tv=[[UITextView alloc] init];		
    tv.text=contentPar;
    tv.frame=framePar;
	tv.scrollEnabled=FALSE;
	tv.textColor=[UIColor blackColor];
    tv.backgroundColor=[UIColor whiteColor];    
    tv.font=[UIFont systemFontOfSize:11];
    tv.editable=FALSE;    
    return tv;
}
+(UITextView*)bigFontTextViewWithContent:(NSString*)contentPar frame:(CGRect)framePar{
	UITextView *tv=[self textViewWithContent:contentPar frame:framePar]; 
	tv.font=[UIFont systemFontOfSize:15];	
	return tv;
}

// ========================= LABEL =========================== //
+(UILabel *)smallBoldLabelWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
    UILabel *lb=[[UILabel alloc] initWithFrame:framePar];
    lb.text=titlePar;
    lb.textAlignment=UITextAlignmentLeft;
    lb.textColor=[UIColor blackColor];
    lb.font=[UIFont boldSystemFontOfSize:13];		
    return lb;
}
+(UILabel *)boldRightLabelWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
    UILabel *lb=[[UILabel alloc] initWithFrame:framePar];
    lb.text=titlePar;
    lb.textAlignment=UITextAlignmentRight;
    lb.textColor=[UIColor blackColor];
    lb.font=[UIFont boldSystemFontOfSize:14];		
    return lb;
}

+(UILabel *)labelWithTitle:(NSString *)titlePar frame:(CGRect)framePar{
    UILabel *lb=[[UILabel alloc] initWithFrame:framePar];
    lb.textColor=[UIColor whiteColor];
    lb.backgroundColor=[UIColor clearColor];
    lb.font=[UIFont systemFontOfSize:12];
    lb.textAlignment=UITextAlignmentCenter;		
    lb.text=titlePar;
    return lb;
}
+(UILabel *)boldLabelWithTitle:(NSString *)titlePar frame:(CGRect)framePar{
    UILabel *lb=[[UILabel alloc] initWithFrame:framePar];
    lb.textColor=[UIColor whiteColor];
    lb.backgroundColor=[UIColor clearColor];
    lb.font=[UIFont boldSystemFontOfSize:18];
    lb.textAlignment=UITextAlignmentCenter;		
    lb.text=titlePar;
    return lb;
}

+(UILabel *)labelRedBoldWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
	UILabel *lb=[self labelWithTitle:titlePar frame:framePar];
	lb.textColor=[UIColor redColor];
	lb.font=[UIFont boldSystemFontOfSize:15];
	return lb;
}

+(UILabel *)redLabelWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
    UILabel *lb=[self labelWithTitle:titlePar frame:framePar];
	lb.textAlignment=UITextAlignmentLeft;
    lb.textColor=[UIColor redColor];
    return lb;
}
+(UILabel *)leftRedLabelWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
    UILabel *lb=[self redLabelWithTitle:titlePar frame:framePar];
    lb.textAlignment=UITextAlignmentLeft;
    return lb;
}

+(UILabel *)blackLabelWithTitle:(NSString *)titlePar frame:(CGRect)framePar{
    UILabel *lb=[self labelWithTitle:titlePar frame:framePar];
    lb.textColor=[UIColor blackColor];
    return lb;
}
+(UILabel *)leftBlackLabelWithTitle:(NSString *)titlePar frame:(CGRect)framePar{
    UILabel *lb=[self blackLabelWithTitle:titlePar frame:framePar];
    lb.textAlignment=UITextAlignmentLeft;
    return lb;
}

+(UILabel *)labelFieldTitle:(NSString*)titlePar frame:(CGRect)framePar{
    UILabel *lb=[[UILabel alloc] initWithFrame:framePar];
    lb.font=[UIFont boldSystemFontOfSize:14];		    
    lb.text=titlePar;
    lb.backgroundColor = [UIColor clearColor];		
    return lb;
}

+(UILabel *)labelFieldData:(NSString*)titlePar frame:(CGRect)framePar{
    UILabel *lb=[[UILabel alloc] initWithFrame:framePar];
    lb.font=[UIFont systemFontOfSize:14];		    
    lb.text=titlePar;
    lb.backgroundColor = [UIColor clearColor];		
    return lb;
}




// ========================= BUTTON =========================== //
+(UIButton*)whiteButtonWithFrame:(CGRect)framePar{
	UIButton *bt=[[UIButton alloc] init];
	bt.frame=framePar;
	bt.backgroundColor=[UIColor whiteColor];					
	return bt;
}
+(UIButton*)buttonWithImage:(UIImage*)imgPar frame:(CGRect)framePar{
	UIButton *btn=[[UIButton alloc] initWithFrame:framePar];
	[btn setImage:imgPar forState:UIControlStateNormal];
	return btn;	 
}
+(UIButton*)buttonWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
    UIButton *bt=[[UIButton alloc] init];	
    [bt setTitle:titlePar forState:UIControlStateNormal];
    bt.titleLabel.font= [UIFont systemFontOfSize:13];
    bt.frame=framePar;   
    return bt;
}
+(UIButton*)telephoneButtonWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
    UIButton *bt=[[UIButton alloc] init];	
    [bt setTitle:titlePar forState:UIControlStateNormal];
    bt.titleLabel.font= [UIFont systemFontOfSize:15];
    [bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    bt.frame=framePar;   
    return bt;
}
+(UIButton*)smallTelephoneButtonWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
    UIButton *bt=[self telephoneButtonWithTitle:titlePar frame:framePar];
    bt.titleLabel.font= [UIFont systemFontOfSize:13];
    return bt;
}

+(UIButton*)roundedRectButtonWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
	UIButton *bt=[[UIButton alloc] init];		
	bt.frame=framePar;
	bt.titleLabel.font= [UIFont boldSystemFontOfSize:13];
    [bt setTitle:titlePar forState:UIControlStateNormal];
	[bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];			
    
    CAGradientLayer *gradientLayer;
    gradientLayer = [[CAGradientLayer alloc] init];
    [gradientLayer setBounds:[bt bounds]];
    [gradientLayer setPosition:CGPointMake([bt bounds].size.width/2, [bt bounds].size.height/2)];
    [gradientLayer setPosition:CGPointMake([bt bounds].size.width/2, [bt bounds].size.height/2)];
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor] , (id)[[UIColor blackColor] CGColor], nil]];
    
    [[bt layer] insertSublayer:gradientLayer atIndex:0];    
    [[bt layer] setCornerRadius:8.0f];
    [[bt layer] setMasksToBounds:YES];
    [[bt layer] setBorderWidth:1.0f];
	
	return bt;
}
+(UIButton*)smallRoundedButtonWithTitle:(NSString*)titlePar frame:(CGRect)framePar{
	UIButton *bt=[[UIButton alloc] init];		
	bt.frame=framePar;
	bt.titleLabel.font= [UIFont boldSystemFontOfSize:12];
    [bt setTitle:titlePar forState:UIControlStateNormal];
	[bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];			
    
    CAGradientLayer *gradientLayer;
    gradientLayer = [[CAGradientLayer alloc] init];
    [gradientLayer setBounds:[bt bounds]];
    [gradientLayer setPosition:CGPointMake([bt bounds].size.width/2, [bt bounds].size.height/2)];
    [gradientLayer setPosition:CGPointMake([bt bounds].size.width/2, [bt bounds].size.height/2)];
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor] , (id)[[UIColor blackColor] CGColor], nil]];
    
    [[bt layer] insertSublayer:gradientLayer atIndex:0];    
    [[bt layer] setCornerRadius:6.0f];
    [[bt layer] setMasksToBounds:YES];
    [[bt layer] setBorderWidth:0];
    
	return bt;
}

+(UIButton*)buttonOfLanguage:(NSString*)languagePar frame:(CGRect)framePar{    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"flag_%@.png",languagePar]];
    UIButton *btn=[[UIButton alloc] initWithFrame:framePar];
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}
+(UIButton*)buttonCheckBoxWithFrame:(CGRect)framePar{
	UIImage *image = [UIImage imageNamed:@"checkbox_off.png"];
    UIButton *btn=[[UIButton alloc] initWithFrame:framePar];
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}

@end
