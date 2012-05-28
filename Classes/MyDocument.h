#import <Foundation/Foundation.h>

@interface MyDocument : NSObject {
	NSString *dId,*orderId,*typeName,*typeId;
	NSMutableArray *arrIndex; 
	int pageCount;	
}

@property (retain) NSString *dId,*orderId,*typeName,*typeId;
@property (retain) NSMutableArray *arrIndex;
@property int pageCount;

@end
