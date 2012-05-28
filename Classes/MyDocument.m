#import "MyDocument.h"

@implementation MyDocument
@synthesize dId,orderId,typeName,arrIndex,pageCount,typeId;

-(id)initWithId:(NSString*)dIdPar typeId:(NSString*)typeIdPar{
	self=[super init];
	if (self) {				
		self.dId=dIdPar;	
		self.typeId=typeIdPar;
	}
	return self;
}
-(id)initWithId:(NSString*)dIdPar typeId:(NSString*)typeIdPar pageCount:(int)pageCountPar arrIndex:(NSMutableArray*)arrIndexPar{
	self=[super init];
	if (self) {				
		self.dId=dIdPar;	
		self.typeId=typeIdPar;
		self.pageCount=pageCountPar;
		self.arrIndex=arrIndexPar;
	}
	return self;
}


@end
