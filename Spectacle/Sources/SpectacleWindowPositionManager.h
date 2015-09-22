#import <Cocoa/Cocoa.h>

#define FlipVerticalOriginOfRectInRect(a, b) \
  (b.size.height - (a.origin.y + a.size.height) + ([[[NSScreen screens] objectAtIndex:0] frame].size.height - b.size.height))

#pragma mark -

#define MovingToCenterRegionOfDisplay(action) (action == SpectacleWindowActionCenter)

#define MovingToTopRegionOfDisplay(action) \
  ((action == SpectacleWindowActionTopHalf) \
  || (action == SpectacleWindowActionUpperLeft) \
  || (action == SpectacleWindowActionUpperRight))

#define MovingToUpperOrLowerLeftOfDisplay(action) \
  ((action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionLowerLeft))

#define MovingToUpperOrLowerRightDisplay(action) \
  ((action == SpectacleWindowActionUpperRight) || (action == SpectacleWindowActionLowerRight))

#pragma mark -

#define MovingToNextOrPreviousDisplay(action) \
((action == SpectacleWindowActionNextDisplay) || (action == SpectacleWindowActionPreviousDisplay))

#pragma mark -

#define MovingToThirdOfDisplay(action) \
  ((action == SpectacleWindowActionNextThird) || (action == SpectacleWindowActionPreviousThird))

#pragma mark -

typedef NS_ENUM(NSInteger, SpectacleWindowAction) {
  SpectacleWindowActionUndo = -4,
  SpectacleWindowActionRedo,
  SpectacleWindowActionLarger,
  SpectacleWindowActionSmaller,
  SpectacleWindowActionNone,
  SpectacleWindowActionCenter,
  SpectacleWindowActionFullscreen,
  SpectacleWindowActionLeftHalf,
  SpectacleWindowActionUpperLeft,
  SpectacleWindowActionLowerLeft,
  SpectacleWindowActionRightHalf,
  SpectacleWindowActionUpperRight,
  SpectacleWindowActionLowerRight,
  SpectacleWindowActionTopHalf,
  SpectacleWindowActionBottomHalf,
  SpectacleWindowActionNextDisplay,
  SpectacleWindowActionPreviousDisplay,
  SpectacleWindowActionNextThird,
  SpectacleWindowActionPreviousThird
};

typedef void (^SpectacleFailureFeedback)();

@class SpectacleAccessibilityElement, SpectacleScreenDetector, SpectacleShortcut, SpectacleWindowPositionCalculator;

@interface SpectacleWindowPositionManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithScreenDetector:(SpectacleScreenDetector *)screenDetector
              windowPositionCalculator:(SpectacleWindowPositionCalculator *)windowPositionCalculator
                       sharedWorkspace:(NSWorkspace *)sharedWorkspace
                       failureFeedback:(SpectacleFailureFeedback)failureFeedback NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithScreenDetector:(SpectacleScreenDetector *)screenDetector
              windowPositionCalculator:(SpectacleWindowPositionCalculator *)windowPositionCalculator
                       sharedWorkspace:(NSWorkspace *)sharedWorkspace;

#pragma mark -

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction)action
                           screens:(NSArray *)screens
                        mainScreen:(NSScreen *)mainScreen;

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction)action;

#pragma mark -

- (void)undoLastWindowAction;

- (void)redoLastWindowAction;

#pragma mark -

- (SpectacleWindowAction)windowActionForShortcut:(SpectacleShortcut *)shortcut;

@end
