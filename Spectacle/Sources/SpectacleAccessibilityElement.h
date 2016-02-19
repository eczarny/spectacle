#import <AppKit/Appkit.h>

#import <Carbon/Carbon.h>

@interface SpectacleAccessibilityElement : NSObject

+ (SpectacleAccessibilityElement *)frontmostApplicationElement;

+ (SpectacleAccessibilityElement *)frontmostWindowElement;

#pragma mark -

- (SpectacleAccessibilityElement *)elementWithAttribute:(CFStringRef)attribute;

#pragma mark -

- (NSString *)stringValueOfAttribute:(CFStringRef)attribute;

- (AXValueRef)valueOfAttribute:(CFStringRef)attribute type:(AXValueType)type;

#pragma mark -

- (void)setValue:(AXValueRef)value forAttribute:(CFStringRef)attribute;

#pragma mark -

- (CGRect)rectOfElement;

#pragma mark -

- (void)setRectOfElement:(CGRect)rect;

#pragma mark -

+ (CGRect)normalizeCoordinatesOfRect:(CGRect)rect frameOfScreen:(CGRect)frameOfScreen;

#pragma mark -

- (BOOL)isSheet;

- (BOOL)isSystemDialog;

@end
