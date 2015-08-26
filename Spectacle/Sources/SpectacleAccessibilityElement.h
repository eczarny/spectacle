#import <Carbon/Carbon.h>

#import <Foundation/Foundation.h>

@interface SpectacleAccessibilityElement : NSObject

+ (SpectacleAccessibilityElement *)systemWideElement;

+ (SpectacleAccessibilityElement *)frontmostWindowElement;

#pragma mark -

- (SpectacleAccessibilityElement *)elementWithAttribute:(CFStringRef)attribute;

#pragma mark -

- (NSString *)stringValueOfAttribute:(CFStringRef)attribute;

- (AXValueRef)valueOfAttribute:(CFStringRef)attribute type:(AXValueType)type;

#pragma mark -

- (void)setValue:(AXValueRef)value forAttribute:(CFStringRef)attribute;

#pragma mark -

- (BOOL)isSheet;

- (BOOL)isFullScreen;

- (BOOL)isSystemDialog;

@end
