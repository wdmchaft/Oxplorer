#import "MyScrollView.h"

@implementation MyScrollView

-(id)initWithFrame:(CGRect)frame image:(UIImage*)image segmentDict:(NSMutableDictionary*)dictPar{
	self=[super initWithFrame:frame];
	if (self) {		
		// CALCULATE CENTER FRAME FOR IMAGE
		float w=image.size.width;
		float h=image.size.height;
		int imageSpaceWidth=frame.size.width;
		int imageSpaceHeight=frame.size.height;
		CGRect imageFrame;
		if ((w/imageSpaceWidth)>(h/imageSpaceHeight)) {
			NSLog(@"Truong hop RONG: (w/h)=(%f/%f)",w,h);
			h=imageSpaceWidth*h/w;
			w=imageSpaceWidth;		
			imageFrame=CGRectMake(0, (imageSpaceHeight-h)/2, w, h);
		} else {
			NSLog(@"Truong hop DAI: (w/h)=(%f/%f)",w,h);
			w=imageSpaceHeight*w/h;
			h=imageSpaceHeight;
			imageFrame=CGRectMake((imageSpaceWidth-w)/2, 0, w, h);
		}	
		// IMAGE VIEW
		UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] retain];	
		imageView.frame=imageFrame;	
		[self addSubview:imageView];		
		
		[self setScrollEnabled:YES];
		self.autoresizesSubviews = NO;
		self.backgroundColor=[UIColor blackColor];	
		realImageSize=CGSizeMake(imageFrame.size.width, imageFrame.size.height);
		
		baseShiftX=imageFrame.origin.x;
		baseShiftY=imageFrame.origin.y;
		shiftX=baseShiftX;
		shiftY=baseShiftY;
		[self setContentSize:realImageSize];
		self.maximumZoomScale = 5.0;
		self.minimumZoomScale = 1;
		self.clipsToBounds = YES;	
		dict=[dictPar copy];
		//imageDict=[[[[dict objectForKey:@"document"] objectForKey:@"pageList"] objectForKey:@"page"] objectForKey:@"ns2:recognition"];
		imageDict=[[dict objectForKey:@"page"] objectForKey:@"ns2:recognition"];
		segmentsArr=[[[imageDict objectForKey:@"segmentation"] objectForKey:@"segmentList"] objectForKey:@"segment"];
		nSegments=[segmentsArr count];		
		xmlImageSize=CGSizeMake([[[[imageDict objectForKey:@"imageData"] objectForKey:@"width"] objectForKey:@"text"] floatValue], [[[[imageDict objectForKey:@"imageData"] objectForKey:@"height"] objectForKey:@"text"] floatValue]);
	}
	return self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"*** TOUCHES BEGAN");
	[self removeTouchRectangle];
}
-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{			
	NSLog(@"*** TOUCHES ENDED");	
	//shiftX=baseShiftX-((self.zoomScale-1)*realImageSize.width);
	//shiftX=baseShiftX-((self.zoomScale-1)*realImageSize.width);
	NSLog(@"Zoom scale=%f",self.zoomScale);
	UITouch * t;
	CGPoint p;
	if([[event allTouches] count]==1){
		t=[[[event allTouches] allObjects] objectAtIndex:0];
		p=[t locationInView:self];
		NSLog(@" p==(%f,%f)",p.x,p.y);		
	}	
	imageTouchX=(p.x-shiftX)/(self.zoomScale);
	imageTouchY=(p.y-shiftY)/(self.zoomScale);
	NSLog(@"imageTouch=(%d,%d)",imageTouchX,imageTouchY);
	
	//[self touchAt:p];
	//[self drawSegmentWithX:400 Y:600 W:50 H:40];	
	if ([self getSegmentIdTouched]!=-1){
		//NSMutableDictionary *aSegmentDict=[segmentsArr objectAtIndex:[self getSegmentIdTouched]];
		[self getSegmentIdTouched];
		[self drawSegmentWithX:selectedSegmentX Y:selectedSegmentY W:selectedSegmentW H:selectedSegmentH];
	}
}	

-(int)getSegmentIdTouched{	
	int nearestSegmentId=-1;
	int nearestDistance=9999;
	for (int i=0; i<nSegments; i++) {
		segmentX=[[[[segmentsArr objectAtIndex:i] objectForKey:@"x"] objectForKey:@"text"] intValue];	
		segmentX=lroundf(segmentX*realImageSize.width/xmlImageSize.width+0.5);
		segmentY=[[[[segmentsArr objectAtIndex:i] objectForKey:@"y"] objectForKey:@"text"] intValue];	
		segmentY=lroundf(segmentY*realImageSize.width/xmlImageSize.width+0.5);
		segmentW=[[[[segmentsArr objectAtIndex:i] objectForKey:@"w"] objectForKey:@"text"] intValue];	
		segmentW=lroundf(segmentW*realImageSize.width/xmlImageSize.width+0.5);
		segmentH=[[[[segmentsArr objectAtIndex:i] objectForKey:@"h"] objectForKey:@"text"] intValue];	
		segmentH=lroundf(segmentH*realImageSize.width/xmlImageSize.width+0.5);
		NSLog(@"Get SegmentId (%d) Touched: XYWH=%d,%d,%d,%d",i,segmentX,segmentY,segmentW,segmentH); 
		
		if ((segmentX<imageTouchX)&&(segmentX+segmentW>imageTouchX)&&(segmentY<imageTouchY)&&(segmentY+segmentH>imageTouchY)) {
			return i;
			selectedSegmentX=segmentX;
			selectedSegmentY=segmentY;
			selectedSegmentW=segmentW;
			selectedSegmentH=segmentH;			
		} else {
			int distance,distanceX,distanceY;
			if (imageTouchX<segmentX) distanceX=segmentX-imageTouchX;
			else if (imageTouchX>(segmentX+segmentW)) distanceX=imageTouchX-(segmentX+segmentW);
			else distanceX=0;
			
			if (imageTouchY<segmentY) distanceY=segmentY-imageTouchY;
			else if (imageTouchY>(segmentY+segmentH)) distanceY=imageTouchY-(segmentY+segmentH);
			else distanceY=0;
			
			distance=floor(sqrt(pow(distanceX,2)+pow(distanceY,2))+0.5);
			
			NSLog(@"Distance = %d,%d,%d",distanceX,distanceY,distance);
			if (distance<nearestDistance) {
				NSLog(@"DISTANCE (%d) < NEAREST ONE (%d) -- segmentId=%d",distance,nearestDistance,i);
				nearestSegmentId=i;
				nearestDistance=distance;
				selectedSegmentX=segmentX;
				selectedSegmentY=segmentY;
				selectedSegmentW=segmentW;
				selectedSegmentH=segmentH;
			}
		}				
	}		
	NSLog(@"RETURN SEGMENT ID = %d",nearestSegmentId);
	return nearestSegmentId;	
}

-(void)drawSegmentWithX:(int)x Y:(int)y W:(int)w H:(int)h{	
	// sample image: w:452-h:640
	// Params are in image dimension --> need to change to scrollView dimension
	x=x*self.zoomScale+shiftX;
	y=y*self.zoomScale+shiftY;
	w=w*self.zoomScale;
	h=h*self.zoomScale;
	
	int edgeThickness=2;
	e1=[[RedEdge alloc] initWithRect:CGRectMake(x-edgeThickness,y-edgeThickness,edgeThickness,h+2*edgeThickness)];
	e2=[[RedEdge alloc] initWithRect:CGRectMake(x-edgeThickness,y-edgeThickness,w+2*edgeThickness,edgeThickness)];
	e3=[[RedEdge alloc] initWithRect:CGRectMake(x+w,y-edgeThickness,edgeThickness,h+2*edgeThickness)];
	e4=[[RedEdge alloc] initWithRect:CGRectMake(x-edgeThickness,y+h,w+2*edgeThickness,edgeThickness)];
	[self addSubview:e1];
	[self addSubview:e2];
	[self addSubview:e3];
	[self addSubview:e4];	
}
-(void)removeTouchRectangle{
	[e1 removeFromSuperview];
	[e2 removeFromSuperview];
	[e3 removeFromSuperview];
	[e4 removeFromSuperview];
}


-(void)touchAt:(CGPoint)touchPoint{	
	int edgeLength=80;
	int edgeThickness=2;
	e1=[[RedEdge alloc] initWithRect:CGRectMake(touchPoint.x-edgeLength/2-edgeThickness, touchPoint.y-edgeLength/2-edgeThickness, edgeThickness, edgeLength+2*edgeThickness)];
	e2=[[RedEdge alloc] initWithRect:CGRectMake(touchPoint.x-edgeLength/2-edgeThickness, touchPoint.y-edgeLength/2-edgeThickness, edgeLength+2*edgeThickness,edgeThickness)];
	e3=[[RedEdge alloc] initWithRect:CGRectMake(touchPoint.x+edgeLength/2, touchPoint.y-edgeLength/2-edgeThickness, edgeThickness, edgeLength+2*edgeThickness)];
	e4=[[RedEdge alloc] initWithRect:CGRectMake(touchPoint.x-edgeLength/2-edgeThickness, touchPoint.y+edgeLength/2, edgeLength+2*edgeThickness,edgeThickness)];
	[self addSubview:e1];
	[self addSubview:e2];
	[self addSubview:e3];
	[self addSubview:e4];
}

- (void)dealloc {
    [super dealloc];
}


@end
