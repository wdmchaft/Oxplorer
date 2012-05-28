#import "RedEdge.h"

@implementation RedEdge

-(id)initWithRect:(CGRect)rect{
	self=[super init];
	self.frame=rect;
	self.backgroundColor=[UIColor redColor];
	return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();	
    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(c, red);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 5.0f, 5.0f);
    CGContextAddLineToPoint(c, 50.0f, 50.0f);
    CGContextStrokePath(c);
}
@end
