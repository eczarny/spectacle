#import "SpectacleHistoryItem.h"

@implementation SpectacleHistoryItem

- (id)initWithAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect {
    if (self = [super init]) {
        myAccessibilityElement = [accessibilityElement retain];
        myWindowRect = windowRect;
    }
    
    return self;
}

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect {
    return [[[SpectacleHistoryItem alloc] initWithAccessibilityElement: accessibilityElement windowRect: windowRect] autorelease];
}

#pragma mark -

- (ZeroKitAccessibilityElement *)accessibilityElement {
    return myAccessibilityElement;
}

- (void)setAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement {
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
