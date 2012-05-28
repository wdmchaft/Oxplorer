#import "ThatkoLib.h"


@implementation ThatkoLib
+(UIColor *)colorForCode:(int)code{
	switch (code) {
		case 1: return [UIColor blackColor];
		case 2: return [UIColor whiteColor];
		case 3: return [UIColor redColor];
		case 4: return [UIColor yellowColor];
		case 5: return [UIColor orangeColor];
		case 6: return [UIColor blueColor];
		case 7: return [UIColor greenColor];
	}
}
+(NSString *)colorTextForCode:(int)code{
	switch (code) {
		case 1: return @"Black";
		case 2: return @"White";
		case 3: return @"Red";
		case 4: return @"Yellow";
		case 5: return @"Orange";
		case 6: return @"Blue";
		case 7: return @"Green";
	}
}
+(NSString *)filterID:(NSString *)s{
	NSRange startRange = [s rangeOfString:@"\["];
	return [s substringWithRange:NSMakeRange(0, startRange.location)];
}
+(NSString *)filterName:(NSString *)s{
	int len=[s length];	
	NSString *lastChar=[s substringWithRange:NSMakeRange(len-1,1)];
	if (![lastChar isEqualToString:@"]"]) {
		s=[NSString stringWithFormat:@"%@]",s];
	}
	NSLog(@"S=%@ with length=%d and lastChar=%@",s,len,lastChar);
	
	NSRange startRange = [s rangeOfString:@"\["];
	NSRange endRange = [s rangeOfString:@"]"];		
	NSString *result=[s substringWithRange:NSMakeRange(startRange.location+1,endRange.location-startRange.location-1)];
	return result;
}

+(NSString *)removeDot:(NSString *)input{
	NSRange rangeOfDot=[input rangeOfString:@","];
	if (rangeOfDot.length==0) {
		return input;
	} else {
		NSString *p1,*p2; // part1, part2 
		p1=[input substringToIndex:rangeOfDot.location];
		p2=[input substringFromIndex:rangeOfDot.location+1];
		p2=[ThatkoLib removeDot:p2];
		NSString *result=[NSString stringWithFormat:@"%@%@",p1,p2];
		return result;		
	}
}
+(NSString *)formatCurrency:(NSString *)amount{
	NSLog(@"STARTING FORMAT: INPUT=%@",amount);
	
    double amountDouble;
    amountDouble=[amount doubleValue];
    NSLog(@"amountDouble=%f",amountDouble);
    
    if (amountDouble>=1000000000000) {
        amount=@"999999999999";
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumIntegerDigits:18];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setDecimalSeparator:@"."];
	
	NSString *result=[numberFormatter stringFromNumber:[NSNumber numberWithLongLong:[amount longLongValue]]];
	NSLog(@"RESULT = %@",result);
	return result;
}

@end
