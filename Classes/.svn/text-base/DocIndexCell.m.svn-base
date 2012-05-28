#import "DocIndexCell.h"
#import "UIFactory.h"

@implementation DocIndexCell
@synthesize lbTitle,lbContent,tfContent,btChange,btSave,btCancel;

-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)titlePar andContent:(NSString*)contentPar reuseIdentifier:(NSString *)reuseIdentifier{
	if (self=[super initWithFrame:frame reuseIdentifier:reuseIdentifier]){
		lbTitle=[UIFactory smallBoldLabelWithTitle:titlePar frame:CGRectMake(5, 2, 70, 25)];
		[self.contentView addSubview:lbTitle];
		
		//lbContent=[UIFactory leftBlackLabelWithTitle:contentPar frame:CGRectMake(85, 2, 140, 25)];
		//[self.contentView addSubview:lbContent];
		NSLog(@"ContentPar == %@",contentPar);
		tfContent=[UIFactory textFieldWithFrame:CGRectMake(80, 6, 112, 18)];
		tfContent.text=contentPar;
		tfContent.enabled=FALSE;
		//tfContent.editing=FALSE;
		[self.contentView addSubview:tfContent];
		
		btChange=[UIFactory roundedRectButtonWithTitle:@"Change" frame:CGRectMake(230, 4, 60, 21)];
		[self.contentView addSubview:btChange];
		btSave=[UIFactory roundedRectButtonWithTitle:@"Save" frame:CGRectMake(250, 4, 40, 21)];
		btCancel=[UIFactory roundedRectButtonWithTitle:@"Cancel" frame:CGRectMake(195, 4, 50, 21)];
		//[self.contentView addSubview:btSave];
		

	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

@end
