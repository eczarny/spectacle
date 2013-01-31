#import <Foundation/Foundation.h>
#import <ZeroKit/ZeroKit.h>

@interface SpectacleHistoryItem : NSObject {
    ZKAccessibilityElement *myAccessibilityElement;
    CGRect myWindowRect;
}

- (id)initWithAccessibilityElement: (ZKAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect;

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (ZKAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect;

#pragma mark -

- (ZKAccessibilityElement *)accessibilityElement;

#pragma mark -

- (CGRect)windowRect;

@end
