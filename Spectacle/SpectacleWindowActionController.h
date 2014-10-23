#import <Foundation/Foundation.h>

@class SpectacleWindowPositionManager, SpectacleHotKeyManager;

@interface SpectacleWindowActionController : NSObject

- (void)registerHotKeys;

#pragma mark -

- (IBAction)moveFrontMostWindowToCenter: (id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToFullscreen: (id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf: (id)sender;

- (IBAction)moveFrontMostWindowToRightHalf: (id)sender;

- (IBAction)moveFrontMostWindowToTopHalf: (id)sender;

- (IBAction)moveFrontMostWindowToBottomHalf: (id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft: (id)sender;

- (IBAction)moveFrontMostWindowToLowerLeft: (id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight: (id)sender;

- (IBAction)moveFrontMostWindowToLowerRight: (id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToNextDisplay: (id)sender;

- (IBAction)moveFrontMostWindowToPreviousDisplay: (id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird: (id)sender;

- (IBAction)moveFrontMostWindowToPreviousThird: (id)sender;

#pragma mark -

- (IBAction)makeFrontMostWindowLarger: (id)sender;

- (IBAction)makeFrontMostWindowSmaller: (id)sender;

#pragma mark -

- (IBAction)undoLastWindowAction: (id)sender;

- (IBAction)redoLastWindowAction: (id)sender;

@end
