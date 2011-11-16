#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface SpectacleAccessibilityElement : NSObject {
    AXUIElementRef myElement;
}

+ (SpectacleAccessibilityElement *)systemWideElement;

#pragma mark -

- (SpectacleAccessibilityElement *)elementWithAttribute: (CFStringRef)attribute;

#pragma mark -

- (AXValueRef)valueOfAttribute: (CFStringRef)attribute type: (AXValueType)type;

- (void)setValue: (AXValueRef)value forAttribute: (CFStringRef)attribute;

@end
