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

@implementation SpectacleWindowPositionManager
{
  NSMutableDictionary<NSString *, SpectacleHistory *> *_applicationHistories;
  SpectacleScreenDetector *_screenDetector;
  SpectacleWindowPositionCalculator *_windowPositionCalculator;
  NSWorkspace *_sharedWorkspace;
  SpectacleFailureFeedback _failureFeedback;
  id<SpectacleWindowMover> _windowMover;
}

- (instancetype)initWithScreenDetector:(SpectacleScreenDetector *)screenDetector
              windowPositionCalculator:(SpectacleWindowPositionCalculator *)windowPositionCalculator
                       sharedWorkspace:(NSWorkspace *)sharedWorkspace
                       failureFeedback:(SpectacleFailureFeedback)failureFeedback
                           windowMover:(id<SpectacleWindowMover>)windowMover
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

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction *)action
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
  if (SpectacleIsMovingToDisplayWindowAction(action) && RectFitsInRect(frontmostWindowRect, visibleFrameOfScreen)) {
    action = kSpectacleWindowActionCenter;
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
                            action:(SpectacleWindowAction *)action
{
  if (SpectacleIsUndoWindowAction(action)) {
    [self undoLastWindowAction];
  } else if (SpectacleIsRedoWindowAction(action)) {
    [self redoLastWindowAction];
  } else {
    [self moveFrontmostWindowElement:frontmostWindowElement
                              action:action
                             screens:[NSScreen screens]
                          mainScreen:[NSScreen mainScreen]];
  }
}

- (void)undoLastWindowAction
{
  [self moveWithHistoryItem:[self historyForCurrentApplication].previousHistoryItem
                     action:kSpectacleWindowActionUndo
                    screens:[NSScreen screens]
                 mainScreen:[NSScreen mainScreen]];
}

- (void)redoLastWindowAction
{
  [self moveWithHistoryItem:[self historyForCurrentApplication].nextHistoryItem
                     action:kSpectacleWindowActionRedo
                    screens:[NSScreen screens]
                 mainScreen:[NSScreen mainScreen]];
}

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

- (void)moveWithHistoryItem:(SpectacleHistoryItem *)historyItem
                     action:(SpectacleWindowAction *)action
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
                     action:(SpectacleWindowAction *)action
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
