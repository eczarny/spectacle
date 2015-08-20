#import <Cocoa/Cocoa.h>

#import "SpectacleWindowPositionManager.h"

@interface SpectacleScreenDetection : NSObject

+ (NSScreen *)screenWithAction:(SpectacleWindowAction)action
                       andRect:(CGRect)rect
                       screens:(NSArray *)screens
                    mainScreen:(NSScreen *)mainScreen;

@end
