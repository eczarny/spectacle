#import <Foundation/Foundation.h>

@class SpectacleAccessibilityElement;

@interface SpectacleHistoryItem : NSObject

@property (nonatomic) SpectacleAccessibilityElement *accessibilityElement;
@property (nonatomic) CGRect windowRect;
@property (nonatomic) SpectacleHistoryItem *nextHistoryItem;
@property (nonatomic) SpectacleHistoryItem *previousHistoryItem;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAccessibilityElement:(SpectacleAccessibilityElement *)accessibilityElement
                                  windowRect:(CGRect)windowRect NS_DESIGNATED_INITIALIZER;

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement:(SpectacleAccessibilityElement *)accessibilityElement
                                                   windowRect:(CGRect)windowRect;

@end
