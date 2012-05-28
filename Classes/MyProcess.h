#import <Foundation/Foundation.h>

@interface MyProcess : NSObject {
	NSString *pid,*orderId,*typeId,*typeName,*entryDate,*resubmitDate;
	BOOL isRead;
	//int nDocs,position;
	NSMutableArray *arrDoc;
}

@property (retain) NSString *pid,*orderId,*typeId,*typeName,*entryDate,*resubmitDate;
@property BOOL isRead;
//@property int nDocs,position;
@property NSMutableArray *arrDoc;

@end
