#import <Foundation/Foundation.h>

#import "SpectacleWindowAction.h"

@class SpectacleAccessibilityElement;

@protocol SpectacleWindowMoverProtocol <NSObject>

- (CGRect)moveWindowRect:(CGRect)windowRect
           frameOfScreen:(CGRect)frameOfScreen
    visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
  frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                  action:(SpectacleWindowAction)action;

@end
