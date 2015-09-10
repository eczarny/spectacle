#import "SpectacleAccessibilityElement.h"

@interface SpectacleAccessibilityElement ()

@property (nonatomic) AXUIElementRef underlyingElement;

@end

#pragma mark -

@implementation SpectacleAccessibilityElement

- (instancetype)init
{
  if (self = [super init]) {
    _underlyingElement = NULL;
  }

  return self;
}

#pragma mark -

+ (SpectacleAccessibilityElement *)systemWideElement
{
  static SpectacleAccessibilityElement *systemWideElement = nil;
  static dispatch_once_t predicate;

  dispatch_once(&predicate, ^{
    AXUIElementRef underlyingElement = AXUIElementCreateSystemWide();

    systemWideElement = [SpectacleAccessibilityElement new];
    systemWideElement.underlyingElement = underlyingElement;

    CFRelease(underlyingElement);
  });

  return systemWideElement;
}

+ (SpectacleAccessibilityElement *)frontmostWindowElement
{
  SpectacleAccessibilityElement *systemWideElement = SpectacleAccessibilityElement.systemWideElement;
  SpectacleAccessibilityElement *applicationWithFocusElement = [systemWideElement elementWithAttribute:kAXFocusedApplicationAttribute];
  SpectacleAccessibilityElement *frontmostWindowElement = nil;

  if (applicationWithFocusElement) {
    frontmostWindowElement = [applicationWithFocusElement elementWithAttribute:kAXFocusedWindowAttribute];

    if (!frontmostWindowElement) {
      NSLog(@"Invalid accessibility element provided, unable to determine the size and position of the window.");
    }
  } else {
    NSLog(@"Failed to find the application that currently has focus.");
  }

  return frontmostWindowElement;
}

#pragma mark -

- (SpectacleAccessibilityElement *)elementWithAttribute:(CFStringRef)attribute
{
  SpectacleAccessibilityElement *newElement = nil;
  AXUIElementRef underlyingElement;
  AXError result;

  result = AXUIElementCopyAttributeValue(self.underlyingElement, attribute, (CFTypeRef *)&underlyingElement);

  if (result == kAXErrorSuccess) {
    newElement = [SpectacleAccessibilityElement new];

    newElement.underlyingElement = underlyingElement;

    CFRelease(underlyingElement);
  } else {
    NSLog(@"Unable to obtain the accessibility element with the specified attribute: %@ (error code %d)", attribute, result);
  }

  return newElement;
}

#pragma mark -

- (NSString *)stringValueOfAttribute:(CFStringRef)attribute
{
  if (CFGetTypeID(self.underlyingElement) == AXUIElementGetTypeID()) {
    CFTypeRef value;
    AXError result;

    result = AXUIElementCopyAttributeValue(self.underlyingElement, attribute, &value);

    if (result == kAXErrorSuccess) {
      return CFBridgingRelease(value);
    } else {
      NSLog(@"There was a problem getting the string value of the specified attribute: %@ (error code %d)", attribute, result);
    }
  }

  return nil;
}

- (AXValueRef)valueOfAttribute:(CFStringRef)attribute type:(AXValueType)type
{
  if (CFGetTypeID(self.underlyingElement) == AXUIElementGetTypeID()) {
    CFTypeRef value;
    AXError result;

    result = AXUIElementCopyAttributeValue(self.underlyingElement, attribute, (CFTypeRef *)&value);

    if ((result == kAXErrorSuccess) && (AXValueGetType(value) == type)) {
      return value;
    } else {
      NSLog(@"There was a problem getting the value of the specified attribute: %@ (error code %d)", attribute, result);
    }
  }

  return NULL;
}

#pragma mark -

- (void)setValue:(AXValueRef)value forAttribute:(CFStringRef)attribute
{
  AXError result = AXUIElementSetAttributeValue(self.underlyingElement, attribute, (CFTypeRef *)value);

  if (result != kAXErrorSuccess) {
    NSLog(@"There was a problem setting the value of the specified attribute: %@ (error code %d)", attribute, result);
  }
}

#pragma mark -

- (BOOL)isSheet
{
  return [[self stringValueOfAttribute:kAXRoleAttribute] isEqualToString:(__bridge NSString *)kAXSheetRole];
}

- (BOOL)isSystemDialog
{
  return [[self stringValueOfAttribute:kAXSubroleAttribute] isEqualToString:(__bridge NSString *)kAXSystemDialogSubrole];
}

#pragma mark -

- (void)dealloc
{
  if (_underlyingElement != NULL) {
    CFRelease(_underlyingElement);
  }
}

#pragma mark -

- (void)setUnderlyingElement:(AXUIElementRef)underlyingElement
{
  if (_underlyingElement != NULL) {
    CFRelease(_underlyingElement);
  }

  _underlyingElement = CFRetain(underlyingElement);
}

@end
