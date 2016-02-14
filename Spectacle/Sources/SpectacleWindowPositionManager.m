#import "SpectacleAccessibilityElement.h"
#import "SpectacleBestEffortWindowMover.h"
#import "SpectacleHistory.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleQuantizedWindowMover.h"
#import "SpectacleScreenDetector.h"
#import "SpectacleShortcut.h"
#import "SpectacleStandardWindowMover.h"
#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleWindowPositionManager.h"

#define RectFitsInRect(a, b) ((a.size.width <= b.size.width) && (a.size.height <= b.size.height))

#pragma mark -

#define Resizing(action) ((action == SpectacleWindowActionLarger) || (action == SpectacleWindowActionSmaller))
#define UndoOrRedo(action) ((action == SpectacleWindowActionUndo) || (action == SpectacleWindowActionRedo))

#pragma mark -

@implementation SpectacleWindowPositionManager
{
  NSMutableDictionary<NSString *, SpectacleHistory *> *_applicationHistories;
  SpectacleScreenDetector *_screenDetector;
  SpectacleWindowPositionCalculator *_windowPositionCalculator;
  NSWorkspace *_sharedWorkspace;
  SpectacleFailureFeedback _failureFeedback;
  id<SpectacleWindowMoverProtocol> _windowMover;
}

- (instancetype)initWithScreenDetector:(SpectacleScreenDetector *)screenDetector
              windowPositionCalculator:(SpectacleWindowPositionCalculator *)windowPositionCalculator
                       sharedWorkspace:(NSWorkspace *)sharedWorkspace
                       failureFeedback:(SpectacleFailureFeedback)failureFeedback
                           windowMover:(id<SpectacleWindowMoverProtocol>)windowMover
{
  if (self = [super init]) {
    _applicationHistories = [NSMutableDictionary new];
    _screenDetector = screenDetector;
    _windowPositionCalculator = windowPositionCalculator;
    _sharedWorkspace = sharedWorkspace;
    _failureFeedback = failureFeedback;
    _windowMover = windowMover;
  }

  return self;
}

- (instancetype)initWithScreenDetector:(SpectacleScreenDetector *)screenDetector
              windowPositionCalculator:(SpectacleWindowPositionCalculator *)windowPositionCalculator
                       sharedWorkspace:(NSWorkspace *)sharedWorkspace
{
  return [self initWithScreenDetector:screenDetector
             windowPositionCalculator:windowPositionCalculator
                      sharedWorkspace:sharedWorkspace
                      failureFeedback:^() { NSBeep(); }
                          windowMover:[SpectacleStandardWindowMover newWithInnerWindowMover:
                                       [SpectacleQuantizedWindowMover newWithInnerWindowMover:
                                        [SpectacleBestEffortWindowMover new]]]];
}

#pragma mark -

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction)action
                           screens:(NSArray<NSScreen *> *)screens
                        mainScreen:(NSScreen *)mainScreen
{
  NSScreen *screenOfDisplay = [_screenDetector screenWithAction:action
                                         frontmostWindowElement:frontmostWindowElement
                                                        screens:screens
                                                     mainScreen:mainScreen];

  CGRect frameOfScreen = CGRectNull;
  CGRect visibleFrameOfScreen = CGRectNull;
  SpectacleHistory *history = [self historyForCurrentApplication];
  SpectacleHistoryItem *historyItem = nil;
  SpectacleWindowPositionCalculationResult *windowPositionCalculationResult = nil;

  if (screenOfDisplay) {
    frameOfScreen = NSRectToCGRect([screenOfDisplay frame]);
    visibleFrameOfScreen = NSRectToCGRect([screenOfDisplay visibleFrame]);
  }

  CGRect frontmostWindowRect = [frontmostWindowElement rectOfElement];
  CGRect previousFrontmostWindowRect = CGRectNull;

  if ([frontmostWindowElement isSheet]
      || [frontmostWindowElement isSystemDialog]
      || CGRectIsNull(frontmostWindowRect)
      || CGRectIsNull(frameOfScreen)
      || CGRectIsNull(visibleFrameOfScreen)) {
    _failureFeedback();

    return;
  }

  if ([history isEmpty]) {
    historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement:frontmostWindowElement
                                                                 windowRect:frontmostWindowRect];

    [history addHistoryItem:historyItem];
  }

  frontmostWindowRect = [SpectacleAccessibilityElement normalizeCoordinatesOfRect:frontmostWindowRect
                                                                    frameOfScreen:frameOfScreen];

  if (MovingToNextOrPreviousDisplay(action) && RectFitsInRect(frontmostWindowRect, visibleFrameOfScreen)) {
    action = SpectacleWindowActionCenter;
  }

  previousFrontmostWindowRect = frontmostWindowRect;

  windowPositionCalculationResult = [_windowPositionCalculator calculateWindowRect:frontmostWindowRect
                                                              visibleFrameOfScreen:visibleFrameOfScreen
                                                                            action:action];

  if (!windowPositionCalculationResult) {
    _failureFeedback();

    return;
  }

  action = windowPositionCalculationResult.action;
  frontmostWindowRect = windowPositionCalculationResult.windowRect;

  if (CGRectEqualToRect(previousFrontmostWindowRect, frontmostWindowRect)) {
    _failureFeedback();

    return;
  }

  frontmostWindowRect = [SpectacleAccessibilityElement normalizeCoordinatesOfRect:frontmostWindowRect
                                                                    frameOfScreen:frameOfScreen];

  historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement:frontmostWindowElement
                                                               windowRect:frontmostWindowRect];

  [history addHistoryItem:historyItem];

  [_windowMover moveWindowRect:frontmostWindowRect
                 frameOfScreen:frameOfScreen
          visibleFrameOfScreen:visibleFrameOfScreen
        frontmostWindowElement:frontmostWindowElement
                        action:action];
}

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction)action
{
  if (action == SpectacleWindowActionUndo) {
    [self undoLastWindowAction];
  } else if (action == SpectacleWindowActionRedo) {
    [self redoLastWindowAction];
  } else {
    [self moveFrontmostWindowElement:frontmostWindowElement
                              action:action
                             screens:[NSScreen screens]
                          mainScreen:[NSScreen mainScreen]];
  }
}

#pragma mark -

- (void)undoLastWindowAction
{
  [self moveWithHistoryItem:[self historyForCurrentApplication].previousHistoryItem
                     action:SpectacleWindowActionUndo
                    screens:[NSScreen screens]
                 mainScreen:[NSScreen mainScreen]];
}

- (void)redoLastWindowAction
{
  [self moveWithHistoryItem:[self historyForCurrentApplication].nextHistoryItem
                     action:SpectacleWindowActionRedo
                    screens:[NSScreen screens]
                 mainScreen:[NSScreen mainScreen]];
}

#pragma mark -

- (SpectacleWindowAction)windowActionForShortcut:(SpectacleShortcut *)shortcut
{
  NSString *name = shortcut.shortcutName;
  SpectacleWindowAction windowAction = SpectacleWindowActionNone;

  if ([name isEqualToString:@"MoveToCenter"]) {
    windowAction = SpectacleWindowActionCenter;
  } else if ([name isEqualToString:@"MoveToFullscreen"]) {
    windowAction = SpectacleWindowActionFullscreen;
  } else if ([name isEqualToString:@"MoveToLeftHalf"]) {
    windowAction = SpectacleWindowActionLeftHalf;
  } else if ([name isEqualToString:@"MoveToRightHalf"]) {
    windowAction = SpectacleWindowActionRightHalf;
  } else if ([name isEqualToString:@"MoveToTopHalf"]) {
    windowAction = SpectacleWindowActionTopHalf;
  } else if ([name isEqualToString:@"MoveToBottomHalf"]) {
    windowAction = SpectacleWindowActionBottomHalf;
  } else if ([name isEqualToString:@"MoveToUpperLeft"]) {
    windowAction = SpectacleWindowActionUpperLeft;
  } else if ([name isEqualToString:@"MoveToLowerLeft"]) {
    windowAction = SpectacleWindowActionLowerLeft;
  } else if ([name isEqualToString:@"MoveToUpperRight"]) {
    windowAction = SpectacleWindowActionUpperRight;
  } else if ([name isEqualToString:@"MoveToLowerRight"]) {
    windowAction = SpectacleWindowActionLowerRight;
  } else if ([name isEqualToString:@"MoveToNextDisplay"]) {
    windowAction = SpectacleWindowActionNextDisplay;
  } else if ([name isEqualToString:@"MoveToPreviousDisplay"]) {
    windowAction = SpectacleWindowActionPreviousDisplay;
  } else if ([name isEqualToString:@"MoveToNextThird"]) {
    windowAction = SpectacleWindowActionNextThird;
  } else if ([name isEqualToString:@"MoveToPreviousThird"]) {
    windowAction = SpectacleWindowActionPreviousThird;
  } else if ([name isEqualToString:@"MakeLarger"]) {
    windowAction = SpectacleWindowActionLarger;
  } else if ([name isEqualToString:@"MakeSmaller"]) {
    windowAction = SpectacleWindowActionSmaller;
  } else if ([name isEqualToString:@"UndoLastMove"]) {
    windowAction = SpectacleWindowActionUndo;
  } else if ([name isEqualToString:@"RedoLastMove"]) {
    windowAction = SpectacleWindowActionRedo;
  }

  return windowAction;
}

#pragma mark -

- (SpectacleHistory *)historyForCurrentApplication
{
  NSString *frontmostApplicationBundleIdentifier = _sharedWorkspace.frontmostApplication.bundleIdentifier;

  if (!frontmostApplicationBundleIdentifier) {
    return nil;
  }

  if (!_applicationHistories[frontmostApplicationBundleIdentifier]) {
    _applicationHistories[frontmostApplicationBundleIdentifier] = [SpectacleHistory new];
  }

  return _applicationHistories[frontmostApplicationBundleIdentifier];
}

#pragma mark -

- (void)moveWithHistoryItem:(SpectacleHistoryItem *)historyItem
                     action:(SpectacleWindowAction)action
                    screens:(NSArray<NSScreen *> *)screens
                 mainScreen:(NSScreen *)mainScreen
{
  NSScreen *screenOfDisplay = [_screenDetector screenWithAction:action
                                         frontmostWindowElement:historyItem.accessibilityElement
                                                        screens:screens
                                                     mainScreen:mainScreen];

  CGRect visibleFrameOfScreen = CGRectNull;

  if (screenOfDisplay) {
    visibleFrameOfScreen = NSRectToCGRect(screenOfDisplay.visibleFrame);
  }

  if (![self moveWithHistoryItem:historyItem visibleFrameOfScreen:visibleFrameOfScreen action:action]) {
    _failureFeedback();
  }
}

- (BOOL)moveWithHistoryItem:(SpectacleHistoryItem *)historyItem
       visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
                     action:(SpectacleWindowAction)action
{
  SpectacleAccessibilityElement *frontmostWindowElement = historyItem.accessibilityElement;
  CGRect windowRect = historyItem.windowRect;

  if (!historyItem
      || !frontmostWindowElement
      || CGRectIsNull(windowRect)
      || CGRectIsNull(visibleFrameOfScreen)) {
    return NO;
  }

  [_windowMover moveWindowRect:windowRect
                 frameOfScreen:CGRectNull
          visibleFrameOfScreen:visibleFrameOfScreen
        frontmostWindowElement:frontmostWindowElement
                        action:action];

  return YES;
}

@end
