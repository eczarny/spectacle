#import <Foundation/Foundation.h>

#import "SpectacleWindowMoverProtocol.h"

@interface SpectacleQuantizedWindowMover : NSObject<SpectacleWindowMoverProtocol>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover NS_DESIGNATED_INITIALIZER;

+ (instancetype)newWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover;

#pragma mark -

- (CGRect)moveWindowRect:(CGRect)windowRect
           frameOfScreen:(CGRect)frameOfScreen
    visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
  frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                  action:(SpectacleWindowAction)action;

@end
