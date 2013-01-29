#import <Foundation/Foundation.h>

@class SpectacleWindowPositionManager, SpectacleHotKeyManager;

@interface SpectacleWindowActionController : NSObject {
    SpectacleWindowPositionManager *myWindowPositionManager;
    SpectacleHotKeyManager *myHotKeyManager;
}

- (void)registerHotKeys;

#pragma mark -

- (IBAction)moveFrontMostWindowToCenter;

#pragma mark -

- (IBAction)moveFrontMostWindowToFullscreen;

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf;

- (IBAction)moveFrontMostWindowToRightHalf;

- (IBAction)moveFrontMostWindowToTopHalf;

- (IBAction)moveFrontMostWindowToBottomHalf;

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft;

- (IBAction)moveFrontMostWindowToLowerLeft;

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight;

- (IBAction)moveFrontMostWindowToLowerRight;

#pragma mark -

- (IBAction)moveFrontMostWindowToNextDisplay;

- (IBAction)moveFrontMostWindowToPreviousDisplay;

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird;

- (IBAction)moveFrontMostWindowToPreviousThird;

#pragma mark -

- (IBAction)undoLastWindowAction;

- (IBAction)redoLastWindowAction;

@end
