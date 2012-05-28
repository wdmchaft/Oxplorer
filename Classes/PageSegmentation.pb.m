// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "PageSegmentation.pb.h"

@implementation PageSegmentationRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [PageSegmentationRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

@interface Page ()
@property int32_t pageId;
@property Float32 imageWidth;
@property Float32 imageHeight;
@property Float32 imageXres;
@property Float32 imageYres;
@property (retain) NSMutableArray* mutableSegmentList;
@end

@implementation Page

- (BOOL) hasPageId {
  return !!hasPageId_;
}
- (void) setHasPageId:(BOOL) value {
  hasPageId_ = !!value;
}
@synthesize pageId;
- (BOOL) hasImageWidth {
  return !!hasImageWidth_;
}
- (void) setHasImageWidth:(BOOL) value {
  hasImageWidth_ = !!value;
}
@synthesize imageWidth;
- (BOOL) hasImageHeight {
  return !!hasImageHeight_;
}
- (void) setHasImageHeight:(BOOL) value {
  hasImageHeight_ = !!value;
}
@synthesize imageHeight;
- (BOOL) hasImageXres {
  return !!hasImageXres_;
}
- (void) setHasImageXres:(BOOL) value {
  hasImageXres_ = !!value;
}
@synthesize imageXres;
- (BOOL) hasImageYres {
  return !!hasImageYres_;
}
- (void) setHasImageYres:(BOOL) value {
  hasImageYres_ = !!value;
}
@synthesize imageYres;
@synthesize mutableSegmentList;
- (void) dealloc {
  self.mutableSegmentList = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.pageId = 0;
    self.imageWidth = 0;
    self.imageHeight = 0;
    self.imageXres = 0;
    self.imageYres = 0;
  }
  return self;
}
static Page* defaultPageInstance = nil;
+ (void) initialize {
  if (self == [Page class]) {
    defaultPageInstance = [[Page alloc] init];
  }
}
+ (Page*) defaultInstance {
  return defaultPageInstance;
}
- (Page*) defaultInstance {
  return defaultPageInstance;
}
- (NSArray*) segmentList {
  return mutableSegmentList;
}
- (Page_Segment*) segmentAtIndex:(int32_t) index {
  id value = [mutableSegmentList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  if (!self.hasPageId) {
    return NO;
  }
  for (Page_Segment* element in self.segmentList) {
    if (!element.isInitialized) {
      return NO;
    }
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasPageId) {
    [output writeInt32:1 value:self.pageId];
  }
  if (self.hasImageWidth) {
    [output writeFloat:2 value:self.imageWidth];
  }
  if (self.hasImageHeight) {
    [output writeFloat:3 value:self.imageHeight];
  }
  if (self.hasImageXres) {
    [output writeFloat:4 value:self.imageXres];
  }
  if (self.hasImageYres) {
    [output writeFloat:5 value:self.imageYres];
  }
  for (Page_Segment* element in self.segmentList) {
    [output writeMessage:6 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasPageId) {
    size += computeInt32Size(1, self.pageId);
  }
  if (self.hasImageWidth) {
    size += computeFloatSize(2, self.imageWidth);
  }
  if (self.hasImageHeight) {
    size += computeFloatSize(3, self.imageHeight);
  }
  if (self.hasImageXres) {
    size += computeFloatSize(4, self.imageXres);
  }
  if (self.hasImageYres) {
    size += computeFloatSize(5, self.imageYres);
  }
  for (Page_Segment* element in self.segmentList) {
    size += computeMessageSize(6, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (Page*) parseFromData:(NSData*) data {
  return (Page*)[[[Page builder] mergeFromData:data] build];
}
+ (Page*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Page*)[[[Page builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (Page*) parseFromInputStream:(NSInputStream*) input {
  return (Page*)[[[Page builder] mergeFromInputStream:input] build];
}
+ (Page*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Page*)[[[Page builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Page*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (Page*)[[[Page builder] mergeFromCodedInputStream:input] build];
}
+ (Page*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Page*)[[[Page builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Page_Builder*) builder {
  return [[[Page_Builder alloc] init] autorelease];
}
+ (Page_Builder*) builderWithPrototype:(Page*) prototype {
  return [[Page builder] mergeFrom:prototype];
}
- (Page_Builder*) builder {
  return [Page builder];
}
@end

@interface Page_Segment ()
@property int32_t id;
@property Float32 x;
@property Float32 y;
@property Float32 w;
@property Float32 h;
@property (retain) NSMutableArray* mutableOcrList;
@end

@implementation Page_Segment

- (BOOL) hasId {
  return !!hasId_;
}
- (void) setHasId:(BOOL) value {
  hasId_ = !!value;
}
@synthesize id;
- (BOOL) hasX {
  return !!hasX_;
}
- (void) setHasX:(BOOL) value {
  hasX_ = !!value;
}
@synthesize x;
- (BOOL) hasY {
  return !!hasY_;
}
- (void) setHasY:(BOOL) value {
  hasY_ = !!value;
}
@synthesize y;
- (BOOL) hasW {
  return !!hasW_;
}
- (void) setHasW:(BOOL) value {
  hasW_ = !!value;
}
@synthesize w;
- (BOOL) hasH {
  return !!hasH_;
}
- (void) setHasH:(BOOL) value {
  hasH_ = !!value;
}
@synthesize h;
@synthesize mutableOcrList;
- (void) dealloc {
  self.mutableOcrList = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.id = 0;
    self.x = 0;
    self.y = 0;
    self.w = 0;
    self.h = 0;
  }
  return self;
}
static Page_Segment* defaultPage_SegmentInstance = nil;
+ (void) initialize {
  if (self == [Page_Segment class]) {
    defaultPage_SegmentInstance = [[Page_Segment alloc] init];
  }
}
+ (Page_Segment*) defaultInstance {
  return defaultPage_SegmentInstance;
}
- (Page_Segment*) defaultInstance {
  return defaultPage_SegmentInstance;
}
- (NSArray*) ocrList {
  return mutableOcrList;
}
- (Page_Segment_Ocr*) ocrAtIndex:(int32_t) index {
  id value = [mutableOcrList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  if (!self.hasId) {
    return NO;
  }
  if (!self.hasX) {
    return NO;
  }
  if (!self.hasY) {
    return NO;
  }
  if (!self.hasW) {
    return NO;
  }
  if (!self.hasH) {
    return NO;
  }
  for (Page_Segment_Ocr* element in self.ocrList) {
    if (!element.isInitialized) {
      return NO;
    }
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasId) {
    [output writeInt32:1 value:self.id];
  }
  if (self.hasX) {
    [output writeFloat:2 value:self.x];
  }
  if (self.hasY) {
    [output writeFloat:3 value:self.y];
  }
  if (self.hasW) {
    [output writeFloat:4 value:self.w];
  }
  if (self.hasH) {
    [output writeFloat:5 value:self.h];
  }
  for (Page_Segment_Ocr* element in self.ocrList) {
    [output writeMessage:6 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasId) {
    size += computeInt32Size(1, self.id);
  }
  if (self.hasX) {
    size += computeFloatSize(2, self.x);
  }
  if (self.hasY) {
    size += computeFloatSize(3, self.y);
  }
  if (self.hasW) {
    size += computeFloatSize(4, self.w);
  }
  if (self.hasH) {
    size += computeFloatSize(5, self.h);
  }
  for (Page_Segment_Ocr* element in self.ocrList) {
    size += computeMessageSize(6, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (Page_Segment*) parseFromData:(NSData*) data {
  return (Page_Segment*)[[[Page_Segment builder] mergeFromData:data] build];
}
+ (Page_Segment*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Page_Segment*)[[[Page_Segment builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (Page_Segment*) parseFromInputStream:(NSInputStream*) input {
  return (Page_Segment*)[[[Page_Segment builder] mergeFromInputStream:input] build];
}
+ (Page_Segment*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Page_Segment*)[[[Page_Segment builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Page_Segment*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (Page_Segment*)[[[Page_Segment builder] mergeFromCodedInputStream:input] build];
}
+ (Page_Segment*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Page_Segment*)[[[Page_Segment builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Page_Segment_Builder*) builder {
  return [[[Page_Segment_Builder alloc] init] autorelease];
}
+ (Page_Segment_Builder*) builderWithPrototype:(Page_Segment*) prototype {
  return [[Page_Segment builder] mergeFrom:prototype];
}
- (Page_Segment_Builder*) builder {
  return [Page_Segment builder];
}
@end

@interface Page_Segment_Ocr ()
@property (retain) NSString* classifierId;
@property (retain) NSString* ocrString;
@property (retain) NSString* score;
@end

@implementation Page_Segment_Ocr

- (BOOL) hasClassifierId {
  return !!hasClassifierId_;
}
- (void) setHasClassifierId:(BOOL) value {
  hasClassifierId_ = !!value;
}
@synthesize classifierId;
- (BOOL) hasOcrString {
  return !!hasOcrString_;
}
- (void) setHasOcrString:(BOOL) value {
  hasOcrString_ = !!value;
}
@synthesize ocrString;
- (BOOL) hasScore {
  return !!hasScore_;
}
- (void) setHasScore:(BOOL) value {
  hasScore_ = !!value;
}
@synthesize score;
- (void) dealloc {
  self.classifierId = nil;
  self.ocrString = nil;
  self.score = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.classifierId = @"";
    self.ocrString = @"";
    self.score = @"";
  }
  return self;
}
static Page_Segment_Ocr* defaultPage_Segment_OcrInstance = nil;
+ (void) initialize {
  if (self == [Page_Segment_Ocr class]) {
    defaultPage_Segment_OcrInstance = [[Page_Segment_Ocr alloc] init];
  }
}
+ (Page_Segment_Ocr*) defaultInstance {
  return defaultPage_Segment_OcrInstance;
}
- (Page_Segment_Ocr*) defaultInstance {
  return defaultPage_Segment_OcrInstance;
}
- (BOOL) isInitialized {
  if (!self.hasClassifierId) {
    return NO;
  }
  if (!self.hasOcrString) {
    return NO;
  }
  if (!self.hasScore) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasClassifierId) {
    [output writeString:1 value:self.classifierId];
  }
  if (self.hasOcrString) {
    [output writeString:2 value:self.ocrString];
  }
  if (self.hasScore) {
    [output writeString:3 value:self.score];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasClassifierId) {
    size += computeStringSize(1, self.classifierId);
  }
  if (self.hasOcrString) {
    size += computeStringSize(2, self.ocrString);
  }
  if (self.hasScore) {
    size += computeStringSize(3, self.score);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (Page_Segment_Ocr*) parseFromData:(NSData*) data {
  return (Page_Segment_Ocr*)[[[Page_Segment_Ocr builder] mergeFromData:data] build];
}
+ (Page_Segment_Ocr*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Page_Segment_Ocr*)[[[Page_Segment_Ocr builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (Page_Segment_Ocr*) parseFromInputStream:(NSInputStream*) input {
  return (Page_Segment_Ocr*)[[[Page_Segment_Ocr builder] mergeFromInputStream:input] build];
}
+ (Page_Segment_Ocr*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Page_Segment_Ocr*)[[[Page_Segment_Ocr builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Page_Segment_Ocr*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (Page_Segment_Ocr*)[[[Page_Segment_Ocr builder] mergeFromCodedInputStream:input] build];
}
+ (Page_Segment_Ocr*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (Page_Segment_Ocr*)[[[Page_Segment_Ocr builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (Page_Segment_Ocr_Builder*) builder {
  return [[[Page_Segment_Ocr_Builder alloc] init] autorelease];
}
+ (Page_Segment_Ocr_Builder*) builderWithPrototype:(Page_Segment_Ocr*) prototype {
  return [[Page_Segment_Ocr builder] mergeFrom:prototype];
}
- (Page_Segment_Ocr_Builder*) builder {
  return [Page_Segment_Ocr builder];
}
@end

@interface Page_Segment_Ocr_Builder()
@property (retain) Page_Segment_Ocr* result;
@end

@implementation Page_Segment_Ocr_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[Page_Segment_Ocr alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (Page_Segment_Ocr_Builder*) clear {
  self.result = [[[Page_Segment_Ocr alloc] init] autorelease];
  return self;
}
- (Page_Segment_Ocr_Builder*) clone {
  return [Page_Segment_Ocr builderWithPrototype:result];
}
- (Page_Segment_Ocr*) defaultInstance {
  return [Page_Segment_Ocr defaultInstance];
}
- (Page_Segment_Ocr*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (Page_Segment_Ocr*) buildPartial {
  Page_Segment_Ocr* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (Page_Segment_Ocr_Builder*) mergeFrom:(Page_Segment_Ocr*) other {
  if (other == [Page_Segment_Ocr defaultInstance]) {
    return self;
  }
  if (other.hasClassifierId) {
    [self setClassifierId:other.classifierId];
  }
  if (other.hasOcrString) {
    [self setOcrString:other.ocrString];
  }
  if (other.hasScore) {
    [self setScore:other.score];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (Page_Segment_Ocr_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (Page_Segment_Ocr_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setClassifierId:[input readString]];
        break;
      }
      case 18: {
        [self setOcrString:[input readString]];
        break;
      }
      case 26: {
        [self setScore:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasClassifierId {
  return result.hasClassifierId;
}
- (NSString*) classifierId {
  return result.classifierId;
}
- (Page_Segment_Ocr_Builder*) setClassifierId:(NSString*) value {
  result.hasClassifierId = YES;
  result.classifierId = value;
  return self;
}
- (Page_Segment_Ocr_Builder*) clearClassifierId {
  result.hasClassifierId = NO;
  result.classifierId = @"";
  return self;
}
- (BOOL) hasOcrString {
  return result.hasOcrString;
}
- (NSString*) ocrString {
  return result.ocrString;
}
- (Page_Segment_Ocr_Builder*) setOcrString:(NSString*) value {
  result.hasOcrString = YES;
  result.ocrString = value;
  return self;
}
- (Page_Segment_Ocr_Builder*) clearOcrString {
  result.hasOcrString = NO;
  result.ocrString = @"";
  return self;
}
- (BOOL) hasScore {
  return result.hasScore;
}
- (NSString*) score {
  return result.score;
}
- (Page_Segment_Ocr_Builder*) setScore:(NSString*) value {
  result.hasScore = YES;
  result.score = value;
  return self;
}
- (Page_Segment_Ocr_Builder*) clearScore {
  result.hasScore = NO;
  result.score = @"";
  return self;
}
@end

@interface Page_Segment_Builder()
@property (retain) Page_Segment* result;
@end

@implementation Page_Segment_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[Page_Segment alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (Page_Segment_Builder*) clear {
  self.result = [[[Page_Segment alloc] init] autorelease];
  return self;
}
- (Page_Segment_Builder*) clone {
  return [Page_Segment builderWithPrototype:result];
}
- (Page_Segment*) defaultInstance {
  return [Page_Segment defaultInstance];
}
- (Page_Segment*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (Page_Segment*) buildPartial {
  Page_Segment* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (Page_Segment_Builder*) mergeFrom:(Page_Segment*) other {
  if (other == [Page_Segment defaultInstance]) {
    return self;
  }
  if (other.hasId) {
    [self setId:other.id];
  }
  if (other.hasX) {
    [self setX:other.x];
  }
  if (other.hasY) {
    [self setY:other.y];
  }
  if (other.hasW) {
    [self setW:other.w];
  }
  if (other.hasH) {
    [self setH:other.h];
  }
  if (other.mutableOcrList.count > 0) {
    if (result.mutableOcrList == nil) {
      result.mutableOcrList = [NSMutableArray array];
    }
    [result.mutableOcrList addObjectsFromArray:other.mutableOcrList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (Page_Segment_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (Page_Segment_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setId:[input readInt32]];
        break;
      }
      case 21: {
        [self setX:[input readFloat]];
        break;
      }
      case 29: {
        [self setY:[input readFloat]];
        break;
      }
      case 37: {
        [self setW:[input readFloat]];
        break;
      }
      case 45: {
        [self setH:[input readFloat]];
        break;
      }
      case 50: {
        Page_Segment_Ocr_Builder* subBuilder = [Page_Segment_Ocr builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addOcr:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasId {
  return result.hasId;
}
- (int32_t) id {
  return result.id;
}
- (Page_Segment_Builder*) setId:(int32_t) value {
  result.hasId = YES;
  result.id = value;
  return self;
}
- (Page_Segment_Builder*) clearId {
  result.hasId = NO;
  result.id = 0;
  return self;
}
- (BOOL) hasX {
  return result.hasX;
}
- (Float32) x {
  return result.x;
}
- (Page_Segment_Builder*) setX:(Float32) value {
  result.hasX = YES;
  result.x = value;
  return self;
}
- (Page_Segment_Builder*) clearX {
  result.hasX = NO;
  result.x = 0;
  return self;
}
- (BOOL) hasY {
  return result.hasY;
}
- (Float32) y {
  return result.y;
}
- (Page_Segment_Builder*) setY:(Float32) value {
  result.hasY = YES;
  result.y = value;
  return self;
}
- (Page_Segment_Builder*) clearY {
  result.hasY = NO;
  result.y = 0;
  return self;
}
- (BOOL) hasW {
  return result.hasW;
}
- (Float32) w {
  return result.w;
}
- (Page_Segment_Builder*) setW:(Float32) value {
  result.hasW = YES;
  result.w = value;
  return self;
}
- (Page_Segment_Builder*) clearW {
  result.hasW = NO;
  result.w = 0;
  return self;
}
- (BOOL) hasH {
  return result.hasH;
}
- (Float32) h {
  return result.h;
}
- (Page_Segment_Builder*) setH:(Float32) value {
  result.hasH = YES;
  result.h = value;
  return self;
}
- (Page_Segment_Builder*) clearH {
  result.hasH = NO;
  result.h = 0;
  return self;
}
- (NSArray*) ocrList {
  if (result.mutableOcrList == nil) { return [NSArray array]; }
  return result.mutableOcrList;
}
- (Page_Segment_Ocr*) ocrAtIndex:(int32_t) index {
  return [result ocrAtIndex:index];
}
- (Page_Segment_Builder*) replaceOcrAtIndex:(int32_t) index with:(Page_Segment_Ocr*) value {
  [result.mutableOcrList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (Page_Segment_Builder*) addAllOcr:(NSArray*) values {
  if (result.mutableOcrList == nil) {
    result.mutableOcrList = [NSMutableArray array];
  }
  [result.mutableOcrList addObjectsFromArray:values];
  return self;
}
- (Page_Segment_Builder*) clearOcrList {
  result.mutableOcrList = nil;
  return self;
}
- (Page_Segment_Builder*) addOcr:(Page_Segment_Ocr*) value {
  if (result.mutableOcrList == nil) {
    result.mutableOcrList = [NSMutableArray array];
  }
  [result.mutableOcrList addObject:value];
  return self;
}
@end

@interface Page_Builder()
@property (retain) Page* result;
@end

@implementation Page_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[Page alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (Page_Builder*) clear {
  self.result = [[[Page alloc] init] autorelease];
  return self;
}
- (Page_Builder*) clone {
  return [Page builderWithPrototype:result];
}
- (Page*) defaultInstance {
  return [Page defaultInstance];
}
- (Page*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (Page*) buildPartial {
  Page* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (Page_Builder*) mergeFrom:(Page*) other {
  if (other == [Page defaultInstance]) {
    return self;
  }
  if (other.hasPageId) {
    [self setPageId:other.pageId];
  }
  if (other.hasImageWidth) {
    [self setImageWidth:other.imageWidth];
  }
  if (other.hasImageHeight) {
    [self setImageHeight:other.imageHeight];
  }
  if (other.hasImageXres) {
    [self setImageXres:other.imageXres];
  }
  if (other.hasImageYres) {
    [self setImageYres:other.imageYres];
  }
  if (other.mutableSegmentList.count > 0) {
    if (result.mutableSegmentList == nil) {
      result.mutableSegmentList = [NSMutableArray array];
    }
    [result.mutableSegmentList addObjectsFromArray:other.mutableSegmentList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (Page_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (Page_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setPageId:[input readInt32]];
        break;
      }
      case 21: {
        [self setImageWidth:[input readFloat]];
        break;
      }
      case 29: {
        [self setImageHeight:[input readFloat]];
        break;
      }
      case 37: {
        [self setImageXres:[input readFloat]];
        break;
      }
      case 45: {
        [self setImageYres:[input readFloat]];
        break;
      }
      case 50: {
        Page_Segment_Builder* subBuilder = [Page_Segment builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addSegment:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasPageId {
  return result.hasPageId;
}
- (int32_t) pageId {
  return result.pageId;
}
- (Page_Builder*) setPageId:(int32_t) value {
  result.hasPageId = YES;
  result.pageId = value;
  return self;
}
- (Page_Builder*) clearPageId {
  result.hasPageId = NO;
  result.pageId = 0;
  return self;
}
- (BOOL) hasImageWidth {
  return result.hasImageWidth;
}
- (Float32) imageWidth {
  return result.imageWidth;
}
- (Page_Builder*) setImageWidth:(Float32) value {
  result.hasImageWidth = YES;
  result.imageWidth = value;
  return self;
}
- (Page_Builder*) clearImageWidth {
  result.hasImageWidth = NO;
  result.imageWidth = 0;
  return self;
}
- (BOOL) hasImageHeight {
  return result.hasImageHeight;
}
- (Float32) imageHeight {
  return result.imageHeight;
}
- (Page_Builder*) setImageHeight:(Float32) value {
  result.hasImageHeight = YES;
  result.imageHeight = value;
  return self;
}
- (Page_Builder*) clearImageHeight {
  result.hasImageHeight = NO;
  result.imageHeight = 0;
  return self;
}
- (BOOL) hasImageXres {
  return result.hasImageXres;
}
- (Float32) imageXres {
  return result.imageXres;
}
- (Page_Builder*) setImageXres:(Float32) value {
  result.hasImageXres = YES;
  result.imageXres = value;
  return self;
}
- (Page_Builder*) clearImageXres {
  result.hasImageXres = NO;
  result.imageXres = 0;
  return self;
}
- (BOOL) hasImageYres {
  return result.hasImageYres;
}
- (Float32) imageYres {
  return result.imageYres;
}
- (Page_Builder*) setImageYres:(Float32) value {
  result.hasImageYres = YES;
  result.imageYres = value;
  return self;
}
- (Page_Builder*) clearImageYres {
  result.hasImageYres = NO;
  result.imageYres = 0;
  return self;
}
- (NSArray*) segmentList {
  if (result.mutableSegmentList == nil) { return [NSArray array]; }
  return result.mutableSegmentList;
}
- (Page_Segment*) segmentAtIndex:(int32_t) index {
  return [result segmentAtIndex:index];
}
- (Page_Builder*) replaceSegmentAtIndex:(int32_t) index with:(Page_Segment*) value {
  [result.mutableSegmentList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (Page_Builder*) addAllSegment:(NSArray*) values {
  if (result.mutableSegmentList == nil) {
    result.mutableSegmentList = [NSMutableArray array];
  }
  [result.mutableSegmentList addObjectsFromArray:values];
  return self;
}
- (Page_Builder*) clearSegmentList {
  result.mutableSegmentList = nil;
  return self;
}
- (Page_Builder*) addSegment:(Page_Segment*) value {
  if (result.mutableSegmentList == nil) {
    result.mutableSegmentList = [NSMutableArray array];
  }
  [result.mutableSegmentList addObject:value];
  return self;
}
@end

