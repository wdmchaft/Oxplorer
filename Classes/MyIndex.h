#import <Foundation/Foundation.h>

@interface MyIndex : NSObject {
	NSString *id,*docId,*name,*value;	
	int segmentId;
}
@property (retain) NSString *id,*docId,*name,*value;
@property int segmentId;

@end
