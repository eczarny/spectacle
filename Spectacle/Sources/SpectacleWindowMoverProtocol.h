#import <Foundation/Foundation.h>

#import "SpectacleWindowAction.h"

@class SpectacleAccessibilityElement;

@protocol SpectacleWindowMoverProtocol <NSObject>

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover;

+ (instancetype)newWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover;

- (void)moveWindowRect:(CGRect)windowRect
         frameOfScreen:(CGRect)frameOfScreen
  visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                action:(SpectacleWindowAction)action;

@end
