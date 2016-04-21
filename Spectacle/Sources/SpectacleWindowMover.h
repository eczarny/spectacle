#import <Foundation/Foundation.h>

#import "SpectacleWindowAction.h"

@class SpectacleAccessibilityElement;

@protocol SpectacleWindowMover <NSObject>

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMover>)innerWindowMover;

+ (instancetype)newWithInnerWindowMover:(id<SpectacleWindowMover>)innerWindowMover;

- (void)moveWindowRect:(CGRect)windowRect
         frameOfScreen:(CGRect)frameOfScreen
  visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                action:(SpectacleWindowAction *)action;

@end
