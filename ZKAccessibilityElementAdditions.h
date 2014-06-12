#import <Foundation/Foundation.h>

#import "ZKAccessibilityElement.h"

@interface ZKAccessibilityElement (ZKAccessibilityElementAdditions)

+ (ZKAccessibilityElement *)frontMostWindowElement;

#pragma mark -

+ (NSString *)frontMostApplicationName;

@end
