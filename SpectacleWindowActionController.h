#import <Cocoa/Cocoa.h>

@class SpectacleWindowPositionManager, SpectacleHotKeyManager;

@interface SpectacleWindowActionController : NSObject {
    SpectacleWindowPositionManager *myWindowPositionManager;
    SpectacleHotKeyManager *myHotKeyManager;
}

- (void)registerHotKeys;

#pragma mark -

- (void)moveFrontMostWindowToCenter: (id)sender;

#pragma mark -

- (void)moveFrontMostWindowToFullscreen: (id)sender;

#pragma mark -

- (void)moveFrontMostWindowToLeftHalf: (id)sender;

- (void)moveFrontMostWindowToRightHalf: (id)sender;

- (void)moveFrontMostWindowToTopHalf: (id)sender;

- (void)moveFrontMostWindowToBottomHalf: (id)sender;

#pragma mark -

- (void)moveFrontMostWindowToUpperLeft: (id)sender;

- (void)moveFrontMostWindowToLowerLeft: (id)sender;

#pragma mark -

- (void)moveFrontMostWindowToUpperRight: (id)sender;

- (void)moveFrontMostWindowToLowerRight: (id)sender;

#pragma mark -

- (void)moveFrontMostWindowToLeftDisplay: (id)sender;

- (void)moveFrontMostWindowToRightDisplay: (id)sender;

- (void)moveFrontMostWindowToTopDisplay: (id)sender;

- (void)moveFrontMostWindowToBottomDisplay: (id)sender;

#pragma mark -

- (void)undoLastWindowAction: (id)sender;

- (void)redoLastWindowAction: (id)sender;

@end
