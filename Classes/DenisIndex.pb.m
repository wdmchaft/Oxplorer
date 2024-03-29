// Generated by the protocol buffer compiler.  DO NOT EDIT!
//
//#import "DenisIndex.pb.h"
//
//@implementation DenisIndexRoot
//static PBExtensionRegistry* extensionRegistry = nil;
//+ (PBExtensionRegistry*) extensionRegistry {
//  return extensionRegistry;
//}
//
//+ (void) initialize {
//  if (self == [DenisIndexRoot class]) {
//    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
//    [self registerAllExtensions:registry];
//    extensionRegistry = [registry retain];
//  }
//}
//+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
//}
//@end
//
//@interface Currency ()
//@property (retain) NSString* currency;
//@end
//
//@implementation Currency
//
//- (BOOL) hasCurrency {
//  return !!hasCurrency_;
//}
//- (void) setHasCurrency:(BOOL) value {
//  hasCurrency_ = !!value;
//}
//@synthesize currency;
//- (void) dealloc {
//  self.currency = nil;
//  [super dealloc];
//}
//- (id) init {
//  if ((self = [super init])) {
//    self.currency = @"";
//  }
//  return self;
//}
//static Currency* defaultCurrencyInstance = nil;
//+ (void) initialize {
//  if (self == [Currency class]) {
//    defaultCurrencyInstance = [[Currency alloc] init];
//  }
//}
//+ (Currency*) defaultInstance {
//  return defaultCurrencyInstance;
//}
//- (Currency*) defaultInstance {
//  return defaultCurrencyInstance;
//}
//- (BOOL) isInitialized {
//  if (!self.hasCurrency) {
//    return NO;
//  }
//  return YES;
//}
//- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
//  if (self.hasCurrency) {
//    [output writeString:1 value:self.currency];
//  }
//  [self.unknownFields writeToCodedOutputStream:output];
//}
//- (int32_t) serializedSize {
//  int32_t size = memoizedSerializedSize;
//  if (size != -1) {
//    return size;
//  }
//
//  size = 0;
//  if (self.hasCurrency) {
//    size += computeStringSize(1, self.currency);
//  }
//  size += self.unknownFields.serializedSize;
//  memoizedSerializedSize = size;
//  return size;
//}
//+ (Currency*) parseFromData:(NSData*) data {
//  return (Currency*)[[[Currency builder] mergeFromData:data] build];
//}
//+ (Currency*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  return (Currency*)[[[Currency builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
//}
//+ (Currency*) parseFromInputStream:(NSInputStream*) input {
//  return (Currency*)[[[Currency builder] mergeFromInputStream:input] build];
//}
//+ (Currency*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  return (Currency*)[[[Currency builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
//}
//+ (Currency*) parseFromCodedInputStream:(PBCodedInputStream*) input {
//  return (Currency*)[[[Currency builder] mergeFromCodedInputStream:input] build];
//}
//+ (Currency*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  return (Currency*)[[[Currency builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
//}
//+ (Currency_Builder*) builder {
//  return [[[Currency_Builder alloc] init] autorelease];
//}
//+ (Currency_Builder*) builderWithPrototype:(Currency*) prototype {
//  return [[Currency builder] mergeFrom:prototype];
//}
//- (Currency_Builder*) builder {
//  return [Currency builder];
//}
//@end
//
//@interface Currency_Builder()
//@property (retain) Currency* result;
//@end
//
//@implementation Currency_Builder
//@synthesize result;
//- (void) dealloc {
//  self.result = nil;
//  [super dealloc];
//}
//- (id) init {
//  if ((self = [super init])) {
//    self.result = [[[Currency alloc] init] autorelease];
//  }
//  return self;
//}
//- (PBGeneratedMessage*) internalGetResult {
//  return result;
//}
//- (Currency_Builder*) clear {
//  self.result = [[[Currency alloc] init] autorelease];
//  return self;
//}
//- (Currency_Builder*) clone {
//  return [Currency builderWithPrototype:result];
//}
//- (Currency*) defaultInstance {
//  return [Currency defaultInstance];
//}
//- (Currency*) build {
//  [self checkInitialized];
//  return [self buildPartial];
//}
//- (Currency*) buildPartial {
//  Currency* returnMe = [[result retain] autorelease];
//  self.result = nil;
//  return returnMe;
//}
//- (Currency_Builder*) mergeFrom:(Currency*) other {
//  if (other == [Currency defaultInstance]) {
//    return self;
//  }
//  if (other.hasCurrency) {
//    [self setCurrency:other.currency];
//  }
//  [self mergeUnknownFields:other.unknownFields];
//  return self;
//}
//- (Currency_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
//  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
//}
//- (Currency_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
//  while (YES) {
//    int32_t tag = [input readTag];
//    switch (tag) {
//      case 0:
//        [self setUnknownFields:[unknownFields build]];
//        return self;
//      default: {
//        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
//          [self setUnknownFields:[unknownFields build]];
//          return self;
//        }
//        break;
//      }
//      case 10: {
//        [self setCurrency:[input readString]];
//        break;
//      }
//    }
//  }
//}
//- (BOOL) hasCurrency {
//  return result.hasCurrency;
//}
//- (NSString*) currency {
//  return result.currency;
//}
//- (Currency_Builder*) setCurrency:(NSString*) value {
//  result.hasCurrency = YES;
//  result.currency = value;
//  return self;
//}
//- (Currency_Builder*) clearCurrency {
//  result.hasCurrency = NO;
//  result.currency = @"";
//  return self;
//}
//@end
//
//@interface Index ()
//@property (retain) NSString* id;
//@property (retain) NSString* type;
//@property (retain) NSString* suffix;
//@property (retain) NSString* prefix;
//@property (retain) NSString* sorting;
//@property (retain) NSString* relatedTo;
//@property (retain) NSString* fulltextCreatorId;
//@property (retain) NSString* minLength;
//@property (retain) NSString* maxLength;
//@property (retain) NSString* decimalPrecision;
//@property (retain) NSString* multiple;
//@property (retain) NSMutableArray* mutableUsedCurrenciesList;
//@property (retain) NSString* shortcutKey;
//@end
//
//@implementation Index
//
//- (BOOL) hasId {
//  return !!hasId_;
//}
//- (void) setHasId:(BOOL) value {
//  hasId_ = !!value;
//}
//@synthesize id;
//- (BOOL) hasType {
//  return !!hasType_;
//}
//- (void) setHasType:(BOOL) value {
//  hasType_ = !!value;
//}
//@synthesize type;
//- (BOOL) hasSuffix {
//  return !!hasSuffix_;
//}
//- (void) setHasSuffix:(BOOL) value {
//  hasSuffix_ = !!value;
//}
//@synthesize suffix;
//- (BOOL) hasPrefix {
//  return !!hasPrefix_;
//}
//- (void) setHasPrefix:(BOOL) value {
//  hasPrefix_ = !!value;
//}
//@synthesize prefix;
//- (BOOL) hasSorting {
//  return !!hasSorting_;
//}
//- (void) setHasSorting:(BOOL) value {
//  hasSorting_ = !!value;
//}
//@synthesize sorting;
//- (BOOL) hasRelatedTo {
//  return !!hasRelatedTo_;
//}
//- (void) setHasRelatedTo:(BOOL) value {
//  hasRelatedTo_ = !!value;
//}
//@synthesize relatedTo;
//- (BOOL) hasFulltextCreatorId {
//  return !!hasFulltextCreatorId_;
//}
//- (void) setHasFulltextCreatorId:(BOOL) value {
//  hasFulltextCreatorId_ = !!value;
//}
//@synthesize fulltextCreatorId;
//- (BOOL) hasMinLength {
//  return !!hasMinLength_;
//}
//- (void) setHasMinLength:(BOOL) value {
//  hasMinLength_ = !!value;
//}
//@synthesize minLength;
//- (BOOL) hasMaxLength {
//  return !!hasMaxLength_;
//}
//- (void) setHasMaxLength:(BOOL) value {
//  hasMaxLength_ = !!value;
//}
//@synthesize maxLength;
//- (BOOL) hasDecimalPrecision {
//  return !!hasDecimalPrecision_;
//}
//- (void) setHasDecimalPrecision:(BOOL) value {
//  hasDecimalPrecision_ = !!value;
//}
//@synthesize decimalPrecision;
//- (BOOL) hasMultiple {
//  return !!hasMultiple_;
//}
//- (void) setHasMultiple:(BOOL) value {
//  hasMultiple_ = !!value;
//}
//@synthesize multiple;
//@synthesize mutableUsedCurrenciesList;
//- (BOOL) hasShortcutKey {
//  return !!hasShortcutKey_;
//}
//- (void) setHasShortcutKey:(BOOL) value {
//  hasShortcutKey_ = !!value;
//}
//@synthesize shortcutKey;
//- (void) dealloc {
//  self.id = nil;
//  self.type = nil;
//  self.suffix = nil;
//  self.prefix = nil;
//  self.sorting = nil;
//  self.relatedTo = nil;
//  self.fulltextCreatorId = nil;
//  self.minLength = nil;
//  self.maxLength = nil;
//  self.decimalPrecision = nil;
//  self.multiple = nil;
//  self.mutableUsedCurrenciesList = nil;
//  self.shortcutKey = nil;
//  [super dealloc];
//}
//- (id) init {
//  if ((self = [super init])) {
//    self.id = @"";
//    self.type = @"";
//    self.suffix = @"";
//    self.prefix = @"";
//    self.sorting = @"";
//    self.relatedTo = @"";
//    self.fulltextCreatorId = @"";
//    self.minLength = @"";
//    self.maxLength = @"";
//    self.decimalPrecision = @"";
//    self.multiple = @"";
//    self.shortcutKey = @"";
//  }
//  return self;
//}
//static Index* defaultIndexInstance = nil;
//+ (void) initialize {
//  if (self == [Index class]) {
//    defaultIndexInstance = [[Index alloc] init];
//  }
//}
//+ (Index*) defaultInstance {
//  return defaultIndexInstance;
//}
//- (Index*) defaultInstance {
//  return defaultIndexInstance;
//}
//- (NSArray*) usedCurrenciesList {
//  return mutableUsedCurrenciesList;
//}
//- (Currency*) usedCurrenciesAtIndex:(int32_t) index {
//  id value = [mutableUsedCurrenciesList objectAtIndex:index];
//  return value;
//}
//- (BOOL) isInitialized {
//  if (!self.hasId) {
//    return NO;
//  }
//  for (Currency* element in self.usedCurrenciesList) {
//    if (!element.isInitialized) {
//      return NO;
//    }
//  }
//  return YES;
//}
//- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
//  if (self.hasId) {
//    [output writeString:1 value:self.id];
//  }
//  if (self.hasType) {
//    [output writeString:2 value:self.type];
//  }
//  if (self.hasSuffix) {
//    [output writeString:3 value:self.suffix];
//  }
//  if (self.hasPrefix) {
//    [output writeString:4 value:self.prefix];
//  }
//  if (self.hasSorting) {
//    [output writeString:5 value:self.sorting];
//  }
//  if (self.hasRelatedTo) {
//    [output writeString:6 value:self.relatedTo];
//  }
//  if (self.hasFulltextCreatorId) {
//    [output writeString:7 value:self.fulltextCreatorId];
//  }
//  if (self.hasMinLength) {
//    [output writeString:8 value:self.minLength];
//  }
//  if (self.hasMaxLength) {
//    [output writeString:9 value:self.maxLength];
//  }
//  if (self.hasDecimalPrecision) {
//    [output writeString:10 value:self.decimalPrecision];
//  }
//  if (self.hasMultiple) {
//    [output writeString:11 value:self.multiple];
//  }
//  for (Currency* element in self.usedCurrenciesList) {
//    [output writeMessage:12 value:element];
//  }
//  if (self.hasShortcutKey) {
//    [output writeString:15 value:self.shortcutKey];
//  }
//  [self.unknownFields writeToCodedOutputStream:output];
//}
//- (int32_t) serializedSize {
//  int32_t size = memoizedSerializedSize;
//  if (size != -1) {
//    return size;
//  }
//
//  size = 0;
//  if (self.hasId) {
//    size += computeStringSize(1, self.id);
//  }
//  if (self.hasType) {
//    size += computeStringSize(2, self.type);
//  }
//  if (self.hasSuffix) {
//    size += computeStringSize(3, self.suffix);
//  }
//  if (self.hasPrefix) {
//    size += computeStringSize(4, self.prefix);
//  }
//  if (self.hasSorting) {
//    size += computeStringSize(5, self.sorting);
//  }
//  if (self.hasRelatedTo) {
//    size += computeStringSize(6, self.relatedTo);
//  }
//  if (self.hasFulltextCreatorId) {
//    size += computeStringSize(7, self.fulltextCreatorId);
//  }
//  if (self.hasMinLength) {
//    size += computeStringSize(8, self.minLength);
//  }
//  if (self.hasMaxLength) {
//    size += computeStringSize(9, self.maxLength);
//  }
//  if (self.hasDecimalPrecision) {
//    size += computeStringSize(10, self.decimalPrecision);
//  }
//  if (self.hasMultiple) {
//    size += computeStringSize(11, self.multiple);
//  }
//  for (Currency* element in self.usedCurrenciesList) {
//    size += computeMessageSize(12, element);
//  }
//  if (self.hasShortcutKey) {
//    size += computeStringSize(15, self.shortcutKey);
//  }
//  size += self.unknownFields.serializedSize;
//  memoizedSerializedSize = size;
//  return size;
//}
//+ (Index*) parseFromData:(NSData*) data {
//  return (Index*)[[[Index builder] mergeFromData:data] build];
//}
//+ (Index*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  return (Index*)[[[Index builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
//}
//+ (Index*) parseFromInputStream:(NSInputStream*) input {
//  return (Index*)[[[Index builder] mergeFromInputStream:input] build];
//}
//+ (Index*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  return (Index*)[[[Index builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
//}
//+ (Index*) parseFromCodedInputStream:(PBCodedInputStream*) input {
//  return (Index*)[[[Index builder] mergeFromCodedInputStream:input] build];
//}
//+ (Index*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  return (Index*)[[[Index builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
//}
//+ (Index_Builder*) builder {
//  return [[[Index_Builder alloc] init] autorelease];
//}
//+ (Index_Builder*) builderWithPrototype:(Index*) prototype {
//  return [[Index builder] mergeFrom:prototype];
//}
//- (Index_Builder*) builder {
//  return [Index builder];
//}
//@end
//
//@interface Index_Builder()
//@property (retain) Index* result;
//@end
//
//@implementation Index_Builder
//@synthesize result;
//- (void) dealloc {
//  self.result = nil;
//  [super dealloc];
//}
//- (id) init {
//  if ((self = [super init])) {
//    self.result = [[[Index alloc] init] autorelease];
//  }
//  return self;
//}
//- (PBGeneratedMessage*) internalGetResult {
//  return result;
//}
//- (Index_Builder*) clear {
//  self.result = [[[Index alloc] init] autorelease];
//  return self;
//}
//- (Index_Builder*) clone {
//  return [Index builderWithPrototype:result];
//}
//- (Index*) defaultInstance {
//  return [Index defaultInstance];
//}
//- (Index*) build {
//  [self checkInitialized];
//  return [self buildPartial];
//}
//- (Index*) buildPartial {
//  Index* returnMe = [[result retain] autorelease];
//  self.result = nil;
//  return returnMe;
//}
//- (Index_Builder*) mergeFrom:(Index*) other {
//  if (other == [Index defaultInstance]) {
//    return self;
//  }
//  if (other.hasId) {
//    [self setId:other.id];
//  }
//  if (other.hasType) {
//    [self setType:other.type];
//  }
//  if (other.hasSuffix) {
//    [self setSuffix:other.suffix];
//  }
//  if (other.hasPrefix) {
//    [self setPrefix:other.prefix];
//  }
//  if (other.hasSorting) {
//    [self setSorting:other.sorting];
//  }
//  if (other.hasRelatedTo) {
//    [self setRelatedTo:other.relatedTo];
//  }
//  if (other.hasFulltextCreatorId) {
//    [self setFulltextCreatorId:other.fulltextCreatorId];
//  }
//  if (other.hasMinLength) {
//    [self setMinLength:other.minLength];
//  }
//  if (other.hasMaxLength) {
//    [self setMaxLength:other.maxLength];
//  }
//  if (other.hasDecimalPrecision) {
//    [self setDecimalPrecision:other.decimalPrecision];
//  }
//  if (other.hasMultiple) {
//    [self setMultiple:other.multiple];
//  }
//  if (other.mutableUsedCurrenciesList.count > 0) {
//    if (result.mutableUsedCurrenciesList == nil) {
//      result.mutableUsedCurrenciesList = [NSMutableArray array];
//    }
//    [result.mutableUsedCurrenciesList addObjectsFromArray:other.mutableUsedCurrenciesList];
//  }
//  if (other.hasShortcutKey) {
//    [self setShortcutKey:other.shortcutKey];
//  }
//  [self mergeUnknownFields:other.unknownFields];
//  return self;
//}
//- (Index_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
//  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
//}
//- (Index_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
//  while (YES) {
//    int32_t tag = [input readTag];
//    switch (tag) {
//      case 0:
//        [self setUnknownFields:[unknownFields build]];
//        return self;
//      default: {
//        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
//          [self setUnknownFields:[unknownFields build]];
//          return self;
//        }
//        break;
//      }
//      case 10: {
//        [self setId:[input readString]];
//        break;
//      }
//      case 18: {
//        [self setType:[input readString]];
//        break;
//      }
//      case 26: {
//        [self setSuffix:[input readString]];
//        break;
//      }
//      case 34: {
//        [self setPrefix:[input readString]];
//        break;
//      }
//      case 42: {
//        [self setSorting:[input readString]];
//        break;
//      }
//      case 50: {
//        [self setRelatedTo:[input readString]];
//        break;
//      }
//      case 58: {
//        [self setFulltextCreatorId:[input readString]];
//        break;
//      }
//      case 66: {
//        [self setMinLength:[input readString]];
//        break;
//      }
//      case 74: {
//        [self setMaxLength:[input readString]];
//        break;
//      }
//      case 82: {
//        [self setDecimalPrecision:[input readString]];
//        break;
//      }
//      case 90: {
//        [self setMultiple:[input readString]];
//        break;
//      }
//      case 98: {
//        Currency_Builder* subBuilder = [Currency builder];
//        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
//        [self addUsedCurrencies:[subBuilder buildPartial]];
//        break;
//      }
//      case 122: {
//        [self setShortcutKey:[input readString]];
//        break;
//      }
//    }
//  }
//}
//- (BOOL) hasId {
//  return result.hasId;
//}
//- (NSString*) id {
//  return result.id;
//}
//- (Index_Builder*) setId:(NSString*) value {
//  result.hasId = YES;
//  result.id = value;
//  return self;
//}
//- (Index_Builder*) clearId {
//  result.hasId = NO;
//  result.id = @"";
//  return self;
//}
//- (BOOL) hasType {
//  return result.hasType;
//}
//- (NSString*) type {
//  return result.type;
//}
//- (Index_Builder*) setType:(NSString*) value {
//  result.hasType = YES;
//  result.type = value;
//  return self;
//}
//- (Index_Builder*) clearType {
//  result.hasType = NO;
//  result.type = @"";
//  return self;
//}
//- (BOOL) hasSuffix {
//  return result.hasSuffix;
//}
//- (NSString*) suffix {
//  return result.suffix;
//}
//- (Index_Builder*) setSuffix:(NSString*) value {
//  result.hasSuffix = YES;
//  result.suffix = value;
//  return self;
//}
//- (Index_Builder*) clearSuffix {
//  result.hasSuffix = NO;
//  result.suffix = @"";
//  return self;
//}
//- (BOOL) hasPrefix {
//  return result.hasPrefix;
//}
//- (NSString*) prefix {
//  return result.prefix;
//}
//- (Index_Builder*) setPrefix:(NSString*) value {
//  result.hasPrefix = YES;
//  result.prefix = value;
//  return self;
//}
//- (Index_Builder*) clearPrefix {
//  result.hasPrefix = NO;
//  result.prefix = @"";
//  return self;
//}
//- (BOOL) hasSorting {
//  return result.hasSorting;
//}
//- (NSString*) sorting {
//  return result.sorting;
//}
//- (Index_Builder*) setSorting:(NSString*) value {
//  result.hasSorting = YES;
//  result.sorting = value;
//  return self;
//}
//- (Index_Builder*) clearSorting {
//  result.hasSorting = NO;
//  result.sorting = @"";
//  return self;
//}
//- (BOOL) hasRelatedTo {
//  return result.hasRelatedTo;
//}
//- (NSString*) relatedTo {
//  return result.relatedTo;
//}
//- (Index_Builder*) setRelatedTo:(NSString*) value {
//  result.hasRelatedTo = YES;
//  result.relatedTo = value;
//  return self;
//}
//- (Index_Builder*) clearRelatedTo {
//  result.hasRelatedTo = NO;
//  result.relatedTo = @"";
//  return self;
//}
//- (BOOL) hasFulltextCreatorId {
//  return result.hasFulltextCreatorId;
//}
//- (NSString*) fulltextCreatorId {
//  return result.fulltextCreatorId;
//}
//- (Index_Builder*) setFulltextCreatorId:(NSString*) value {
//  result.hasFulltextCreatorId = YES;
//  result.fulltextCreatorId = value;
//  return self;
//}
//- (Index_Builder*) clearFulltextCreatorId {
//  result.hasFulltextCreatorId = NO;
//  result.fulltextCreatorId = @"";
//  return self;
//}
//- (BOOL) hasMinLength {
//  return result.hasMinLength;
//}
//- (NSString*) minLength {
//  return result.minLength;
//}
//- (Index_Builder*) setMinLength:(NSString*) value {
//  result.hasMinLength = YES;
//  result.minLength = value;
//  return self;
//}
//- (Index_Builder*) clearMinLength {
//  result.hasMinLength = NO;
//  result.minLength = @"";
//  return self;
//}
//- (BOOL) hasMaxLength {
//  return result.hasMaxLength;
//}
//- (NSString*) maxLength {
//  return result.maxLength;
//}
//- (Index_Builder*) setMaxLength:(NSString*) value {
//  result.hasMaxLength = YES;
//  result.maxLength = value;
//  return self;
//}
//- (Index_Builder*) clearMaxLength {
//  result.hasMaxLength = NO;
//  result.maxLength = @"";
//  return self;
//}
//- (BOOL) hasDecimalPrecision {
//  return result.hasDecimalPrecision;
//}
//- (NSString*) decimalPrecision {
//  return result.decimalPrecision;
//}
//- (Index_Builder*) setDecimalPrecision:(NSString*) value {
//  result.hasDecimalPrecision = YES;
//  result.decimalPrecision = value;
//  return self;
//}
//- (Index_Builder*) clearDecimalPrecision {
//  result.hasDecimalPrecision = NO;
//  result.decimalPrecision = @"";
//  return self;
//}
//- (BOOL) hasMultiple {
//  return result.hasMultiple;
//}
//- (NSString*) multiple {
//  return result.multiple;
//}
//- (Index_Builder*) setMultiple:(NSString*) value {
//  result.hasMultiple = YES;
//  result.multiple = value;
//  return self;
//}
//- (Index_Builder*) clearMultiple {
//  result.hasMultiple = NO;
//  result.multiple = @"";
//  return self;
//}
//- (NSArray*) usedCurrenciesList {
//  if (result.mutableUsedCurrenciesList == nil) { return [NSArray array]; }
//  return result.mutableUsedCurrenciesList;
//}
//- (Currency*) usedCurrenciesAtIndex:(int32_t) index {
//  return [result usedCurrenciesAtIndex:index];
//}
//- (Index_Builder*) replaceUsedCurrenciesAtIndex:(int32_t) index with:(Currency*) value {
//  [result.mutableUsedCurrenciesList replaceObjectAtIndex:index withObject:value];
//  return self;
//}
//- (Index_Builder*) addAllUsedCurrencies:(NSArray*) values {
//  if (result.mutableUsedCurrenciesList == nil) {
//    result.mutableUsedCurrenciesList = [NSMutableArray array];
//  }
//  [result.mutableUsedCurrenciesList addObjectsFromArray:values];
//  return self;
//}
//- (Index_Builder*) clearUsedCurrenciesList {
//  result.mutableUsedCurrenciesList = nil;
//  return self;
//}
//- (Index_Builder*) addUsedCurrencies:(Currency*) value {
//  if (result.mutableUsedCurrenciesList == nil) {
//    result.mutableUsedCurrenciesList = [NSMutableArray array];
//  }
//  [result.mutableUsedCurrenciesList addObject:value];
//  return self;
//}
//- (BOOL) hasShortcutKey {
//  return result.hasShortcutKey;
//}
//- (NSString*) shortcutKey {
//  return result.shortcutKey;
//}
//- (Index_Builder*) setShortcutKey:(NSString*) value {
//  result.hasShortcutKey = YES;
//  result.shortcutKey = value;
//  return self;
//}
//- (Index_Builder*) clearShortcutKey {
//  result.hasShortcutKey = NO;
//  result.shortcutKey = @"";
//  return self;
//}
//@end
//
//@interface IndexList ()
//@property (retain) NSMutableArray* mutableIndexList;
//@end
//
//@implementation IndexList
//
//@synthesize mutableIndexList;
//- (void) dealloc {
//  self.mutableIndexList = nil;
//  [super dealloc];
//}
//- (id) init {
//  if ((self = [super init])) {
//  }
//  return self;
//}
//static IndexList* defaultIndexListInstance = nil;
//+ (void) initialize {
//  if (self == [IndexList class]) {
//    defaultIndexListInstance = [[IndexList alloc] init];
//  }
//}
//+ (IndexList*) defaultInstance {
//  return defaultIndexListInstance;
//}
//- (IndexList*) defaultInstance {
//  return defaultIndexListInstance;
//}
//- (NSArray*) indexList {
//  return mutableIndexList;
//}
//- (Index*) indexAtIndex:(int32_t) index {
//  id value = [mutableIndexList objectAtIndex:index];
//  return value;
//}
//- (BOOL) isInitialized {
//  for (Index* element in self.indexList) {
//    if (!element.isInitialized) {
//      return NO;
//    }
//  }
//  return YES;
//}
//- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
//  for (Index* element in self.indexList) {
//    [output writeMessage:1 value:element];
//  }
//  [self.unknownFields writeToCodedOutputStream:output];
//}
//- (int32_t) serializedSize {
//  int32_t size = memoizedSerializedSize;
//  if (size != -1) {
//    return size;
//  }
//
//  size = 0;
//  for (Index* element in self.indexList) {
//    size += computeMessageSize(1, element);
//  }
//  size += self.unknownFields.serializedSize;
//  memoizedSerializedSize = size;
//  return size;
//}
//+ (IndexList*) parseFromData:(NSData*) data {
//  return (IndexList*)[[[IndexList builder] mergeFromData:data] build];
//}
//+ (IndexList*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  return (IndexList*)[[[IndexList builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
//}
//+ (IndexList*) parseFromInputStream:(NSInputStream*) input {
//  return (IndexList*)[[[IndexList builder] mergeFromInputStream:input] build];
//}
//+ (IndexList*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  return (IndexList*)[[[IndexList builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
//}
//+ (IndexList*) parseFromCodedInputStream:(PBCodedInputStream*) input {
//  return (IndexList*)[[[IndexList builder] mergeFromCodedInputStream:input] build];
//}
//+ (IndexList*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  return (IndexList*)[[[IndexList builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
//}
//+ (IndexList_Builder*) builder {
//  return [[[IndexList_Builder alloc] init] autorelease];
//}
//+ (IndexList_Builder*) builderWithPrototype:(IndexList*) prototype {
//  return [[IndexList builder] mergeFrom:prototype];
//}
//- (IndexList_Builder*) builder {
//  return [IndexList builder];
//}
//@end
//
//@interface IndexList_Builder()
//@property (retain) IndexList* result;
//@end
//
//@implementation IndexList_Builder
//@synthesize result;
//- (void) dealloc {
//  self.result = nil;
//  [super dealloc];
//}
//- (id) init {
//  if ((self = [super init])) {
//    self.result = [[[IndexList alloc] init] autorelease];
//  }
//  return self;
//}
//- (PBGeneratedMessage*) internalGetResult {
//  return result;
//}
//- (IndexList_Builder*) clear {
//  self.result = [[[IndexList alloc] init] autorelease];
//  return self;
//}
//- (IndexList_Builder*) clone {
//  return [IndexList builderWithPrototype:result];
//}
//- (IndexList*) defaultInstance {
//  return [IndexList defaultInstance];
//}
//- (IndexList*) build {
//  [self checkInitialized];
//  return [self buildPartial];
//}
//- (IndexList*) buildPartial {
//  IndexList* returnMe = [[result retain] autorelease];
//  self.result = nil;
//  return returnMe;
//}
//- (IndexList_Builder*) mergeFrom:(IndexList*) other {
//  if (other == [IndexList defaultInstance]) {
//    return self;
//  }
//  if (other.mutableIndexList.count > 0) {
//    if (result.mutableIndexList == nil) {
//      result.mutableIndexList = [NSMutableArray array];
//    }
//    [result.mutableIndexList addObjectsFromArray:other.mutableIndexList];
//  }
//  [self mergeUnknownFields:other.unknownFields];
//  return self;
//}
//- (IndexList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
//  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
//}
//- (IndexList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
//  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
//  while (YES) {
//    int32_t tag = [input readTag];
//    switch (tag) {
//      case 0:
//        [self setUnknownFields:[unknownFields build]];
//        return self;
//      default: {
//        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
//          [self setUnknownFields:[unknownFields build]];
//          return self;
//        }
//        break;
//      }
//      case 10: {
//        Index_Builder* subBuilder = [Index builder];
//        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
//        [self addIndex:[subBuilder buildPartial]];
//        break;
//      }
//    }
//  }
//}
//- (NSArray*) indexList {
//  if (result.mutableIndexList == nil) { return [NSArray array]; }
//  return result.mutableIndexList;
//}
//- (Index*) indexAtIndex:(int32_t) index {
//  return [result indexAtIndex:index];
//}
//- (IndexList_Builder*) replaceIndexAtIndex:(int32_t) index with:(Index*) value {
//  [result.mutableIndexList replaceObjectAtIndex:index withObject:value];
//  return self;
//}
//- (IndexList_Builder*) addAllIndex:(NSArray*) values {
//  if (result.mutableIndexList == nil) {
//    result.mutableIndexList = [NSMutableArray array];
//  }
//  [result.mutableIndexList addObjectsFromArray:values];
//  return self;
//}
//- (IndexList_Builder*) clearIndexList {
//  result.mutableIndexList = nil;
//  return self;
//}
//- (IndexList_Builder*) addIndex:(Index*) value {
//  if (result.mutableIndexList == nil) {
//    result.mutableIndexList = [NSMutableArray array];
//  }
//  [result.mutableIndexList addObject:value];
//  return self;
//}
//@end
//
