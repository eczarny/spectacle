#import <Foundation/Foundation.h>
#import "SpectacleWindowPositionManager.h"
#import "SpectacleUtilities.h"

@interface SpectacleWindowPositionCalculator : NSObject

+ (CGRect)calculateWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen action: (SpectacleWindowAction)action;

+ (CGRect)calculateResizedWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen sizeOffset: (CGFloat)sizeOffset;

@end
