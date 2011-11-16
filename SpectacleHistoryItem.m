#import "SpectacleHistoryItem.h"

@implementation SpectacleHistoryItem

- (id)initWithAccessibilityElement: (SpectacleAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect {
    if (self = [super init]) {
        myAccessibilityElement = [accessibilityElement retain];
        myWindowRect = windowRect;
    }
    
    return self;
}

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (SpectacleAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect {
    return [[[SpectacleHistoryItem alloc] initWithAccessibilityElement: accessibilityElement windowRect: windowRect] autorelease];
}

#pragma mark -

- (SpectacleAccessibilityElement *)accessibilityElement {
    return myAccessibilityElement;
}

- (void)setAccessibilityElement: (SpectacleAccessibilityElement *)accessibilityElement {
    if (myAccessibilityElement != accessibilityElement) {
        [myAccessibilityElement release];
        
        myAccessibilityElement = [accessibilityElement retain];
    }
}

#pragma mark -

- (CGRect)windowRect {
    return myWindowRect;
}

- (void)setWindowRect: (CGRect)windowRect {
    myWindowRect = windowRect;
}

#pragma mark -

- (void)dealloc {
    [myAccessibilityElement release];
    
    [super dealloc];
}

@end
