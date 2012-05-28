#import "GroupCell.h"
#import "ThatkoLib.h"

@implementation GroupCell
@synthesize lbGroupName,btToggle,btEdit,btDelete,btDown;

-(void)expanded:(int)value{
	if (value) [btToggle setImage:[UIImage imageNamed:@"arrow_doc.jpg"] forState:UIControlStateNormal];
	else [btToggle setImage:[UIImage imageNamed:@"arrow_ngang.jpg"] forState:UIControlStateNormal];	
}
-(id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier{
	if (self=[super initWithFrame:frame reuseIdentifier:reuseIdentifier]){
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];	
							
		btToggle=[UIButton buttonWithType:UIButtonTypeCustom];				
		[self.contentView addSubview:btToggle];		
		lbGroupName=[[UILabel alloc] init];
		lbGroupName.textAlignment=UITextAlignmentLeft;		
		lbGroupName.backgroundColor=[UIColor blackColor];
		[self.contentView addSubview:lbGroupName];				
		
		btEdit=[[[UIButton alloc] init] retain];
		btEdit=[UIButton buttonWithType:UIButtonTypeRoundedRect];		
		[btEdit setTitle:@"Edit" forState:nil];
		[btEdit setFont:[UIFont systemFontOfSize:13]];
		[btEdit setTitleColor:[UIColor blackColor] forState:nil];		
		[self.contentView addSubview:btEdit];		
		
		btDelete=[[[UIButton alloc] init] retain];
		btDelete=[UIButton buttonWithType:UIButtonTypeRoundedRect];		
		[btDelete setTitle:@"X" forState:nil];
		[btDelete setFont:[UIFont systemFontOfSize:13]];
		[btDelete setTitleColor:[UIColor blackColor] forState:nil];		
		[self.contentView addSubview:btDelete];				
		
		btDown=[UIButton buttonWithType:UIButtonTypeCustom];				
		[btDown setImage:[UIImage imageNamed:@"arrow_doc.jpg"] forState:UIControlStateNormal];
		[self.contentView addSubview:btDown];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	[self setBackgroundColor:[UIColor blackColor]];
		
	btToggle.frame = CGRectMake(boundsX+2 ,2, 15, 20);	
	lbGroupName.frame = CGRectMake(boundsX+28 ,2, 282, 20);
	btEdit.frame = CGRectMake(195 ,5, 35, 16);
	btDown.frame = CGRectMake(255 ,2, 15, 20);
	btDelete.frame = CGRectMake(297 ,5, 16, 16);
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {	
	[super setSelected:selected animated:animated];
}


@end
