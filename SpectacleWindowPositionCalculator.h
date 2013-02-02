#import <Foundation/Foundation.h>
#import "SpectacleWindowPositionManager.h"

@interface SpectacleWindowPositionCalculator : NSObject

+ (CGRect)calculateWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen action: (SpectacleWindowAction)action;

+ (CGRect)calculateCenteredWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen percentage: (CGFloat)percentage;

@end
