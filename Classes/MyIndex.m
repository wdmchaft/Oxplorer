#import "MyIndex.h"

@implementation MyIndex
@synthesize id,docId,name,value,segmentId;

// =============== CONSTRUCTORs ================ //
-(id)initWithId:(NSString*)idPar name:(NSString*)namePar{
	self=[super init];
	if (self) {		
		self.name=namePar;
		self.id=idPar;		
	}
	return self;	
}
-(id)initWithId:(NSString*)idPar name:(NSString*)namePar value:(NSString*)valuePar{
	self=[super init];
	if (self) {		
		self.name=namePar;
		self.id=idPar;	
		self.value=valuePar;
	}
	return self;	
}
-(id)initWithId:(NSString*)idPar docId:(NSString*)docIdPar name:(NSString*)namePar value:(NSString*)valuePar segmentId:(int)segmentIdPar{
	self=[super init];
	if (self) {		
		self.id=idPar;	
		self.name=namePar;
		self.docId=docIdPar;		
		self.value=valuePar;
		self.segmentId=segmentIdPar;
	}
	return self;	
}

@end
