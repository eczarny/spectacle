#import <Foundation/Foundation.h>
#import <ZeroKit/ZeroKit.h>

@interface ZKAccessibilityElement (ZKAccessibilityElementAdditions)

+ (ZKAccessibilityElement *)frontMostWindowElement;

#pragma mark -

+ (NSString *)frontMostApplicationName;

@end
