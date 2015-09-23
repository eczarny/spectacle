#import <Foundation/Foundation.h>

#import "SpectacleWindowMoverProtocol.h"

@interface SpectacleNOOPWindowMover : NSObject<SpectacleWindowMoverProtocol>

- (CGRect)moveWindowRect:(CGRect)windowRect
           frameOfScreen:(CGRect)frameOfScreen
    visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
  frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                  action:(SpectacleWindowAction)action;

@end
