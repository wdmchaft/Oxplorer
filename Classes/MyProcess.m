#import "MyProcess.h"

@implementation MyProcess
@synthesize pid,orderId,typeId,typeName,entryDate,resubmitDate,isRead,arrDoc;

-(id)initWithPId:(NSString*)pIdPar isRead:(BOOL)isReadPar typeId:(NSString*)typeIdPar{
	self=[super init];
	if (self) {		
		self.pid=pIdPar;					
		self.isRead=isReadPar;
		self.typeId=typeIdPar;
		//self.arrDoc=[[NSMutableArray alloc] init];
	}
	return self;
}
-(id)initWithPId:(NSString*)pIdPar orderId:(NSString*)orderIdPar typeId:(NSString*)typeIdPar entryDate:(NSString*)entryDatePar resubmitDate:(NSString*)resubmitDatePar arrDoc:(NSMutableArray*)arrDocPar{
	self=[super init];
	if (self) {		
		self.pid=pIdPar;					
		self.orderId=orderIdPar;
		self.typeId=typeIdPar;
		self.entryDate=entryDatePar;
		self.resubmitDate=resubmitDatePar;
		self.arrDoc=arrDocPar;		
	}
	return self;
}

@end
