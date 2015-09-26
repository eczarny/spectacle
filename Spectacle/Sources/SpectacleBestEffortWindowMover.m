#import "SpectacleAccessibilityElement.h"
#import "SpectacleBestEffortWindowMover.h"

@implementation SpectacleBestEffortWindowMover
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
  [_innerWindowMover moveWindowRect:windowRect
                      frameOfScreen:frameOfScreen
               visibleFrameOfScreen:visibleFrameOfScreen
             frontmostWindowElement:frontmostWindowElement
                             action:action];

  CGRect movedWindowRect = [frontmostWindowElement rectOfElementWithFrameOfScreen:frameOfScreen];

  CGRect previouslyMovedWindowRect = movedWindowRect;

  if (movedWindowRect.origin.x < visibleFrameOfScreen.origin.x) {
    movedWindowRect.origin.x = visibleFrameOfScreen.origin.x;
  } else if ((movedWindowRect.origin.x + movedWindowRect.size.width) > (visibleFrameOfScreen.origin.x + visibleFrameOfScreen.size.width)) {
    movedWindowRect.origin.x = visibleFrameOfScreen.origin.x + visibleFrameOfScreen.size.width - movedWindowRect.size.width;
  }

  if (movedWindowRect.origin.y < visibleFrameOfScreen.origin.y) {
    movedWindowRect.origin.y = visibleFrameOfScreen.origin.y;
  } else if ((movedWindowRect.origin.y + movedWindowRect.size.height) > (visibleFrameOfScreen.origin.y + visibleFrameOfScreen.size.height)) {
    movedWindowRect.origin.y = visibleFrameOfScreen.origin.y + visibleFrameOfScreen.size.height - movedWindowRect.size.height;
  }

  if (!CGRectEqualToRect(movedWindowRect, previouslyMovedWindowRect)) {
    [frontmostWindowElement setRectOfElement:movedWindowRect frameOfScreen:frameOfScreen];
  }
}

@end
