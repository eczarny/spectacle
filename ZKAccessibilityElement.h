#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface ZKAccessibilityElement : NSObject

+ (ZKAccessibilityElement *)systemWideElement;

#pragma mark -

- (ZKAccessibilityElement *)elementWithAttribute: (CFStringRef)attribute;

#pragma mark -

- (NSString *)stringValueOfAttribute: (CFStringRef)attribute;

- (AXValueRef)valueOfAttribute: (CFStringRef)attribute type: (AXValueType)type;

#pragma mark -

- (void)setValue: (AXValueRef)value forAttribute: (CFStringRef)attribute;

@end
