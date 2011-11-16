#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@class SpectacleAccessibilityElement;

typedef enum {
    SpectacleWindowActionNone = -1,
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
    SpectacleWindowActionLeftDisplay,
    SpectacleWindowActionRightDisplay,
    SpectacleWindowActionTopDisplay,
    SpectacleWindowActionBottomDisplay
} SpectacleWindowAction;

#pragma mark -

@interface SpectacleWindowPositionManager : NSObject {
    SpectacleAccessibilityElement *myFrontMostWindowElement;
    NSMutableDictionary *myUndoHistory;
    NSMutableDictionary *myRedoHistory;
}

+ (SpectacleWindowPositionManager *)sharedManager;

#pragma mark -

- (void)moveFrontMostWindowWithAction: (SpectacleWindowAction)action;

#pragma mark -

- (void)undoLastWindowAction;

- (void)redoLastWindowAction;

@end
