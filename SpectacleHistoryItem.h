#import <Foundation/Foundation.h>
#import <ZeroKit/ZeroKit.h>

@interface SpectacleHistoryItem : NSObject {
    ZKAccessibilityElement *accessibilityElement;
    CGRect windowRect;
}

- (id)initWithAccessibilityElement: (ZKAccessibilityElement *)anAccessibilityElement windowRect: (CGRect)aWindowRect;

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (ZKAccessibilityElement *)anAccessibilityElement windowRect: (CGRect)aWindowRect;

#pragma mark -

- (ZKAccessibilityElement *)accessibilityElement;

#pragma mark -

- (CGRect)windowRect;

@end
