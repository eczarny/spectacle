#import <Cocoa/Cocoa.h>

#import "SpectacleWindowAction.h"
#import "SpectacleWindowMoverProtocol.h"

typedef void (^SpectacleFailureFeedback)();

@class SpectacleAccessibilityElement;
@class SpectacleScreenDetector;
@class SpectacleShortcut;
@class SpectacleWindowPositionCalculator;

@interface SpectacleWindowPositionManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithScreenDetector:(SpectacleScreenDetector *)screenDetector
              windowPositionCalculator:(SpectacleWindowPositionCalculator *)windowPositionCalculator
                       sharedWorkspace:(NSWorkspace *)sharedWorkspace
                       failureFeedback:(SpectacleFailureFeedback)failureFeedback
                           windowMover:(id<SpectacleWindowMoverProtocol>)windowMover NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithScreenDetector:(SpectacleScreenDetector *)screenDetector
              windowPositionCalculator:(SpectacleWindowPositionCalculator *)windowPositionCalculator
                       sharedWorkspace:(NSWorkspace *)sharedWorkspace;

#pragma mark -

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction)action
                           screens:(NSArray<NSScreen *> *)screens
                        mainScreen:(NSScreen *)mainScreen;

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction)action;

#pragma mark -

- (void)undoLastWindowAction;

- (void)redoLastWindowAction;

#pragma mark -

- (SpectacleWindowAction)windowActionForShortcut:(SpectacleShortcut *)shortcut;

@end
