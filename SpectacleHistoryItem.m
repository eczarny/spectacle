#import "SpectacleHistoryItem.h"

@implementation SpectacleHistoryItem

- (id)initWithAccessibilityElement: (ZKAccessibilityElement *)anAccessibilityElement windowRect: (CGRect)aWindowRect {
    if (self = [super init]) {
        accessibilityElement = anAccessibilityElement;
        windowRect = aWindowRect;
        nextHistoryItem = nil;
        previousHistoryItem = nil;
    }
    
    return self;
}

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (ZKAccessibilityElement *)anAccessibilityElement windowRect: (CGRect)aWindowRect {
    return [[SpectacleHistoryItem alloc] initWithAccessibilityElement: anAccessibilityElement windowRect: aWindowRect];
}

#pragma mark -

- (ZKAccessibilityElement *)accessibilityElement {
    return accessibilityElement;
}

#pragma mark -

- (CGRect)windowRect {
    return windowRect;
}

#pragma mark -

- (SpectacleHistoryItem *)nextHistoryItem {
    return nextHistoryItem;
}

- (void)setNextHistoryItem: (SpectacleHistoryItem *)historyItem {
    nextHistoryItem = historyItem;
}

#pragma mark -

- (SpectacleHistoryItem *)previousHistoryItem {
    return previousHistoryItem;
}

- (void)setPreviousHistoryItem: (SpectacleHistoryItem *)historyItem {
    previousHistoryItem = historyItem;
}

@end
