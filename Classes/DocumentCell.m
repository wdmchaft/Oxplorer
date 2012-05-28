#import "DocumentCell.h"
#import "UIFactory.h"
#import <QuartzCore/QuartzCore.h>

@implementation DocumentCell
@synthesize lbDocumentName,lbNumPages,tvDocIndex,ivFirstPage,ivMultiPages,imgDocThumbnail,btTransparent1,btTransparent2;

-(id)initWithFrame:(CGRect)frame andNumberOfLines:(int)nLinesPar andThumbImage:(UIImage*)imagePar andNumberOfPages:(int)nPagesPar reuseIdentifier:(NSString *)reuseIdentifier{
	if (self=[super initWithFrame:frame reuseIdentifier:reuseIdentifier]){		
		nLines=nLinesPar;
		imgDocThumbnail=imagePar;
		NSString *testContent=@"Number: 123456. Amount: $500. Currency: USD. Customer: Cocacola. ABC: 123. XYZ: 789. ETC... ... ... ... ... ... ... ...";		
		int tvIndexHeight;
		if (nLines<=2) {
			tvIndexHeight=35;
		} else {
			tvIndexHeight=35+15*(nLines-2);
		}
		
		tvDocIndex=[UIFactory textViewWithContent:testContent frame:CGRectMake(2, 10, 270, tvIndexHeight)];				
		[self.contentView addSubview:tvDocIndex];
		
		lbDocumentName=[[UILabel alloc] initWithFrame:CGRectMake(3, 2, 250, 14)];		
		lbDocumentName.text=@"";
		//lb.backgroundColor=[UIColor clearColor];
		//lb.font=[UIFont systemFontOfSize:14];
		//lb.textAlignment=UITextAlignmentLeft;				
		[self.contentView addSubview:lbDocumentName];
		
		int offsetY=0;
		if (nLines>2) {
			offsetY=7*(nLines-2);
		}
		if (nPagesPar>1) {
			ivMultiPages=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black.jpg"]];
			ivMultiPages.frame=CGRectMake(273, 2+offsetY, 32, 37);		
			[self.contentView addSubview:ivMultiPages];
		}
		
		UIImageView *ivBorder=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black.jpg"]];
		ivBorder.frame=CGRectMake(269, 6+offsetY, 32, 37);		
		[self.contentView addSubview:ivBorder];
		
		ivFirstPage=[[UIImageView alloc] initWithImage:imgDocThumbnail];
		ivFirstPage.frame=CGRectMake(270, 7+offsetY, 30, 35);		
		[self.contentView addSubview:ivFirstPage];
		
		if (nPagesPar>1) {
			lbNumPages=[UIFactory labelRedBoldWithTitle:@"" frame:CGRectMake(300, 22+offsetY, 20, 25)];
			[self.contentView addSubview:lbNumPages];
		}
		
		// TRANSPARENT VIEW 1 --> change to Document Index View
		btTransparent1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 20+tvIndexHeight)];		
		btTransparent1.backgroundColor=[UIColor clearColor];
		//btTransparent1.backgroundColor=[UIColor yellowColor];
		[self.contentView addSubview:btTransparent1];
		
		// TRANSPARENT VIEW 2 --> change to Document Page View
		btTransparent2=[[UIButton alloc] initWithFrame:CGRectMake(250, 0, 70, 20+tvIndexHeight)];
		btTransparent2.backgroundColor=[UIColor clearColor];
		//btTransparent2.backgroundColor=[UIColor redColor];
		[self.contentView addSubview:btTransparent2];
		
		self.contentView.frame=CGRectMake(0, 0, 320, 20+tvIndexHeight);
		
	}
	return self;
}

- (void)layoutSubviews {
}

@end
