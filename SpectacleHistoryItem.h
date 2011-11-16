#import <Cocoa/Cocoa.h>

@class SpectacleAccessibilityElement;

@interface SpectacleHistoryItem : NSObject {
    SpectacleAccessibilityElement *myAccessibilityElement;
    CGRect myWindowRect;
}

- (id)initWithAccessibilityElement: (SpectacleAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect;

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (SpectacleAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect;

#pragma mark -

- (SpectacleAccessibilityElement *)accessibilityElement;

- (void)setAccessibilityElement: (SpectacleAccessibilityElement *)accessibilityElement;

#pragma mark -

- (CGRect)windowRect;

- (void)setWindowRect: (CGRect)windowRect;

@end
