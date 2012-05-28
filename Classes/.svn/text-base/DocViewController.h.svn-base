#import <UIKit/UIKit.h>
#import "MyScrollView.h"
#import "AbstractViewController.h"
#import "MandantCollection.pb.h"
#import "Connector.h"
#import "MyProcess.h"
#import "MyDocument.h"
#import "MyIndex.h"
#import "RedEdge.h"
#import "PageSegmentation.pb.h"
#import "TableIndexViewController.h"

@interface DocViewController : AbstractViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
	//INTERFACE
	UIView *vPageDetail,*vIndex,*vSelectIndex,*vOCR,*vBlack,*vBlack2; //vBlack is view in specific view (Select Index / OCR)
	UIImage *image;
	UIButton *btIndex;
	UIPickerView *pickerView;
	UITextField *tfOcr;
	UITableView *tbvIndex;
	
	//DATA		
	TableIndexViewController *tableIndexViewController;
	NSString *testDocId,*testMandant,*domain;
	NSMutableString *sOcr;
	BOOL canSwipe,alreadyInitOnce,alreadyInitWithPredefinedDoc;
	UISwipeGestureRecognizer *recognizer;
	Page *page; //PBF of Przemek (in PageSegmentation.pb class)
	MyProcess *process;
	MyDocument *doc;
	BOOL showIndex;
	NSTimer *timer;
	int currentPage, nPages, selectedSegmentId,scrollViewOffsetX,scrollViewOffsetY;
	NSMutableDictionary *dictThumbnail,*dictIndexList;
	MyIndex *selectedIndex;
	NSDictionary *imageDict;
	NSMutableArray *arrPickerValue,*dbIndexList,*allIndexList,*arrChangedIndexId;
	
	//TEST
	//double mLastScale,mCurrentScale;
	
	//SCROLL VIEW
	UIScrollView *scrollView;
	UIImageView *imageView;
	RedEdge *e1,*e2,*e3,*e4;
	int imageTouchX,imageTouchY,nSegments;
	int shiftX,shiftY; // because ImageView is already centered
	NSMutableArray *segmentsArr;
	CGSize realImageSize,xmlImageSize;
	int segmentX,segmentY,segmentW,segmentH;
	int selectedSegmentX,selectedSegmentY,selectedSegmentW,selectedSegmentH;
}
@property (nonatomic, retain) UIScrollView *scrollView;
-(void)showAll;
-(id)initWithProcess:(MyProcess *)processPar docPosition:(int)docPositionPar showIndex:(BOOL)showIndexPar;
-(void)initScrollView;
-(void)initOcrView;
-(void)initViewIndex;
-(void)removeTouchRectangle;
-(void)startTimer;
-(void)hidePageDetail;
-(void)initViewPageDetail;
-(void)btOcrDoneClicked;
-(void)btOcrEditClicked;
-(void)btOcrCancelClicked;


@end
