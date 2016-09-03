#import "SpectacleQuantizedWindowMover.h"

#import "SpectacleAccessibilityElement.h"

@implementation SpectacleQuantizedWindowMover
{
  id<SpectacleWindowMover> _innerWindowMover;
}

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMover>)innerWindowMover
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

+ (instancetype)newWithInnerWindowMover:(id<SpectacleWindowMover>)innerWindowMover
{
  return [[self alloc] initWithInnerWindowMover:innerWindowMover];
}

- (void)moveWindowRect:(CGRect)windowRect
         frameOfScreen:(CGRect)frameOfScreen
  visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                action:(SpectacleWindowAction *)action
{
  CGRect movedWindowRect = [frontmostWindowElement rectOfElement];
  if (!CGRectEqualToRect(movedWindowRect, windowRect)) {
    CGRect adjustedWindowRect = windowRect;
    while (movedWindowRect.size.width > windowRect.size.width || movedWindowRect.size.height > windowRect.size.height) {
      if (movedWindowRect.size.width > windowRect.size.width) {
        adjustedWindowRect.size.width -= 2;
      }
      if (movedWindowRect.size.height > windowRect.size.height) {
        adjustedWindowRect.size.height -= 2;
      }
      if (adjustedWindowRect.size.width < windowRect.size.width * 0.85f || adjustedWindowRect.size.height < windowRect.size.height * 0.85f) {
        break;
      }
      [frontmostWindowElement setRectOfElement:adjustedWindowRect];
      movedWindowRect = [frontmostWindowElement rectOfElement];
    }
    adjustedWindowRect.origin.x += floor((windowRect.size.width - movedWindowRect.size.width) / 2.0f);
    adjustedWindowRect.origin.y += floor((windowRect.size.height - movedWindowRect.size.height) / 2.0f);
    [frontmostWindowElement setRectOfElement:adjustedWindowRect];
  }
  [_innerWindowMover moveWindowRect:windowRect
                      frameOfScreen:frameOfScreen
               visibleFrameOfScreen:visibleFrameOfScreen
             frontmostWindowElement:frontmostWindowElement
                             action:action];
}

@end
