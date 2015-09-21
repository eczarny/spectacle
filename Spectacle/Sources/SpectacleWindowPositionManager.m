#import "SpectacleAccessibilityElement.h"
#import "SpectacleCalculationResult.h"
#import "SpectacleConstants.h"
#import "SpectacleHistory.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleScreenDetector.h"
#import "SpectacleShortcut.h"
#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleWindowPositionManager.h"

#define RectFitsInRect(a, b) ((a.size.width <= b.size.width) && (a.size.height <= b.size.height))

#pragma mark -

#define Resizing(action) ((action == SpectacleWindowActionLarger) || (action == SpectacleWindowActionSmaller))
#define UndoOrRedo(action) ((action == SpectacleWindowActionUndo) || (action == SpectacleWindowActionRedo))

#pragma mark -

@implementation SpectacleWindowPositionManager
{
  NSMutableDictionary *_applicationHistories;
  SpectacleScreenDetector *_screenDetection;
}

- (instancetype)initWithScreenDetection:(SpectacleScreenDetector *)screenDetection
{
  if (self = [super init]) {
    _applicationHistories = [NSMutableDictionary new];
    _screenDetection = screenDetection;
  }

  return self;
}

#pragma mark -

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction)action
{
  CGRect frontmostWindowRect = [frontmostWindowElement rectOfElement];
  CGRect previousFrontmostWindowRect = CGRectNull;

  NSScreen *screenOfDisplay = [_screenDetection screenWithAction:action
                                                         andRect:frontmostWindowRect
                                                         screens:NSScreen.screens
                                                      mainScreen:NSScreen.mainScreen];

  CGRect frameOfScreen = CGRectNull;
  CGRect visibleFrameOfScreen = CGRectNull;
  SpectacleHistory *history = self.historyForCurrentApplication;
  SpectacleHistoryItem *historyItem = nil;
  SpectacleCalculationResult *calculationResult = nil;

  if (screenOfDisplay) {
    frameOfScreen = NSRectToCGRect([screenOfDisplay frame]);
    visibleFrameOfScreen = NSRectToCGRect([screenOfDisplay visibleFrame]);
  }

  if (frontmostWindowElement.isSheet
      || frontmostWindowElement.isSystemDialog
      || CGRectIsNull(frontmostWindowRect)
      || CGRectIsNull(frameOfScreen)
      || CGRectIsNull(visibleFrameOfScreen)) {
    NSBeep();

    return;
  }

  if (UndoOrRedo(action)) {
    [self undoOrRedoHistoryWithAction:action];

    return;
  }

  if ([history isEmpty]) {
    historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement:frontmostWindowElement
                                                                 windowRect:frontmostWindowRect];

    [history addHistoryItem:historyItem];
  }

  frontmostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontmostWindowRect, frameOfScreen);

  if (MovingToNextOrPreviousDisplay(action) && RectFitsInRect(frontmostWindowRect, visibleFrameOfScreen)) {
    action = SpectacleWindowActionCenter;
  }

  previousFrontmostWindowRect = frontmostWindowRect;

  if (Resizing(action)) {
    CGFloat sizeOffset = ((action == SpectacleWindowActionLarger) ? 1.0 : -1.0) * kWindowSizeOffset;

    calculationResult = [SpectacleWindowPositionCalculator calculateResizedWindowRect:frontmostWindowRect
                                                                 visibleFrameOfScreen:visibleFrameOfScreen
                                                                           sizeOffset:sizeOffset
                                                                               action:action];
  } else {
    calculationResult = [SpectacleWindowPositionCalculator calculateWindowRect:frontmostWindowRect
                                                          visibleFrameOfScreen:visibleFrameOfScreen
                                                                        action:action];
  }

  action = calculationResult.action;
  frontmostWindowRect = calculationResult.windowRect;

  if (CGRectEqualToRect(previousFrontmostWindowRect, frontmostWindowRect)) {
    NSBeep();

    return;
  }

  frontmostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontmostWindowRect, frameOfScreen);

  historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement:frontmostWindowElement
                                                               windowRect:frontmostWindowRect];

  [history addHistoryItem:historyItem];

  [self moveWindowRect:frontmostWindowRect
         frameOfScreen:frameOfScreen
  visibleFrameOfScreen:visibleFrameOfScreen
frontmostWindowElement:frontmostWindowElement
                action:action];
}

#pragma mark -

- (void)undoLastWindowAction
{
  [self moveFrontmostWindowElement:[SpectacleAccessibilityElement frontmostWindowElement]
                            action:SpectacleWindowActionUndo];
}

- (void)redoLastWindowAction
{
  [self moveFrontmostWindowElement:[SpectacleAccessibilityElement frontmostWindowElement]
                            action:SpectacleWindowActionRedo];
}

#pragma mark -

- (SpectacleWindowAction)windowActionForShortcut:(SpectacleShortcut *)shortcut
{
  NSString *name = shortcut.shortcutName;
  SpectacleWindowAction windowAction = SpectacleWindowActionNone;

  if ([name isEqualToString:kWindowActionMoveToCenter]) {
    windowAction = SpectacleWindowActionCenter;
  } else if ([name isEqualToString:kWindowActionMoveToFullscreen]) {
    windowAction = SpectacleWindowActionFullscreen;
  } else if ([name isEqualToString:kWindowActionMoveToLeftHalf]) {
    windowAction = SpectacleWindowActionLeftHalf;
  } else if ([name isEqualToString:kWindowActionMoveToRightHalf]) {
    windowAction = SpectacleWindowActionRightHalf;
  } else if ([name isEqualToString:kWindowActionMoveToTopHalf]) {
    windowAction = SpectacleWindowActionTopHalf;
  } else if ([name isEqualToString:kWindowActionMoveToBottomHalf]) {
    windowAction = SpectacleWindowActionBottomHalf;
  } else if ([name isEqualToString:kWindowActionMoveToUpperLeft]) {
    windowAction = SpectacleWindowActionUpperLeft;
  } else if ([name isEqualToString:kWindowActionMoveToLowerLeft]) {
    windowAction = SpectacleWindowActionLowerLeft;
  } else if ([name isEqualToString:kWindowActionMoveToUpperRight]) {
    windowAction = SpectacleWindowActionUpperRight;
  } else if ([name isEqualToString:kWindowActionMoveToLowerRight]) {
    windowAction = SpectacleWindowActionLowerRight;
  } else if ([name isEqualToString:kWindowActionMoveToNextDisplay]) {
    windowAction = SpectacleWindowActionNextDisplay;
  } else if ([name isEqualToString:kWindowActionMoveToPreviousDisplay]) {
    windowAction = SpectacleWindowActionPreviousDisplay;
  } else if ([name isEqualToString:kWindowActionMoveToNextThird]) {
    windowAction = SpectacleWindowActionNextThird;
  } else if ([name isEqualToString:kWindowActionMoveToPreviousThird]) {
    windowAction = SpectacleWindowActionPreviousThird;
  } else if ([name isEqualToString:kWindowActionMakeLarger]) {
    windowAction = SpectacleWindowActionLarger;
  } else if ([name isEqualToString:kWindowActionMakeSmaller]) {
    windowAction = SpectacleWindowActionSmaller;
  } else if ([name isEqualToString:kWindowActionUndoLastMove]) {
    windowAction = SpectacleWindowActionUndo;
  } else if ([name isEqualToString:kWindowActionRedoLastMove]) {
    windowAction = SpectacleWindowActionRedo;
  }

  return windowAction;
}

#pragma mark -

- (void)moveWindowRect:(CGRect)windowRect
         frameOfScreen:(CGRect)frameOfScreen
  visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                action:(SpectacleWindowAction)action
{
  CGRect previousWindowRect = [frontmostWindowElement rectOfElement];

  if (CGRectIsNull(previousWindowRect)) {
    NSBeep();

    return;
  }

  [frontmostWindowElement setRectOfElement:windowRect];

  CGRect movedWindowRect = [frontmostWindowElement rectOfElement];

  if (!CGRectEqualToRect(movedWindowRect, windowRect)) {
    movedWindowRect = [self makeMovedWindowRect:movedWindowRect
                                  fitWindowRect:windowRect
                         frontmostWindowElement:frontmostWindowElement];
  }

  movedWindowRect = [self makeMovedWindowRect:movedWindowRect
                      fitVisibleFrameOfScreen:visibleFrameOfScreen
                                frameOfScreen:frameOfScreen
                       frontmostWindowElement:frontmostWindowElement];

  if (MovingToThirdOfDisplay(action) && !CGRectContainsRect(windowRect, movedWindowRect)) {
    NSBeep();

    [frontmostWindowElement setRectOfElement:previousWindowRect];
  }
}



- (CGRect)makeMovedWindowRect:(CGRect)movedWindowRect
                fitWindowRect:(CGRect)windowRect
       frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
{
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

  return [frontmostWindowElement rectOfElement];
}

- (CGRect)makeMovedWindowRect:(CGRect)movedWindowRect
      fitVisibleFrameOfScreen:(CGRect)visibleFrameOfScreen
                frameOfScreen:(CGRect)frameOfScreen
       frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
{
  CGRect previouslyMovedWindowRect = movedWindowRect;

  if (movedWindowRect.origin.x < visibleFrameOfScreen.origin.x) {
    movedWindowRect.origin.x = visibleFrameOfScreen.origin.x;
  } else if ((movedWindowRect.origin.x + movedWindowRect.size.width) > (visibleFrameOfScreen.origin.x + visibleFrameOfScreen.size.width)) {
    movedWindowRect.origin.x = visibleFrameOfScreen.origin.x + visibleFrameOfScreen.size.width - movedWindowRect.size.width;
  }

  movedWindowRect.origin.y = FlipVerticalOriginOfRectInRect(movedWindowRect, frameOfScreen);

  if (movedWindowRect.origin.y < visibleFrameOfScreen.origin.y) {
    movedWindowRect.origin.y = visibleFrameOfScreen.origin.y;
  } else if ((movedWindowRect.origin.y + movedWindowRect.size.height) > (visibleFrameOfScreen.origin.y + visibleFrameOfScreen.size.height)) {
    movedWindowRect.origin.y = visibleFrameOfScreen.origin.y + visibleFrameOfScreen.size.height - movedWindowRect.size.height;
  }

  movedWindowRect.origin.y = FlipVerticalOriginOfRectInRect(movedWindowRect, frameOfScreen);

  if (!CGRectEqualToRect(movedWindowRect, previouslyMovedWindowRect)) {
    [frontmostWindowElement setRectOfElement:movedWindowRect];

    movedWindowRect = [frontmostWindowElement rectOfElement];
  }

  return movedWindowRect;
}

#pragma mark -

- (SpectacleHistory *)historyForCurrentApplication
{
  NSString *frontmostApplicationBundleIdentifier = [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier;

  if (!frontmostApplicationBundleIdentifier) {
    return nil;
  }

  if (!_applicationHistories[frontmostApplicationBundleIdentifier]) {
    _applicationHistories[frontmostApplicationBundleIdentifier] = [SpectacleHistory new];
  }

  return _applicationHistories[frontmostApplicationBundleIdentifier];
}

#pragma mark -

- (void)undoOrRedoHistoryWithAction:(SpectacleWindowAction)action
{
  SpectacleHistory *history = [self historyForCurrentApplication];
  SpectacleHistoryItem *historyItem = (action == SpectacleWindowActionUndo) ? history.previousHistoryItem : history.nextHistoryItem;
  NSScreen *screenOfDisplay = [_screenDetection screenWithAction:action
                                                         andRect:historyItem.windowRect
                                                         screens:NSScreen.screens
                                                      mainScreen:NSScreen.mainScreen];

  CGRect visibleFrameOfScreen = CGRectNull;

  if (screenOfDisplay) {
    visibleFrameOfScreen = NSRectToCGRect(screenOfDisplay.visibleFrame);
  }

  if (![self moveWithHistoryItem:historyItem visibleFrameOfScreen:visibleFrameOfScreen action:action]) {
    NSBeep();
  }
}

- (BOOL)moveWithHistoryItem:(SpectacleHistoryItem *)historyItem
       visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
                     action:(SpectacleWindowAction)action
{
  SpectacleAccessibilityElement *frontmostWindowElement = historyItem.accessibilityElement;
  CGRect windowRect = historyItem.windowRect;

  if (!historyItem || !frontmostWindowElement || CGRectIsNull(windowRect)) {
    return NO;
  }

  [self moveWindowRect:windowRect
         frameOfScreen:CGRectNull
  visibleFrameOfScreen:visibleFrameOfScreen
frontmostWindowElement:frontmostWindowElement
                action:action];

  return YES;
}

@end
