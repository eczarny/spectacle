#import "SpectacleAccessibilityElement.h"
#import "SpectacleStandardWindowMover.h"

@implementation SpectacleStandardWindowMover
{
  id<SpectacleWindowMoverProtocol> _innerWindowMover;
}

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover
{
  if (self = [super init]) {
    _innerWindowMover = innerWindowMover;
  }

  return self;
}

- (instancetype)init
{
  return [self initWithInnerWindowMover:nil];
}

+ (instancetype)newWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover
{
  return [[self alloc] initWithInnerWindowMover:innerWindowMover];
}

#pragma mark -

- (void)moveWindowRect:(CGRect)windowRect
         frameOfScreen:(CGRect)frameOfScreen
  visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                action:(SpectacleWindowAction)action
{
  CGRect previousWindowRect = [frontmostWindowElement rectOfElementWithFrameOfScreen:frameOfScreen];

  if (CGRectIsNull(previousWindowRect)) {
    return;
  }

  [frontmostWindowElement setRectOfElement:windowRect frameOfScreen:frameOfScreen];

  [_innerWindowMover moveWindowRect:windowRect
                      frameOfScreen:frameOfScreen
               visibleFrameOfScreen:visibleFrameOfScreen
             frontmostWindowElement:frontmostWindowElement
                             action:action];

  CGRect movedWindowRect = [frontmostWindowElement rectOfElementWithFrameOfScreen:frameOfScreen];

  if (MovingToThirdOfDisplay(action) && !CGRectContainsRect(windowRect, movedWindowRect)) {
    [frontmostWindowElement setRectOfElement:previousWindowRect frameOfScreen:frameOfScreen];
  }
}

@end
