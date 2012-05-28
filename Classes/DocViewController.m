#import "DocViewController.h"
#import "RssReader.h"
#import "DocViewController.h"
#import "XMLReader.h"
#import "UIFactory.h"
#import "MyIndex.h"

#define LOCAL_TEST_MODE TRUE 

@implementation DocViewController
@synthesize scrollView;
static int x1=45,x2=15; //to draw page thumbnail
static int imageSpaceWidth=320,imageSpaceHeight=416;
static int pickerHeight=162;

static float unknownOffset1=0.005; // for drawing segment more accurately
static float unknownOffset3=1; // for drawing segment more accurately
static int unknownOffset2=1;

-(id)initWithProcess:(MyProcess *)processPar docPosition:(int)docPositionPar showIndex:(BOOL)showIndexPar mandantId:(NSString*)mandantIdPar{	
	self=[super init];
	if (self) {				
		process=processPar; 
		doc=[process.arrDoc objectAtIndex:docPositionPar];
		selectedMandantId=mandantIdPar;
		NSLog(@"*** INIT DocViewController: mandantId = %@, docId = %@",mandantIdPar,doc.dId);
		
		//self.title = [NSString stringWithFormat:@"[%@] %@",process.name,doc.name];
		UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
        tlabel.text=[NSString stringWithFormat:@"[%@] %@",process.typeId,doc.typeId];
		tlabel.textColor=[UIColor whiteColor];
		tlabel.backgroundColor =[UIColor clearColor];
		tlabel.adjustsFontSizeToFitWidth=YES;
		self.navigationItem.titleView=tlabel;
		
		currentPage=1;
		showIndex=showIndexPar;		
		canSwipe=TRUE;
		alreadyInitOnce=FALSE;
		alreadyInitWithPredefinedDoc=FALSE;
		arrChangedIndexId=[[NSMutableArray alloc] init];
	}
	return self;	
}

-(id)initOnce{
	[self checkDB];		
	alreadyInitOnce=TRUE;
}
-(id)initWithAPredefinedDoc{ //only re-init if doc is changed
	nPages=doc.pageCount;
	
	// ~~~~~~~~~~~~~~~~~~~~~~ GET AVAILABLE INDEX LIST (ALL INDEX LIST)~~~~~~~~~~~~~~~~
	//NSMutableArray *arrAllIndexes=[Connector getAllPossibleIndexesForDocTypeId:doc.typeId]; // DUPLICATED INDEX CLASS (BY PBF COMPILER)
	NSMutableArray *arrAllIndexes=doc.arrIndex;
	
	
	// ~~~~~~~~~~~~~~~~~~~~~~ GET DB INDEX LIST ~~~~~~~~~~~~~~~~	
	//dbIndexList=[Connector getDbIndexListOfDoc:doc]; // For changing after btIndexClicked;
	//NSLog(@"TEST dbIndexList: %@=%@",[[dbIndexList objectAtIndex:0] id],[[dbIndexList objectAtIndex:0] value]);
	
	alreadyInitWithPredefinedDoc=TRUE;
}
- (void)viewDidLoad {
    [super viewDidLoad];	
	//selectedIndex=[[NSMutableDictionary alloc] init];
	
	
	if (!alreadyInitOnce) [self initOnce];
	if (!alreadyInitWithPredefinedDoc) [self initWithAPredefinedDoc];		
	
	
	// ~~~~~~~~~~~~~~~~~~~~~~ GET IMAGE AND SEGMENTATION DATA ~~~~~~~~~~~~~~~~
	testDocId=@"201002111144387230008363CA7B56A18ED55B31EE05017B5FA690000000023198d7d77";
	testDocId=@"20100629154625261000817AE59111D22744D07CC9EB55708AE4B0000000028a6ba6f1a";
	domain=@"http://application.oxseed5:8080";
	domain=@"http://application1.oxseed6:8080";
	domain=@"https://ox6a.oxseed.net";
	testMandant=@"condor";	
	int testPageNumber=0;
	
	NSData *pageSegmentationData;
	if (LOCAL_TEST_MODE) {
		image=[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"ocr-archive.png"]];	
		pageSegmentationData=[[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"segment.pbf"]];
	} else {
		NSString* imageURL = [NSString stringWithFormat:@"%@/services/ocr-archive?action=show_image&document_id=%@&mandant=%@&image_output_format=png_gray&max_width=%d&max_height=%d&page_nr=%d",domain,testDocId,testMandant,imageSpaceWidth,imageSpaceHeight,testPageNumber];
		NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
		image=[UIImage imageWithData:imageData];		
		
		NSString *segmentURL=[NSString stringWithFormat:@"%@/services/ocr-archive?action=show_segmentation&page_nr=0&document_id=%@&mandant=condor&max_width=320&max_height=416&response_format=protocol_buffer",domain,testDocId];
		NSLog(@"Segment URL=%@",segmentURL);
		pageSegmentationData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:segmentURL]];	
	}				
	
	//NSLog(@"Image w/h=%f/%f",image.size.width,image.size.height);		  		
	page=[Page parseFromData:pageSegmentationData];
	segmentsArr=[[NSMutableArray alloc] init];
								
	
	// SCROLL VIEW
	[self initScrollView];	

	// IF nPAGES<=5; GET DICT OF THUMBNAIL IMAGEs	
	dictThumbnail=[[NSMutableDictionary alloc] init];
	for (int i=1; i<=nPages; i++) {				
		[dictThumbnail setObject:image forKey:[NSString stringWithFormat:@"ThumbnailOfPage%d",i]];
	}		

	// INDEX BUTTON
	btIndex=[UIButton buttonWithType:UIButtonTypeCustom];
	[btIndex setImage:[UIImage imageNamed:@"indexButton.png"] forState:UIControlStateNormal];
	btIndex.frame=CGRectMake(290, 5, 24, 27);
	[btIndex addTarget:self action:@selector(btIndexClicked) forControlEvents:UIControlEventTouchDown];
	
	[self initViewIndex];
	
	// SELECT INDEX (SI) VIEW
	[self initSelectIndexView];
	
	//  ~~~~ GESTURE FOR SCROLL VIEW <-- delegate:self
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightMethod)];
	// w/ DEFAULT = UISwipeGestureRecognizerDirectionRight;
	[scrollView addGestureRecognizer:recognizer];
	recognizer.delegate = self;	
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftMethod)];
	recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[scrollView addGestureRecognizer:recognizer];
	recognizer.delegate = self;
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpMethod)];
	recognizer.direction = UISwipeGestureRecognizerDirectionUp;
	[scrollView addGestureRecognizer:recognizer];
	recognizer.delegate = self;
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownMethod)];
	recognizer.direction = UISwipeGestureRecognizerDirectionDown;
	[scrollView addGestureRecognizer:recognizer];
	recognizer.delegate = self;	
	[recognizer release];			

	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [scrollView addGestureRecognizer:singleTap];
	[singleTap release];
	
	[self showAll];
	canSwipe=TRUE;
}

// ==================================================================================================
#								pragma mark SCROLL VIEW
// ==================================================================================================
-(void)initScrollView{
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, imageSpaceWidth, imageSpaceHeight)];
	scrollView.backgroundColor=[UIColor greenColor];
	// CALCULATE CENTER FRAME FOR IMAGE
	float w=image.size.width;
	float h=image.size.height;
	CGRect imageFrame;
	if ((w/imageSpaceWidth)>(h/imageSpaceHeight)) {
		//NSLog(@"Truong hop RONG: (w/h)=(%f/%f)",w,h);
		h=imageSpaceWidth*h/w;
		w=imageSpaceWidth;		
		imageFrame=CGRectMake(0, (imageSpaceHeight-h)/2, w, h);
	} else {
		//NSLog(@"Truong hop DAI: (w/h)=(%f/%f)",w,h);
		w=imageSpaceHeight*w/h;
		h=imageSpaceHeight;
		imageFrame=CGRectMake((imageSpaceWidth-w)/2, 0, w, h);
	}	
	imageView = [[[UIImageView alloc] initWithImage:image] retain];	
	imageView.frame=imageFrame;	
	[scrollView addSubview:imageView];			

	[scrollView setScrollEnabled:YES];
	scrollView.autoresizesSubviews = NO;
	scrollView.backgroundColor=[UIColor blackColor];	
	realImageSize=CGSizeMake(imageFrame.size.width, imageFrame.size.height);	
	shiftX=imageFrame.origin.x;
	shiftY=imageFrame.origin.y;
	[scrollView setContentSize:realImageSize];
	scrollView.maximumZoomScale = 5.0;
	scrollView.minimumZoomScale = 1;
	scrollView.clipsToBounds = YES;	
	segmentsArr=[[page mutableSegmentList] copy]; 
	NSLog(@"First segment x=%f",[[segmentsArr objectAtIndex:0] x]);
	nSegments=[segmentsArr count];	
	NSLog(@"nSegments=%d",nSegments);
	
	xmlImageSize=CGSizeMake([page imageWidth], [page imageHeight]);
	scrollView.delegate = self;	
	
	scrollViewOffsetX=0;
	scrollViewOffsetY=0;
}
-(int)getSegmentIdTouched{	
	NSLog(@"Start getSegmentIdTouched");
	int nearestSegmentId=-1;
	int nearestDistance=40;
	for (int i=0; i<nSegments; i++) {
		Page_Segment *ps=[segmentsArr objectAtIndex:i];		
		//NSLog(@"FLOAT=%f",[[segmentsArr objectAtIndex:0] x]);
		segmentX=(int)ps.x;
		//NSLog(@"INT=%d",segmentX);
		segmentX=lroundf(segmentX*realImageSize.width/xmlImageSize.width+0.5);
		segmentY=(int)ps.y;
		segmentY=lroundf(segmentY*realImageSize.width/xmlImageSize.width+0.5);
		segmentW=(int)ps.w;
		segmentW=lroundf(segmentW*realImageSize.width/xmlImageSize.width+0.5);
		segmentH=(int)ps.h;
		segmentH=lroundf(segmentH*realImageSize.width/xmlImageSize.width+0.5);
		NSLog(@"Loop segment %d = %d,%d,%d,%d",i,segmentX,segmentY,segmentW,segmentH);
		if ((segmentX<imageTouchX)&&(segmentX+segmentW>imageTouchX)&&(segmentY<imageTouchY)&&(segmentY+segmentH>imageTouchY)) {
			selectedSegmentX=segmentX;
			selectedSegmentY=segmentY;
			selectedSegmentW=segmentW;
			selectedSegmentH=segmentH;
			NSLog(@"---> SELECT SEGMENT %d",i);
			return i;			
		} else {
			int distance,distanceX,distanceY;
			if (imageTouchX<segmentX) distanceX=segmentX-imageTouchX;
			else if (imageTouchX>(segmentX+segmentW)) distanceX=imageTouchX-(segmentX+segmentW);
			else distanceX=0;
			
			if (imageTouchY<segmentY) distanceY=segmentY-imageTouchY;
			else if (imageTouchY>(segmentY+segmentH)) distanceY=imageTouchY-(segmentY+segmentH);
			else distanceY=0;
			
			distance=floor(sqrt(pow(distanceX,2)+pow(distanceY,2))+0.5);
			if (distance<nearestDistance) {
				//NSLog(@"DISTANCE (%d) < NEAREST ONE (%d) -- segmentId=%d",distance,nearestDistance,i);
				nearestSegmentId=i;
				nearestDistance=distance;
				selectedSegmentX=segmentX;
				selectedSegmentY=segmentY;
				selectedSegmentW=segmentW;
				selectedSegmentH=segmentH;
				NSLog(@"---> SELECT NEAREST SEGMENT %d",i);
			}
		}				
	}			
	return nearestSegmentId;	
}
-(void)drawSegmentWithX:(int)x Y:(int)y W:(int)w H:(int)h{	
	NSLog(@"DrawSegment: INPUT= (%d,%d,%d,%d)",x,y,w,h);
	NSLog(@"zoomscale=%f",scrollView.zoomScale);
		
	x=(x+unknownOffset3)*(scrollView.zoomScale+unknownOffset1)+shiftX+unknownOffset2-scrollViewOffsetX;
	y=(y+unknownOffset3)*(scrollView.zoomScale+unknownOffset1)+shiftY+unknownOffset2-scrollViewOffsetY;
	w=w*scrollView.zoomScale;
	h=h*scrollView.zoomScale;	
	NSLog(@"DrawSegment: OUTPUT= (%d,%d,%d,%d)",x,y,w,h);
	int edgeThickness=2;
	e1=[[RedEdge alloc] initWithRect:CGRectMake(x-edgeThickness,y-edgeThickness,edgeThickness,h+2*edgeThickness)];
	e2=[[RedEdge alloc] initWithRect:CGRectMake(x-edgeThickness,y-edgeThickness,w+2*edgeThickness,edgeThickness)];
	e3=[[RedEdge alloc] initWithRect:CGRectMake(x+w,y-edgeThickness,edgeThickness,h+2*edgeThickness)];
	e4=[[RedEdge alloc] initWithRect:CGRectMake(x-edgeThickness,y+h,w+2*edgeThickness,edgeThickness)];
	[self.view addSubview:e1];
	[self.view addSubview:e2];
	[self.view addSubview:e3];
	[self.view addSubview:e4];	
}
-(void)removeTouchRectangle{
	[e1 removeFromSuperview];
	[e2 removeFromSuperview];
	[e3 removeFromSuperview];
	[e4 removeFromSuperview];
}

// ==================================================================================================
#								pragma mark SCROLL VIEW DELEGATE
// ==================================================================================================
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)inScroll { //run this when access "scrollView.zoomScale"
	return imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	[self removeTouchRectangle];
}	
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	NSLog(@"***** ScrollView Did Scroll");
	[self removeTouchRectangle];
	NSLog(@"Content Offset = (%f,%f)",scrollView.contentOffset.x,scrollView.contentOffset.y);
	scrollViewOffsetX=(int)scrollView.contentOffset.x;
	scrollViewOffsetY=(int)scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	NSLog(@"***** ScrollView DidEndDecelerating");
}

// ==================================================================================================
#								pragma mark HANDLER
// ==================================================================================================
-(void)btIndexClicked{
	if (showIndex) showIndex=FALSE;
	else showIndex=TRUE;
	[self showAll];
	//[vIndex removeFromSuperview];
}
-(void) btBackClicked{
	canSwipe=FALSE;
	currentPage--;
	if (currentPage==0) {
		currentPage=nPages;
	}
	[self viewDidUnload];
	[self viewDidLoad];
	[self startTimer];
}
-(void) btNextClicked{
	canSwipe=FALSE;
	NSLog(@"btNextClicked");
	currentPage++;
	if (currentPage>nPages) {
		currentPage=1;
	}
	NSLog(@"so, current page=%d",currentPage);
	[self viewDidUnload];
	[self viewDidLoad];
	[self startTimer];
}
-(void)btSiSelectClicked{
	if (disableBackgroundView) return;		
	disableBackgroundView=TRUE;
	[self loading];
	
	//~~~ GET OCR VALUE ~~~
	NSString *ocrURL=[NSString stringWithFormat:@"%@/services/ocr-archive?action=show_ocr&page_nr=0&document_id=%@&mandant=condor&max_width=320&max_height=416&response_format=protocol_buffer&segment_indexes=%d&ocr_mode=m",domain,testDocId,selectedSegmentId];
	NSLog(@"ocrURL = %@",ocrURL);
	[self performSelectorInBackground:@selector(btSiSelectClicked_BG:) withObject:ocrURL];
}
-(void)btSiSelectClicked_BG:(NSString*)ocrURL{	
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	NSData *ocrData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:ocrURL]];	
	if (ocrData!=NULL) {
		NSLog(@"Done: Init ocrData");
		Page *tmpPage=[Page parseFromData:ocrData];
		NSLog(@"TEST PAGE ID = %d",tmpPage.pageId);		  
		Page_Segment *tmpSegment=[[tmpPage mutableSegmentList] objectAtIndex:0];
		NSLog(@"TEST SEGMENT W,H= %f,%f",tmpSegment.w,tmpSegment.h);
		Page_Segment_Ocr *ocr=[[tmpSegment mutableOcrList] objectAtIndex:0];
		//NSLog(@"TEST OCR = %@,%@,%@",ocr.classifierId,ocr.ocrString,ocr.score);
		if (ocr!=NULL) {
			sOcr=[ocr.ocrString copy];
		} else {
			sOcr=@"Unknown";
		}
	} else {
		sOcr=@"Network Error";
	}

	NSLog(@"&&&&&&& OCR STRING = %@",sOcr);
	[self performSelectorOnMainThread:@selector(btSiSelectClicked_MT) withObject:nil waitUntilDone:FALSE];
}
-(void)btSiSelectClicked_MT{
	[vSelectIndex removeFromSuperview];		
	[self stopLoading];
	disableBackgroundView=FALSE;
	[self initOcrView];
	[self.view addSubview:vOCR];
}
/*
-(void)btSiEditClicked{
	[self btSiCancelClicked];
}
 */
-(void)btSiCancelClicked{
	NSLog(@"btSiCancelClicked");
	if (disableBackgroundView) return;		
	[vSelectIndex removeFromSuperview];
}
-(void)btOcrBackClicked{
	[vOCR removeFromSuperview];
	[self.view addSubview:vSelectIndex];
}
-(void)btOcrSaveClicked{	
	/*
	 NSLog(@"Saved: %@====%@",selectedIndex.id,tfOcr.text);	
	[arrChangedIndexId addObject:[selectedIndex.id copy]];
	NSLog(@"arrChangedIndexId count=%d // JUST ADDED INDEX ID = %@",[arrChangedIndexId count],selectedIndex.id);
	[Connector addIndexToDb:selectedIndex docId:doc.dId value:tfOcr.text segmentId:selectedSegmentId];	
	dbIndexList=[Connector getDbIndexListOfDoc:doc];
	
	[self btOcrCancelClicked];
	 */
}
-(void)btOcrCancelClicked{
	/*
	NSLog(@"btOcrCancelClicked");
	//[vSelectIndex removeFromSuperview];
	[vOCR removeFromSuperview];
	 */
}

// ==================================================================================================
#								pragma mark recognizer DELEGATE
// ==================================================================================================
-(void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {	
	NSLog(@"SINGLE TAP");
	
	CGPoint p=[gestureRecognizer locationInView:gestureRecognizer.view];	
	
	NSLog(@"TOUCH POINT ===== %f, %f",p.x,p.y);
	[self removeTouchRectangle];
	imageTouchX=(p.x-shiftX)/(scrollView.zoomScale);
	imageTouchY=(p.y-shiftY)/(scrollView.zoomScale);
	NSLog(@"imageTouch=(%d,%d)",imageTouchX,imageTouchY);			
	selectedSegmentId=[self getSegmentIdTouched];
	
	if (selectedSegmentId!=-1){		
		[self drawSegmentWithX:selectedSegmentX Y:selectedSegmentY W:selectedSegmentW H:selectedSegmentH];
		
		// IF THERE IS NOTHING IN PICKER VIEW, THEN DON'T SHOW IT
		if ([allIndexList count]==[arrChangedIndexId count]) return;
		
		CGPoint p2=[gestureRecognizer locationInView:self.view]; //get the point coordinate based on device (self.view)
		if (p2.y>200) pickerView.frame=CGRectMake(0,0,320,pickerHeight);
			else pickerView.frame=CGRectMake(0,235,320,pickerHeight);				 
						
		[pickerView reloadComponent:0];
		[pickerView selectRow:[self getInitRowOfPicker] inComponent:0 animated:YES];
		[self.view addSubview:vSelectIndex];
	}
}
-(void)swipeRightMethod{
	if (!canSwipe) return;
	NSLog(@"Right");
	[self btNextClicked];
}
-(void)swipeLeftMethod{
	if (!canSwipe) return;
	NSLog(@"Left");
	[self btBackClicked];	
}
-(void)swipeUpMethod{
	if (!canSwipe) return;
	NSLog(@"====   Up   ====");
	/*
	for (MandantDefinition_WorkBasket *aWB in [Connector wbList]) {
		for (MandantDefinition_Process *aP in [aWB mutableArrProsList]) {
			int nDocs=[[aP mutableArrDocsList] count];
			for (int i=0;i<nDocs;i++){ 
				NSLog(@"UP i = %d",i);
				MandantDefinition_Document *aDoc=[[aP mutableArrDocsList] objectAtIndex:i];
				if ([[aDoc docId] isEqualToString:[doc docId]]) {					
					if (i==0) return;
					else {
						doc=aDoc;
						currentPage=1;
						[self viewDidUnload];
						[self viewDidLoad];
						[self startTimer];
						return;
					}					
				}
			}
		}
	}
	*/
}
-(void)swipeDownMethod{
	if (!canSwipe) return;
	NSLog(@"Down");
}

// ==================================================================================================
#								pragma mark UITextField delegate
// ==================================================================================================
-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {	
	[theTextField resignFirstResponder];
	vBlack2.frame=CGRectMake(0, 290, 320, 85);
} 
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	NSLog(@"START EDIT tfOcr");
	vBlack2.frame=CGRectMake(0, 120, 320, 85);
}

// ==================================================================================================
#									pragma mark SUPPORT
// ==================================================================================================
-(void)showAll{		
	// ~~~~~~~~~~~~~~~~~~~~~~ GET DB INDEX LIST ~~~~~~~~~~~~~~~~	
	//dbIndexList=[Connector getDbIndexListOfDoc:doc]; // For changing after btIndexClicked;
	//NSLog(@"TEST dbIndexList: %@=%@",[[dbIndexList objectAtIndex:0] id],[[dbIndexList objectAtIndex:0] value]);

	if ([scrollView superview]==nil)
		[self.view addSubview:scrollView];		
	if (showIndex){
		[self.view addSubview:vIndex];						
		NSLog(@"((((( RELOAD DATA ))))))");		
		tableIndexViewController.dbIndexList=dbIndexList;
		[tbvIndex reloadData];
	} else {
		[vPageDetail removeFromSuperview];
		[vPageDetail release];
		[self initViewPageDetail];
		[self startTimer];
		[self.view addSubview:vPageDetail];		
		
		if ([vIndex superview]!=nil)
			[vIndex removeFromSuperview];		
	}	
	[self.view addSubview:btIndex];
	if ([scrollView superview]==nil)
		[scrollView becomeFirstResponder];
}
-(void)initOcrView{
	NSLog(@"****** initOcrView");
	// SEND TO WS REQUEST W/ PARAMS: SEGMENT ID, INDEX TYPE, [Machine OCR is default atm]
	//NSString *newValue=sOcr;
	vOCR=[UIFactory viewTransparentWithFrame:CGRectMake(0, 0, 320, 420)];	
	UIView *vLowOpacity=[UIFactory viewLowOpacityWithFrame:CGRectMake(0, 0, 320, 420)];	
	vBlack=[UIFactory viewBlackWithFrame:CGRectMake(0, 375, 320, 50)];	
	UIButton *btOcrBack=[UIFactory roundedRectButtonWithTitle:@"Back" frame:CGRectMake(10, 2, 80, 20)];
	[btOcrBack addTarget:self action:@selector(btOcrBackClicked) forControlEvents:UIControlEventTouchDown];
	UIButton *btOcrSave=[UIFactory roundedRectButtonWithTitle:@"Save" frame:CGRectMake(120, 2, 80, 20)];
	[btOcrSave addTarget:self action:@selector(btOcrSaveClicked) forControlEvents:UIControlEventTouchDown];
	UIButton *btOcrCancel=[UIFactory roundedRectButtonWithTitle:@"Cancel" frame:CGRectMake(230, 2, 80, 20)];
	[btOcrCancel addTarget:self action:@selector(btOcrCancelClicked) forControlEvents:UIControlEventTouchDown];
	[vBlack addSubview:btOcrBack];
	[vBlack addSubview:btOcrSave];
	[vBlack addSubview:btOcrCancel];
	vBlack2=[UIFactory viewBlackWithFrame:CGRectMake(0, 300, 320, 75)];
	UILabel *lb=[UIFactory labelWithTitle:@"Set Value: " frame:CGRectMake(85, 2, 75, 22)];	
	//NSLog(@"TEST TEST %@",[[selectedIndex objectForKey:@"name"] objectForKey:@"text"]);
	UILabel *lb2=[UIFactory labelRedBoldWithTitle:selectedIndex.name frame:CGRectMake(165, 2, 120, 22)];
	lb2.textAlignment=UITextAlignmentLeft;		
	UIView *vWhite=[UIFactory textViewWhiteRoundCornerWithFrame:CGRectMake(60, 27, 200, 23)];
	tfOcr=[UIFactory textFieldCenteredWithFrame:CGRectMake(5, 2, 190, 20)];
	tfOcr.returnKeyType=UIReturnKeyDone;
	[tfOcr setDelegate:self];
	//tfOcr.text=newValue;
	tfOcr.text=sOcr;	
	
	[vWhite addSubview:tfOcr];
	[vBlack2 addSubview:lb];
	[vBlack2 addSubview:lb2];
	[vBlack2 addSubview:vWhite];
	
	[vOCR addSubview:vLowOpacity];
	[vOCR addSubview:vBlack];
	[vOCR addSubview:vBlack2];
}
-(void)initSelectIndexView{
	//SI/Si = ABBR. of Select Index
	disableBackgroundView=FALSE;	
	vSelectIndex=[UIFactory viewTransparentWithFrame:CGRectMake(0, 0, 320, 420)];	
	pickerView=[[UIPickerView alloc] init];
	pickerView.showsSelectionIndicator = YES;
	pickerView.opaque=YES;
	//pickerView.frame=CGRectMake(0, 225, 320,150);		
	[pickerView setDataSource:self];
	[pickerView setDelegate:self];				
	
	UIView *vLowOpacity=[UIFactory viewLowOpacityWithFrame:CGRectMake(0, 0, 320, 420)];	
	vBlack=[UIFactory viewBlackWithFrame:CGRectMake(0, 395, 320, 30)];
	UILabel *lb=[UIFactory labelWithTitle:@"SELECT INDEX" frame:CGRectMake(100, 2, 120, 20)];	
	UIButton *btSiSelect=[UIFactory roundedRectButtonWithTitle:@"Select" frame:CGRectMake(10, 2, 80, 20)];
	[btSiSelect addTarget:self action:@selector(btSiSelectClicked) forControlEvents:UIControlEventTouchDown];
	//UIButton *btSiEdit=[UIFactory roundedRectButtonWithTitle:@"Edit" frame:CGRectMake(120, 2, 80, 25)];
	//[btSiEdit addTarget:self action:@selector(btSiEditClicked) forControlEvents:UIControlEventTouchDown];
	UIButton *btSiCancel=[UIFactory roundedRectButtonWithTitle:@"Cancel" frame:CGRectMake(230, 2, 80, 20)];
	[btSiCancel addTarget:self action:@selector(btSiCancelClicked) forControlEvents:UIControlEventTouchDown];
	[vBlack addSubview:btSiSelect];
	[vBlack addSubview:btSiCancel];
	[vBlack addSubview:lb];
	[vSelectIndex addSubview:vLowOpacity];
	[vSelectIndex addSubview:vBlack];
	[vSelectIndex addSubview:pickerView];	
}
-(void)initViewIndex{
	vIndex=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
	vIndex.backgroundColor=[UIColor blackColor];
	
	tbvIndex=[UIFactory roundedTableViewWithFrame:CGRectMake(10,25, 300, 300)];
	[vIndex addSubview:tbvIndex];
	
	NSLog(@"SELECTED MANDANT ID ********************* %@",selectedMandantId);
	tableIndexViewController=[[TableIndexViewController alloc] initWithDoc:doc process:process allIndexList:allIndexList dbIndexList:dbIndexList mandantId:selectedMandantId];
	[tbvIndex setDataSource:tableIndexViewController];
	[tbvIndex setDelegate:tableIndexViewController];
	
	
	// Page view section
	float firstX;
	int borderWidth=5;
	//nPages=6;
	if (nPages<=5) {
		firstX=160-((double)nPages/2)*x1-(nPages-1)/2*x2;		
		for (int i=1;i<=nPages; i++) {									
			if (i==currentPage) {
				UIView *orangeView=[UIFactory borderedOrangeViewWithFrame:CGRectMake(firstX+(i-1)*(x1+x2)-borderWidth, 350-borderWidth, x1+2*borderWidth, x1+2*borderWidth)];
				[vIndex addSubview:orangeView];
			}
			
			UIButton *bt=[UIFactory buttonWithImage:[dictThumbnail objectForKey:[NSString stringWithFormat:@"ThumbnailOfPage%d",i]] frame:CGRectMake(firstX+(i-1)*(x1+x2), 350, x1, x1)];
			bt.tag=i;
			[bt addTarget:self action:@selector(btThumbClicked:) forControlEvents:UIControlEventTouchDown];
			[vIndex addSubview:bt];			
		}
	} else {
		UILabel *lb=[UIFactory boldLabelWithTitle:[NSString stringWithFormat:@"Page %d / %d",currentPage,nPages] frame:CGRectMake(110, 360, 100, 40)];
		[vIndex addSubview:lb];
	}
	
}
-(void)btThumbClicked:(UIButton*)sender{
	currentPage=sender.tag;
	showIndex=FALSE;
	[self viewDidUnload];
	[self viewDidLoad];
	[self startTimer];	
}

-(void)initViewPageDetail{
	vPageDetail=[[UIView alloc] init];
	vPageDetail.frame=CGRectMake(0, 365, 320, 45);
	vPageDetail.backgroundColor=[UIColor clearColor];
	vPageDetail.alpha=0.7;
	UILabel *lbPageDetail=[[UILabel alloc] init];
	lbPageDetail.frame=CGRectMake(0, 10, 320, 30);
	lbPageDetail.backgroundColor=[UIColor orangeColor];
	lbPageDetail.textColor=[UIColor blackColor];
	lbPageDetail.text=[NSString stringWithFormat:@"Page %d/%d",currentPage,nPages];
	lbPageDetail.textAlignment=UITextAlignmentCenter;
	lbPageDetail.font=[UIFont boldSystemFontOfSize:18];
	[vPageDetail addSubview:lbPageDetail];	
}

-(void)startTimer{
	timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hidePageDetail) userInfo:nil repeats:NO];
}
-(void)hidePageDetail{
	NSLog(@"HIDE PAGEDETAIL");		
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:2.5];
	vPageDetail.alpha = 0;
	[UIView commitAnimations];
}

-(void)viewDidAppear:(BOOL)animated{
	[self startTimer];
	[self.navigationController setToolbarHidden:YES];	
}
-(void)viewWillDisappear:(BOOL)animated{
	[self.navigationController setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[scrollView removeFromSuperview];
	//[focusRectangle removeFromSuperview];
}
- (void)dealloc {
    [super dealloc];
}


@end
