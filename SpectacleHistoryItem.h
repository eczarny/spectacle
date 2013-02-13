#import <Foundation/Foundation.h>
#import <ZeroKit/ZeroKit.h>

@interface SpectacleHistoryItem : NSObject {
    ZKAccessibilityElement *accessibilityElement;
    CGRect windowRect;
    SpectacleHistoryItem *nextHistoryItem;
    SpectacleHistoryItem *previousHistoryItem;
}

- (id)initWithAccessibilityElement: (ZKAccessibilityElement *)anAccessibilityElement windowRect: (CGRect)aWindowRect;

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (ZKAccessibilityElement *)anAccessibilityElement windowRect: (CGRect)aWindowRect;

#pragma mark -

- (ZKAccessibilityElement *)accessibilityElement;

#pragma mark -

- (CGRect)windowRect;

#pragma mark -

- (SpectacleHistoryItem *)nextHistoryItem;

- (void)setNextHistoryItem: (SpectacleHistoryItem *)historyItem;

#pragma mark -

- (SpectacleHistoryItem *)previousHistoryItem;

- (void)setPreviousHistoryItem: (SpectacleHistoryItem *)historyItem;

@end
