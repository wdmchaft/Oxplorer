#import "MyMandant.h"

@implementation MyMandant
@synthesize id,name,description,isAdded,arrWb;

-(id)initWithId:(NSString*)idPar name:(NSString*)namePar{
	self=[super init];
	if (self) {		
		self.name=namePar;
		self.id=idPar;
		self.isAdded=FALSE;
		self.arrWb=[[NSMutableArray alloc] init];
	}
	return self;
}

@end
