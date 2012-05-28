//
//  RssReader.h
//  RSSReader
//
//  Created by thatko on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RssReader : NSObject{
	NSAutoreleasePool * pool;
	NSString *URL;
	NSXMLParser *xmlParser;
	
	NSMutableDictionary *channel,*itemDict;		
	int itemCount;
	NSString *currentContent;
	BOOL settingItem;
}

@end
