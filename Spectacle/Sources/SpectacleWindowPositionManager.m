#import "SpectacleWindowPositionManager.h"

#import "SpectacleAccessibilityElement.h"
#import "SpectacleBestEffortWindowMover.h"
#import "SpectacleHistory.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleQuantizedWindowMover.h"
#import "SpectacleScreenDetectionResult.h"
#import "SpectacleScreenDetector.h"
#import "SpectacleShortcut.h"
#import "SpectacleStandardWindowMover.h"
#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"

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
  SpectacleScreenDetectionResult *screenDetectionResult = [_screenDetector screenWithAction:action
                                                                     frontmostWindowElement:frontmostWindowElement
                                                                                    screens:screens
                                                                                 mainScreen:mainScreen];
  CGRect frameOfDestinationScreen = CGRectNull;
  CGRect visibleFrameOfDestinationScreen = CGRectNull;
  CGRect visibleFrameOfSourceScreen = CGRectNull;
  SpectacleHistory *history = [self historyForCurrentApplication];
  SpectacleHistoryItem *historyItem = nil;
  SpectacleWindowPositionCalculationResult *windowPositionCalculationResult = nil;
  if (screenDetectionResult.destinationScreen && screenDetectionResult.sourceScreen) {
    frameOfDestinationScreen = NSRectToCGRect([screenDetectionResult.destinationScreen frame]);
    visibleFrameOfDestinationScreen = NSRectToCGRect([screenDetectionResult.destinationScreen visibleFrame]);
    visibleFrameOfSourceScreen = NSRectToCGRect([screenDetectionResult.sourceScreen visibleFrame]);
      
//      if (visibleFrameOfSourceScreen.origin.x == 0 && visibleFrameOfSourceScreen.origin.y == 0) {
//          visibleFrameOfSourceScreen.size.height += 5;
//          NSLog(@"Something To Print");
//    }
      
//      NSLog(@".......");

    if (CoreDockGetAutoHideEnabled()) {
      CGFloat totalWidth = 0.0f;

      for (id screen in screens) {
        totalWidth += ((NSScreen*)screen).frame.size.width;
      }

      void (^removeGapFromLeft)(CGRect *) = ^(CGRect* r) {
        if (r->origin.x == 4) {
          r->size.width += r->origin.x;
          r->origin.x = 0;
        } else if (totalWidth - (r->origin.x + r->size.width) == 4) {
          r->size.width += 4;
        }
        
        else if (r->origin.x == 0 && r->origin.y == 4) {
            r->size.height += 4;
            NSLog(@"consider it done");
        }
          
        else {
//            NSLog(@"%g", r->origin.x);
            NSLog(@"%g", r->origin.y);
        }
      };

      removeGapFromLeft(&visibleFrameOfDestinationScreen);
      removeGapFromLeft(&visibleFrameOfSourceScreen);
    }
  }

  CGRect frontmostWindowRect = [frontmostWindowElement rectOfElement];
  CGRect previousFrontmostWindowRect = CGRectNull;
  if ([frontmostWindowElement isSheet]
      || [frontmostWindowElement isSystemDialog]
      || CGRectIsNull(frontmostWindowRect)
      || CGRectIsNull(frameOfDestinationScreen)
      || CGRectIsNull(visibleFrameOfDestinationScreen)
      || CGRectIsNull(visibleFrameOfSourceScreen)) {
    _failureFeedback();
    return;
  }
  if ([history isEmpty]) {
    historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement:frontmostWindowElement
                                                                 windowRect:frontmostWindowRect];
    [history addHistoryItem:historyItem];
  }
  frontmostWindowRect = [SpectacleAccessibilityElement normalizeCoordinatesOfRect:frontmostWindowRect
                                                                    frameOfScreen:frameOfDestinationScreen];
  previousFrontmostWindowRect = frontmostWindowRect;
  windowPositionCalculationResult = [_windowPositionCalculator calculateWindowRect:frontmostWindowRect
                                                        visibleFrameOfSourceScreen:visibleFrameOfSourceScreen
                                                   visibleFrameOfDestinationScreen:visibleFrameOfDestinationScreen
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
                                                                    frameOfScreen:frameOfDestinationScreen];
  historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement:frontmostWindowElement
                                                               windowRect:frontmostWindowRect];
  [history addHistoryItem:historyItem];
  [_windowMover moveWindowRect:frontmostWindowRect
                 frameOfScreen:frameOfDestinationScreen
          visibleFrameOfScreen:visibleFrameOfDestinationScreen
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
    NSArray * screens = [NSScreen screens];
      CoreDockOrientation orienation = 0;
      CoreDockPinning pinning = 0;

    if (CoreDockGetAutoHideEnabled()) {
        CoreDockGetOrientationAndPinning(&orienation, &pinning);
        if (orienation != kCoreDockOrientationLeft) {
            CoreDockSetOrientationAndPinning(kCoreDockOrientationLeft, pinning);
        }

    }

    [self moveFrontmostWindowElement:frontmostWindowElement
                              action:action
                             screens:screens
                          mainScreen:[NSScreen mainScreen]];

      if (orienation && orienation != kCoreDockOrientationLeft) {
          CoreDockSetOrientationAndPinning(orienation, pinning);
      }
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
  SpectacleScreenDetectionResult *screenDetectionResult = [_screenDetector screenWithAction:action
                                                                     frontmostWindowElement:historyItem.accessibilityElement
                                                                                    screens:screens
                                                                                 mainScreen:mainScreen];
  CGRect visibleFrameOfScreen = CGRectNull;
  if (screenDetectionResult.destinationScreen) {
    visibleFrameOfScreen = NSRectToCGRect(screenDetectionResult.destinationScreen.visibleFrame);
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
