#import "SpectacleAccessibilityElement.h"

@implementation SpectacleAccessibilityElement
{
  AXUIElementRef _underlyingElement;
}

- (instancetype)init
{
  if (self = [super init]) {
    _underlyingElement = NULL;
  }

  return self;
}

#pragma mark -

+ (SpectacleAccessibilityElement *)frontmostApplicationElement
{
  NSRunningApplication *frontmostApplication = [NSWorkspace sharedWorkspace].frontmostApplication;
  SpectacleAccessibilityElement *frontmostApplicationElement = [SpectacleAccessibilityElement new];

  AXUIElementRef underlyingElement = AXUIElementCreateApplication(frontmostApplication.processIdentifier);

  frontmostApplicationElement.underlyingElement = underlyingElement;

  CFRelease(underlyingElement);

  return frontmostApplicationElement;
}

+ (SpectacleAccessibilityElement *)frontmostWindowElement
{
  SpectacleAccessibilityElement *frontmostApplicationElement = [SpectacleAccessibilityElement frontmostApplicationElement];
  SpectacleAccessibilityElement *frontmostWindowElement = nil;

  if (frontmostApplicationElement) {
    frontmostWindowElement = [frontmostApplicationElement elementWithAttribute:kAXFocusedWindowAttribute];

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

  result = AXUIElementCopyAttributeValue(_underlyingElement, attribute, (CFTypeRef *)&underlyingElement);

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
  if (CFGetTypeID(_underlyingElement) == AXUIElementGetTypeID()) {
    CFTypeRef value;
    AXError result;

    result = AXUIElementCopyAttributeValue(_underlyingElement, attribute, &value);

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
  if (CFGetTypeID(_underlyingElement) == AXUIElementGetTypeID()) {
    CFTypeRef value;
    AXError result;

    result = AXUIElementCopyAttributeValue(_underlyingElement, attribute, (CFTypeRef *)&value);

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
  AXError result = AXUIElementSetAttributeValue(_underlyingElement, attribute, (CFTypeRef *)value);

  if (result != kAXErrorSuccess) {
    NSLog(@"There was a problem setting the value of the specified attribute: %@ (error code %d)", attribute, result);
  }
}

#pragma mark -

- (CGRect)rectOfElement
{
  CGRect result = CGRectNull;

  CFTypeRef positionValue = [self valueOfAttribute:kAXPositionAttribute type:kAXValueCGPointType];
  CFTypeRef sizeValue = [self valueOfAttribute:kAXSizeAttribute type:kAXValueCGSizeType];
  CGPoint position;
  CGSize size;

  AXValueGetValue(positionValue, kAXValueCGPointType, (void *)&position);
  AXValueGetValue(sizeValue, kAXValueCGSizeType, (void *)&size);

  if ((positionValue != NULL) && (sizeValue != NULL)) {
    CFRelease(positionValue);
    CFRelease(sizeValue);

    result = CGRectMake(position.x, position.y, size.width, size.height);
  }

  return result;
}

#pragma mark -

- (void)setRectOfElement:(CGRect)rect
{
  AXValueRef positionRef;
  AXValueRef sizeRef;

  positionRef = AXValueCreate(kAXValueCGPointType, (const void *)&rect.origin);
  sizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&rect.size);

  [self setValue:sizeRef forAttribute:kAXSizeAttribute];
  [self setValue:positionRef forAttribute:kAXPositionAttribute];
  [self setValue:sizeRef forAttribute:kAXSizeAttribute];

  CFRelease(positionRef);
  CFRelease(sizeRef);
}

#pragma mark -

+ (CGRect)normalizeCoordinatesOfRect:(CGRect)rect frameOfScreen:(CGRect)frameOfScreen
{
  CGRect frameOfScreenWithMenuBar = [[[NSScreen screens] objectAtIndex:0] frame];
  rect.origin.y = frameOfScreen.size.height - NSMaxY(rect) + (frameOfScreenWithMenuBar.size.height - frameOfScreen.size.height);
  return rect;
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
