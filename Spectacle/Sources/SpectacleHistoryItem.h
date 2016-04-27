#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"

@class SpectacleAccessibilityElement;

@interface SpectacleHistoryItem : NSObject

@property (nonatomic) SpectacleAccessibilityElement *accessibilityElement;
@property (nonatomic) CGRect windowRect;
@property (nonatomic) SpectacleHistoryItem *nextHistoryItem;
@property (nonatomic) SpectacleHistoryItem *previousHistoryItem;

- (instancetype)initWithAccessibilityElement:(SpectacleAccessibilityElement *)accessibilityElement
                                  windowRect:(CGRect)windowRect NS_DESIGNATED_INITIALIZER;

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement:(SpectacleAccessibilityElement *)accessibilityElement
                                                   windowRect:(CGRect)windowRect;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

@end
