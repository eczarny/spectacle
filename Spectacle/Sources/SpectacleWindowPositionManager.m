#import "SpectacleAccessibilityElement.h"
#import "SpectacleCalculationResult.h"
#import "SpectacleConstants.h"
#import "SpectacleHistory.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleScreenDetection.h"
#import "SpectacleShortcut.h"
#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleWindowPositionManager.h"

#define RectFitsInRect(a, b) ((a.size.width <= b.size.width) && (a.size.height <= b.size.height))

#pragma mark -

#define Resizing(action) ((action == SpectacleWindowActionLarger) || (action == SpectacleWindowActionSmaller))
#define UndoOrRedo(action) ((action == SpectacleWindowActionUndo) || (action == SpectacleWindowActionRedo))

#pragma mark -

@interface SpectacleWindowPositionManager ()

@property (nonatomic) NSMutableDictionary *applicationHistories;
@property (nonatomic) NSMutableSet *blacklistedApplications;

@end

#pragma mark -

@implementation SpectacleWindowPositionManager

- (instancetype)init
{
  if ((self = [super init])) {
    NSString *path = [NSBundle.mainBundle pathForResource:SpectacleBlacklistedApplicationsPropertyListFile
                                                   ofType:SpectaclePropertyListFileExtension];

    _applicationHistories = [NSMutableDictionary new];
    _blacklistedApplications = [NSMutableSet setWithArray:[NSArray arrayWithContentsOfFile:path]];
  }

  return self;
}

#pragma mark -

+ (SpectacleWindowPositionManager *)sharedManager
{
  static SpectacleWindowPositionManager *sharedInstance = nil;
  static dispatch_once_t predicate;

  dispatch_once(&predicate, ^{
    sharedInstance = [self new];
  });

  return sharedInstance;
}

#pragma mark -

- (void)moveFrontMostWindowWithAction:(SpectacleWindowAction)action
{
  NSString *frontMostWindowName = SpectacleAccessibilityElement.frontMostApplicationName;
  NSString *spectacleWindowName = NSBundle.mainBundle.infoDictionary[@"CFBundleName"];

  if ([frontMostWindowName isEqualToString:spectacleWindowName]) {
    NSBeep();

    return;
  }

  SpectacleAccessibilityElement *frontMostWindowElement = SpectacleAccessibilityElement.frontMostWindowElement;
  CGRect frontMostWindowRect = [self rectOfWindowWithAccessibilityElement:frontMostWindowElement];
  CGRect previousFrontMostWindowRect = CGRectNull;

  NSScreen *screenOfDisplay = [SpectacleScreenDetection screenWithAction:action
                                                                 andRect:frontMostWindowRect
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

  if (frontMostWindowElement.isSheet
      || frontMostWindowElement.isFullScreen
      || CGRectIsNull(frontMostWindowRect)
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
    historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement:frontMostWindowElement
                                                                 windowRect:frontMostWindowRect];

    [history addHistoryItem:historyItem];
  }

  frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfScreen);

  if (MovingToNextOrPreviousDisplay(action) && RectFitsInRect(frontMostWindowRect, visibleFrameOfScreen)) {
    action = SpectacleWindowActionCenter;
  }

  previousFrontMostWindowRect = frontMostWindowRect;

  if (Resizing(action)) {
    CGFloat sizeOffset = ((action == SpectacleWindowActionLarger) ? 1.0 : -1.0) * SpectacleWindowSizeOffset;

    calculationResult = [SpectacleWindowPositionCalculator calculateResizedWindowRect:frontMostWindowRect
                                                                 visibleFrameOfScreen:visibleFrameOfScreen
                                                                           sizeOffset:sizeOffset
                                                                               action:action];
  } else {
    calculationResult = [SpectacleWindowPositionCalculator calculateWindowRect:frontMostWindowRect
                                                          visibleFrameOfScreen:visibleFrameOfScreen
                                                                        action:action];
  }

  action = calculationResult.action;
  frontMostWindowRect = calculationResult.windowRect;

  if (CGRectEqualToRect(previousFrontMostWindowRect, frontMostWindowRect)) {
    NSBeep();

    return;
  }

  frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfScreen);

  historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement:frontMostWindowElement
                                                               windowRect:frontMostWindowRect];

  [history addHistoryItem:historyItem];

  [self moveWindowRect:frontMostWindowRect
         frameOfScreen:frameOfScreen
  visibleFrameOfScreen:visibleFrameOfScreen
frontMostWindowElement:frontMostWindowElement
                action:action];
}

#pragma mark -

- (void)undoLastWindowAction
{
  [self moveFrontMostWindowWithAction:SpectacleWindowActionUndo];
}

- (void)redoLastWindowAction
{
  [self moveFrontMostWindowWithAction:SpectacleWindowActionRedo];
}

#pragma mark -

- (SpectacleWindowAction)windowActionForShortcut:(SpectacleShortcut *)shortcut
{
  NSString *name = shortcut.shortcutName;
  SpectacleWindowAction windowAction = SpectacleWindowActionNone;

  if ([name isEqualToString:SpectacleWindowActionMoveToCenter]) {
    windowAction = SpectacleWindowActionCenter;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToFullscreen]) {
    windowAction = SpectacleWindowActionFullscreen;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToLeftHalf]) {
    windowAction = SpectacleWindowActionLeftHalf;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToRightHalf]) {
    windowAction = SpectacleWindowActionRightHalf;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToTopHalf]) {
    windowAction = SpectacleWindowActionTopHalf;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToBottomHalf]) {
    windowAction = SpectacleWindowActionBottomHalf;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToUpperLeft]) {
    windowAction = SpectacleWindowActionUpperLeft;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToLowerLeft]) {
    windowAction = SpectacleWindowActionLowerLeft;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToUpperRight]) {
    windowAction = SpectacleWindowActionUpperRight;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToLowerRight]) {
    windowAction = SpectacleWindowActionLowerRight;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToNextDisplay]) {
    windowAction = SpectacleWindowActionNextDisplay;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToPreviousDisplay]) {
    windowAction = SpectacleWindowActionPreviousDisplay;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToNextThird]) {
    windowAction = SpectacleWindowActionNextThird;
  } else if ([name isEqualToString:SpectacleWindowActionMoveToPreviousThird]) {
    windowAction = SpectacleWindowActionPreviousThird;
  } else if ([name isEqualToString:SpectacleWindowActionMakeLarger]) {
    windowAction = SpectacleWindowActionLarger;
  } else if ([name isEqualToString:SpectacleWindowActionMakeSmaller]) {
    windowAction = SpectacleWindowActionSmaller;
  } else if ([name isEqualToString:SpectacleWindowActionUndoLastMove]) {
    windowAction = SpectacleWindowActionUndo;
  } else if ([name isEqualToString:SpectacleWindowActionRedoLastMove]) {
    windowAction = SpectacleWindowActionRedo;
  }

  return windowAction;
}

#pragma mark -

- (CGRect)rectOfWindowWithAccessibilityElement:(SpectacleAccessibilityElement *)accessibilityElement
{
  CGRect result = CGRectNull;

  if (accessibilityElement) {
    CFTypeRef windowPositionValue = [accessibilityElement valueOfAttribute:kAXPositionAttribute type:kAXValueCGPointType];
    CFTypeRef windowSizeValue = [accessibilityElement valueOfAttribute:kAXSizeAttribute type:kAXValueCGSizeType];
    CGPoint windowPosition;
    CGSize windowSize;

    AXValueGetValue(windowPositionValue, kAXValueCGPointType, (void *)&windowPosition);
    AXValueGetValue(windowSizeValue, kAXValueCGSizeType, (void *)&windowSize);

    if ((windowPositionValue != NULL) && (windowSizeValue != NULL)) {
      CFRelease(windowPositionValue);
      CFRelease(windowSizeValue);

      result = CGRectMake(windowPosition.x, windowPosition.y, windowSize.width, windowSize.height);
    }
  }

  return result;
}

#pragma mark -

- (void)moveWindowRect:(CGRect)windowRect
         frameOfScreen:(CGRect)frameOfScreen
  visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
frontMostWindowElement:(SpectacleAccessibilityElement *)frontMostWindowElement
                action:(SpectacleWindowAction)action
{
  NSString *frontMostApplicationName = SpectacleAccessibilityElement.frontMostApplicationName;

  if ([self.blacklistedApplications containsObject:frontMostApplicationName]) {
    NSBeep();

    return;
  }

  CGRect previousWindowRect = [self rectOfWindowWithAccessibilityElement:frontMostWindowElement];

  if (CGRectIsNull(previousWindowRect)) {
    NSBeep();

    return;
  }

  [self moveWindowRect:windowRect frontMostWindowElement:frontMostWindowElement];

  CGRect movedWindowRect = [self rectOfWindowWithAccessibilityElement:frontMostWindowElement];

  if (!CGRectEqualToRect(movedWindowRect, windowRect)) {
    movedWindowRect = [self makeMovedWindowRect:movedWindowRect
                                  fitWindowRect:windowRect
                         frontMostWindowElement:frontMostWindowElement];
  }

  movedWindowRect = [self makeMovedWindowRect:movedWindowRect
                      fitVisibleFrameOfScreen:visibleFrameOfScreen
                                frameOfScreen:frameOfScreen
                       frontMostWindowElement:frontMostWindowElement];

  if (MovingToThirdOfDisplay(action) && !CGRectContainsRect(windowRect, movedWindowRect)) {
    NSBeep();

    [self moveWindowRect:previousWindowRect frontMostWindowElement:frontMostWindowElement];
  }
}

- (void)moveWindowRect:(CGRect)windowRect frontMostWindowElement:(SpectacleAccessibilityElement *)frontMostWindowElement
{
  AXValueRef windowRectPositionRef = AXValueCreate(kAXValueCGPointType, (const void *)&windowRect.origin);
  AXValueRef windowRectSizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&windowRect.size);

  [frontMostWindowElement setValue:windowRectSizeRef forAttribute:kAXSizeAttribute];
  [frontMostWindowElement setValue:windowRectPositionRef forAttribute:kAXPositionAttribute];
  [frontMostWindowElement setValue:windowRectSizeRef forAttribute:kAXSizeAttribute];

  CFRelease(windowRectPositionRef);
  CFRelease(windowRectSizeRef);
}

- (CGRect)makeMovedWindowRect:(CGRect)movedWindowRect
                fitWindowRect:(CGRect)windowRect
       frontMostWindowElement:(SpectacleAccessibilityElement *)frontMostWindowElement
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

    [self moveWindowRect:adjustedWindowRect frontMostWindowElement:frontMostWindowElement];

    movedWindowRect = [self rectOfWindowWithAccessibilityElement:frontMostWindowElement];
  }

  adjustedWindowRect.origin.x += floor((windowRect.size.width - movedWindowRect.size.width) / 2.0f);
  adjustedWindowRect.origin.y += floor((windowRect.size.height - movedWindowRect.size.height) / 2.0f);

  [self moveWindowRect:adjustedWindowRect frontMostWindowElement:frontMostWindowElement];

  return [self rectOfWindowWithAccessibilityElement:frontMostWindowElement];
}

- (CGRect)makeMovedWindowRect:(CGRect)movedWindowRect
      fitVisibleFrameOfScreen:(CGRect)visibleFrameOfScreen
                frameOfScreen:(CGRect)frameOfScreen
       frontMostWindowElement:(SpectacleAccessibilityElement *)frontMostWindowElement
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
    [self moveWindowRect:movedWindowRect frontMostWindowElement:frontMostWindowElement];

    movedWindowRect = [self rectOfWindowWithAccessibilityElement:frontMostWindowElement];
  }

  return movedWindowRect;
}

#pragma mark -

- (SpectacleHistory *)historyForCurrentApplication
{
  NSString *applicationName = SpectacleAccessibilityElement.frontMostApplicationName;

  if (!applicationName) {
    return nil;
  }

  if (!self.applicationHistories[applicationName]) {
    self.applicationHistories[applicationName] = [SpectacleHistory new];
  }

  return self.applicationHistories[applicationName];
}

#pragma mark -

- (void)undoOrRedoHistoryWithAction:(SpectacleWindowAction)action
{
  SpectacleHistory *history = self.historyForCurrentApplication;
  SpectacleHistoryItem *historyItem = (action == SpectacleWindowActionUndo) ? history.previousHistoryItem : history.nextHistoryItem;
  NSScreen *screenOfDisplay = [SpectacleScreenDetection screenWithAction:action
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
  SpectacleAccessibilityElement *frontMostWindowElement = historyItem.accessibilityElement;
  CGRect windowRect = historyItem.windowRect;

  if (!historyItem || !frontMostWindowElement || CGRectIsNull(windowRect)) {
    return NO;
  }

  [self moveWindowRect:windowRect
         frameOfScreen:CGRectNull
  visibleFrameOfScreen:visibleFrameOfScreen
frontMostWindowElement:frontMostWindowElement
                action:action];

  return YES;
}

@end
