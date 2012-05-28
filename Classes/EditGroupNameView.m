#import "EditGroupNameView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EditGroupNameView
@synthesize lbEditGroupName,tfEditGroupName,btOK,btCancel;
-(id)initWithGroupName:(NSString*)groupName{
	self=[super init];
	self.frame=CGRectMake(0, 0, 320, 480);
	self.backgroundColor=[UIColor blackColor];
	[self setBackgroundColor:[UIColor blackColor]];
	
	tfEditGroupName=[[UITextField alloc] init];
	tfEditGroupName.backgroundColor=[UIColor whiteColor];
	tfEditGroupName.textColor=[UIColor blackColor];
	tfEditGroupName.layer.cornerRadius=5;
	tfEditGroupName.autocorrectionType = UITextAutocorrectionTypeNo;
	tfEditGroupName.clipsToBounds = YES;
	[tfEditGroupName.layer setBorderColor: [[UIColor redColor] CGColor]];
	[tfEditGroupName.layer setBorderWidth: 2.0];
	[tfEditGroupName.layer setCornerRadius:8.0f];
	[tfEditGroupName.layer setMasksToBounds:YES];
	tfEditGroupName.font=[UIFont systemFontOfSize:25];
	tfEditGroupName.frame=CGRectMake(60, 80, 200, 36);
	
	tfEditGroupName.textAlignment=UITextAlignmentCenter;
	tfEditGroupName.placeholder=groupName;
	tfEditGroupName.selected=TRUE;
	[tfEditGroupName setDelegate:self];
	
	lbEditGroupName=[[UILabel alloc] init];
	lbEditGroupName.textAlignment=UITextAlignmentCenter;
	lbEditGroupName.font=[UIFont systemFontOfSize:18];
	lbEditGroupName.backgroundColor=[UIColor blackColor];
	lbEditGroupName.textColor=[UIColor whiteColor];
	lbEditGroupName.frame=CGRectMake(60, 40, 200, 36);
	lbEditGroupName.text=@"Set Group Name";
	
	
	btOK=[[UIButton alloc] init];		
	[btOK setTitle:@"OK" forState:nil];
	[btOK setFont:[UIFont systemFontOfSize:18]];
	[btOK setTitleColor:[UIColor greenColor] forState:nil];
	btOK.frame=CGRectMake(51, 120, 50, 36);	
	btCancel=[[UIButton alloc] init];		
	[btCancel setTitle:@"Cancel" forState:nil];
	[btCancel setFont:[UIFont systemFontOfSize:18]];
	[btCancel setTitleColor:[UIColor redColor] forState:nil];
	btCancel.frame=CGRectMake(170, 120, 120, 36);	
	
	
	[self addSubview:tfEditGroupName];
	[self addSubview:lbEditGroupName];
	[self addSubview:btOK];
	[self addSubview:btCancel];
	[tfEditGroupName becomeFirstResponder];
	
	return self;
}

@end
