#import <Cocoa/Cocoa.h>

#import "SpectacleWindowAction.h"

@class SpectacleAccessibilityElement;
@class SpectacleScreenDetectionResult;

@interface SpectacleScreenDetector : NSObject

- (SpectacleScreenDetectionResult *)screenWithAction:(SpectacleWindowAction *)action
                              frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                                             screens:(NSArray<NSScreen *> *)screens
                                          mainScreen:(NSScreen *)mainScreen;

@end
