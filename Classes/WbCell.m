#import "WbCell.h"

@implementation WbCell
@synthesize lbMandant,lbWbName,lbNewRead,lbLastBuildDate,infoButton;

-(id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier{
	if (self=[super initWithFrame:frame reuseIdentifier:reuseIdentifier]){
		lbMandant=[[UILabel alloc] init];
		lbMandant.textAlignment=UITextAlignmentLeft;
		//lbMandant.font=[UIFont boldSystemFontOfSize:14];		
		//lbMandant.backgroundColor=[UIColor blackColor];
		[self.contentView addSubview:lbMandant];		
		
		lbWbName=[[UILabel alloc] init];
		lbWbName.textAlignment=UITextAlignmentLeft;
		//lbWbName.font=[UIFont boldSystemFontOfSize:17];
		//lbWbName.textColor=[UIColor orangeColor];		
		[self.contentView addSubview:lbWbName];						
		
		lbNewRead=[[UILabel alloc] init];
		lbNewRead.textAlignment=UITextAlignmentLeft;
		lbNewRead.font=[UIFont boldSystemFontOfSize:22];
		lbNewRead.textColor=[UIColor blackColor];
		[self.contentView addSubview:lbNewRead];		
		
		lbLastBuildDate=[[UILabel alloc] init];
		lbLastBuildDate.textAlignment=UITextAlignmentLeft;
		lbLastBuildDate.font=[UIFont systemFontOfSize:13];
		lbLastBuildDate.textColor=[UIColor blackColor];
		[self.contentView addSubview:lbLastBuildDate];		
		
		/*
		 UILabel *lbUnreadText=[[UILabel alloc] init];
		 lbUnreadText.text=@"Unread:";
		 lbUnreadText.font=[UIFont systemFontOfSize:15];
		 lbUnreadText.frame=CGRectMake(230, 8, 50, 22);
		 [self.contentView addSubview:lbUnreadText];
		 */
		//xxxxx
		//infoButton=[UIButton buttonWithType:UIButtonTypeInfoDark];
		//[self.contentView addSubview:infoButton];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	//[self setBackgroundColor:[UIColor blackColor]];
	
	lbMandant.frame = CGRectMake(boundsX+5 ,1, 110, 19);
	lbWbName.frame = CGRectMake(boundsX+118 ,10, 250, 18);
	lbNewRead.frame = CGRectMake(boundsX+275 ,8, 67, 22);
	lbLastBuildDate.frame = CGRectMake(boundsX+5 ,21, 110, 18);
	//xxxxx
	//infoButton.frame= CGRectMake(boundsX+295, 10, 19, 19);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {	
	[super setSelected:selected animated:animated];
}


@end
