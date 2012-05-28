#import <Foundation/Foundation.h>

@interface WorkBasket : NSObject {
	NSString *id,*type,*name,*description,*lastBuildDate,*inMandantId;
	NSMutableArray *arrProcess;
	int inGroupId;
}

@property (retain) NSString *id,*name,*type,*description,*lastBuildDate,*inMandantId;
@property int inGroupId;
@property (retain) NSMutableArray *arrProcess;

@end

