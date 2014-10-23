#import <Foundation/Foundation.h>
#import "SpectacleWindowPositionManager.h"

@interface SpectacleScreenDetection : NSObject

+ (NSScreen *)screenWithAction: (SpectacleWindowAction)action andRect: (CGRect)rect;

@end
