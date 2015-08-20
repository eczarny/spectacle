#import "SpectacleAccessibilityElement.h"

@interface SpectacleAccessibilityElement ()

@property (nonatomic) AXUIElementRef element;

@end

#pragma mark -

@implementation SpectacleAccessibilityElement

- (instancetype)init
{
  if (self = [super init]) {
    _element = NULL;
  }

  return self;
}

#pragma mark -

+ (SpectacleAccessibilityElement *)systemWideElement
{
  SpectacleAccessibilityElement *newElement = [SpectacleAccessibilityElement new];
  AXUIElementRef systemWideElement = AXUIElementCreateSystemWide();

  newElement.element = systemWideElement;

  CFRelease(systemWideElement);

  return newElement;
}

#pragma mark -

+ (SpectacleAccessibilityElement *)frontMostWindowElement
{
  SpectacleAccessibilityElement *systemWideElement = SpectacleAccessibilityElement.systemWideElement;
  SpectacleAccessibilityElement *applicationWithFocusElement = [systemWideElement elementWithAttribute:kAXFocusedApplicationAttribute];
  SpectacleAccessibilityElement *frontMostWindowElement = nil;

  if (applicationWithFocusElement) {
    frontMostWindowElement = [applicationWithFocusElement elementWithAttribute:kAXFocusedWindowAttribute];

    if (!frontMostWindowElement) {
      NSLog(@"Invalid accessibility element provided, unable to determine the size and position of the window.");
    }
  } else {
    NSLog(@"Failed to find the application that currently has focus.");
  }

  return frontMostWindowElement;
}

+ (NSString *)frontMostApplicationName
{
  SpectacleAccessibilityElement *systemWideElement = SpectacleAccessibilityElement.systemWideElement;
  SpectacleAccessibilityElement *applicationWithFocusElement = [systemWideElement elementWithAttribute:kAXFocusedApplicationAttribute];

  return [applicationWithFocusElement stringValueOfAttribute:kAXTitleAttribute];
}

#pragma mark -

- (SpectacleAccessibilityElement *)elementWithAttribute:(CFStringRef)attribute
{
  SpectacleAccessibilityElement *newElement = nil;
  AXUIElementRef childElement;
  AXError result;

  result = AXUIElementCopyAttributeValue(self.element, attribute, (CFTypeRef *)&childElement);

  if (result == kAXErrorSuccess) {
    newElement = [SpectacleAccessibilityElement new];

    newElement.element = childElement;

    CFRelease(childElement);
  } else {
    NSLog(@"Unable to obtain the accessibility element with the specified attribute: %@ (error code %d)", attribute, result);
  }

  return newElement;
}

#pragma mark -

- (NSString *)stringValueOfAttribute:(CFStringRef)attribute
{
  if (CFGetTypeID(self.element) == AXUIElementGetTypeID()) {
    CFTypeRef value;
    AXError result;

    result = AXUIElementCopyAttributeValue(self.element, attribute, &value);

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
  if (CFGetTypeID(self.element) == AXUIElementGetTypeID()) {
    CFTypeRef value;
    AXError result;

    result = AXUIElementCopyAttributeValue(self.element, attribute, (CFTypeRef *)&value);

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
  AXError result = AXUIElementSetAttributeValue(self.element, attribute, (CFTypeRef *)value);

  if (result != kAXErrorSuccess) {
    NSLog(@"There was a problem setting the value of the specified attribute: %@ (error code %d)", attribute, result);
  }
}

#pragma mark -

- (BOOL)isSheet
{
  return [[self stringValueOfAttribute:kAXRoleAttribute] isEqualToString:(__bridge NSString *)kAXSheetRole];
}

- (BOOL)isFullScreen
{
  SpectacleAccessibilityElement *fullScreenButtonElement = [self elementWithAttribute:kAXFullScreenButtonAttribute];

  return [[fullScreenButtonElement stringValueOfAttribute:kAXSubroleAttribute] isEqualToString:(__bridge NSString *)kAXZoomButtonSubrole];
}

#pragma mark -

- (void)dealloc
{
  if (_element != NULL) {
    CFRelease(_element);
  }
}

#pragma mark -

- (void)setElement:(AXUIElementRef)element
{
  if (_element != NULL) {
    CFRelease(_element);
  }

  _element = CFRetain(element);
}

@end
