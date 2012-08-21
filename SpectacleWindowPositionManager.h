#import <Foundation/Foundation.h>

typedef enum {
    SpectacleWindowActionUndo = -3,
    SpectacleWindowActionRedo,
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
    SpectacleWindowActionLeftDisplay,
    SpectacleWindowActionRightDisplay,
    SpectacleWindowActionTopDisplay,
    SpectacleWindowActionBottomDisplay
} SpectacleWindowAction;

@interface SpectacleWindowPositionManager : NSObject {
    NSMutableDictionary *myUndoHistory;
    NSMutableDictionary *myRedoHistory;
}

+ (SpectacleWindowPositionManager *)sharedManager;

#pragma mark -

- (void)moveFrontMostWindowWithAction: (SpectacleWindowAction)action;

#pragma mark -

- (void)undoLastWindowAction;

- (void)redoLastWindowAction;

#pragma mark -

- (void)saveLocationAction;
- (void)restoreLocationAction;


@end
