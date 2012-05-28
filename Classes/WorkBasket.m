#import "WorkBasket.h"


@implementation WorkBasket
@synthesize id,name,type,inGroupId,description,lastBuildDate,arrProcess,inMandantId;

-(id)initWithId:(NSString*)idPar name:(NSString*)namePar type:(NSString*)typePar lastBuildDate:(NSString*)lastBuildDatePar{
	self=[super init];
	if (self) {		
		self.name=namePar;
		self.id=idPar;	
		self.type=typePar;
		self.lastBuildDate=lastBuildDatePar;
		self.arrProcess=[[NSMutableArray alloc] init];
		self.inGroupId=0;
	}
	return self;
}

@end
