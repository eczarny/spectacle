#import <Foundation/Foundation.h>
#import <ZeroKit/ZeroKit.h>

enum {
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
    SpectacleWindowActionNextDisplay,
    SpectacleWindowActionPreviousDisplay,
    SpectacleWindowActionNextThird,
    SpectacleWindowActionPreviousThird
};

typedef NSInteger SpectacleWindowAction;

@interface SpectacleWindowPositionManager : NSObject {
    NSMutableDictionary *applicationHistories;
    NSMutableSet *blacklistedWindowRects;
    NSMutableSet *blacklistedApplications;
}

+ (SpectacleWindowPositionManager *)sharedManager;

#pragma mark -

- (void)moveFrontMostWindowWithAction: (SpectacleWindowAction)action;

#pragma mark -

- (void)undoLastWindowAction;

- (void)redoLastWindowAction;

#pragma mark -

- (SpectacleWindowAction)windowActionForHotKey: (ZKHotKey *)hotKey;

@end
