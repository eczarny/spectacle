#import <Foundation/Foundation.h>

#import "SpectacleWindowPositionManager.h"

@class SpectacleWindowPositionCalculationResult;

@interface SpectacleWindowPositionCalculator : NSObject

- (SpectacleWindowPositionCalculationResult *)calculateWindowRect:(CGRect)windowRect
                                             visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
                                                           action:(SpectacleWindowAction)action;

@end
