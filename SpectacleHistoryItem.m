#import "SpectacleHistoryItem.h"

@implementation SpectacleHistoryItem

- (id)initWithAccessibilityElement: (ZKAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect {
    if (self = [super init]) {
        myAccessibilityElement = accessibilityElement;
        myWindowRect = windowRect;
    }
    
    return self;
}

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (ZKAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect {
    return [[SpectacleHistoryItem alloc] initWithAccessibilityElement: accessibilityElement windowRect: windowRect];
}

#pragma mark -

- (ZKAccessibilityElement *)accessibilityElement {
    return myAccessibilityElement;
}

#pragma mark -

- (CGRect)windowRect {
    return myWindowRect;
}

@end
