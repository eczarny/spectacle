#import <Foundation/Foundation.h>

@class ZKAccessibilityElement;

@interface SpectacleHistoryItem : NSObject

@property (nonatomic) ZKAccessibilityElement *accessibilityElement;
@property (nonatomic) CGRect windowRect;
@property (nonatomic) SpectacleHistoryItem *nextHistoryItem;
@property (nonatomic) SpectacleHistoryItem *previousHistoryItem;

#pragma mark -

- (id)initWithAccessibilityElement: (ZKAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect;

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (ZKAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect;

@end
