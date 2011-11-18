#import <Cocoa/Cocoa.h>

@class ZeroKitAccessibilityElement;

@interface SpectacleHistoryItem : NSObject {
    ZeroKitAccessibilityElement *myAccessibilityElement;
    CGRect myWindowRect;
}

- (id)initWithAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect;

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect;

#pragma mark -

- (ZeroKitAccessibilityElement *)accessibilityElement;

- (void)setAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement;

#pragma mark -

- (CGRect)windowRect;

- (void)setWindowRect: (CGRect)windowRect;

@end
