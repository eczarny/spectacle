#import "SpectacleAccessibilityElement.h"
#import "SpectacleNOOPWindowMover.h"

@implementation SpectacleNOOPWindowMover

- (CGRect)moveWindowRect:(CGRect)windowRect
           frameOfScreen:(CGRect)frameOfScreen
    visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
  frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                  action:(SpectacleWindowAction)action
{
  return [frontmostWindowElement rectOfElementWithFrameOfScreen:frameOfScreen];
}

@end
