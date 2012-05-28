#import "RssReader.h"

@implementation RssReader
-(id)initWithURL:(NSString *)url{
	[super init];
	URL=url;
	return self;
}
-(void)setURL:(NSString *)url{
	URL=url;
}
-(int)getNumberOfItem{
	return itemCount;
}
-(NSMutableDictionary *)fetch{	
    pool = [[NSAutoreleasePool alloc] init];
	channel=[[NSMutableDictionary alloc] init];	
	xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[self urlEncode:URL]]];	
	[self parse];
	return channel;
	[pool release];
}
-(void)parse{
	[xmlParser setDelegate:self];	
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];	
	[xmlParser parse];	
}

// =======================================================================================
#								pragma mark PARSING PROCESS 
// =======================================================================================
- (void)parserDidStartDocument:(NSXMLParser *)parser {	
	//NSLog(@"### Start Parsing");	
	settingItem=FALSE;
	itemCount=0;
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {	
	//NSLog(@"### Parse Error");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{	
	//NSLog(@"### Start Element: %@",elementName);
	//currentElement=elementName;
	if ([elementName isEqualToString:@"item"]) {
		itemDict=[[NSMutableDictionary alloc] init];
		settingItem=TRUE;
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//currentContent=[NSString stringWithFormat:@"%@%@",currentContent,[[string copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];	
	//currentContent=[[string copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];	
	//currentContent=string;
	if (currentContent==nil) {
		currentContent=[[string copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];			
	} else {
		currentContent=[[NSString stringWithFormat:@"%@ %@",currentContent,string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	//NSLog(@"### Found character: %@",currentContent);
	//	currentContent=[curContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];		
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	//NSLog(@"### End Element");
	if (!settingItem) {
		[channel setObject:currentContent forKey:elementName];		
	} else {
		if ([elementName isEqualToString:@"item"]) {
			NSString *itemName=[NSString stringWithFormat:@"item%d",itemCount];
			[channel setObject:itemDict forKey:itemName];
			itemCount++;
		} else {
			[itemDict setObject:currentContent forKey:elementName];
		}
	}
	currentContent=nil;
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {	
	//NSLog(@"### End Document");
}	


// =======================================================================================
#								pragma mark SUPPORTED METHOD
// =======================================================================================
-(NSString *)urlEncode:(NSString *)text{
	NSString *s = text;
	s = [s stringByReplacingOccurrencesOfString:@"Ä" withString:@"%C4"];
	s = [s stringByReplacingOccurrencesOfString:@"ä" withString:@"%E4"];
	s = [s stringByReplacingOccurrencesOfString:@"ö" withString:@"%F6"];
	s = [s stringByReplacingOccurrencesOfString:@"Ö" withString:@"%D6"];
	s = [s stringByReplacingOccurrencesOfString:@"ü" withString:@"%FC"];
	s = [s stringByReplacingOccurrencesOfString:@"Ü" withString:@"%DC"];
	s = [s stringByReplacingOccurrencesOfString:@"ß" withString:@"%DF"];	
	s = [s stringByReplacingOccurrencesOfString:@" " withString:@"%20"];	 
	//s = [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	////NSLog(@" s = %@",s);
	return s;
}
@end
