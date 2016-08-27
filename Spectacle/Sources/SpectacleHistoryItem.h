#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"

@class SpectacleAccessibilityElement;

@interface SpectacleHistoryItem : NSObject

@property (nonatomic, strong) SpectacleAccessibilityElement *accessibilityElement;
@property (nonatomic, assign) CGRect windowRect;
@property (nonatomic, strong) SpectacleHistoryItem *nextHistoryItem;
@property (nonatomic, weak) SpectacleHistoryItem *previousHistoryItem;

- (instancetype)initWithAccessibilityElement:(SpectacleAccessibilityElement *)accessibilityElement
                                  windowRect:(CGRect)windowRect NS_DESIGNATED_INITIALIZER;

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement:(SpectacleAccessibilityElement *)accessibilityElement
                                                   windowRect:(CGRect)windowRect;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

@end
