#import "ZKAccessibilityElementAdditions.h"

@implementation ZKAccessibilityElement (ZKAccessibilityElementAdditions)

+ (ZKAccessibilityElement *)frontMostWindowElement {
    ZKAccessibilityElement *systemWideElement = ZKAccessibilityElement.systemWideElement;
    ZKAccessibilityElement *applicationWithFocusElement = [systemWideElement elementWithAttribute: kAXFocusedApplicationAttribute];
    ZKAccessibilityElement *frontMostWindowElement = nil;
    
    if (applicationWithFocusElement) {
        frontMostWindowElement = [applicationWithFocusElement elementWithAttribute: kAXFocusedWindowAttribute];
        
        if (!frontMostWindowElement) {
            NSLog(@"Invalid accessibility element provided, unable to determine the size and position of the window.");
        }
    } else {
        NSLog(@"Failed to find the application that currently has focus.");
    }
    
    return frontMostWindowElement;
}

#pragma mark -

+ (NSString *)frontMostApplicationName {
    ZKAccessibilityElement *systemWideElement = ZKAccessibilityElement.systemWideElement;
    ZKAccessibilityElement *applicationWithFocusElement = [systemWideElement elementWithAttribute: kAXFocusedApplicationAttribute];
    
    return [applicationWithFocusElement stringValueOfAttribute: kAXTitleAttribute];
}

@end
