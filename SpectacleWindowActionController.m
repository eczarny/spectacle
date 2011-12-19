#import "SpectacleWindowActionController.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleUtilities.h"

@implementation SpectacleWindowActionController

- (id)init {
    if (self = [super init]) {
        myWindowPositionManager = [SpectacleWindowPositionManager sharedManager];
        myHotKeyManager = [SpectacleHotKeyManager sharedManager];
    }
    
    return self;
}

#pragma mark -

- (void)registerHotKeys {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *hotKeysFromUserDefaults = [NSMutableDictionary dictionary];
    
    for (NSString *hotKeyName in [SpectacleUtilities hotKeyNames]) {
        [hotKeysFromUserDefaults setObject: [userDefaults dataForKey: hotKeyName] forKey: hotKeyName];
    }
    
    [myHotKeyManager registerHotKeys: [SpectacleUtilities hotKeysFromDictionary: hotKeysFromUserDefaults hotKeyTarget: self]];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToCenter: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionCenter];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToFullscreen: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionFullscreen];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLeftHalf];
}

- (IBAction)moveFrontMostWindowToRightHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionRightHalf];
}

- (IBAction)moveFrontMostWindowToTopHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTopHalf];
}

- (IBAction)moveFrontMostWindowToBottomHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionBottomHalf];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperLeft];
}

- (IBAction)moveFrontMostWindowToLowerLeft: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerLeft];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperRight];
}

- (IBAction)moveFrontMostWindowToLowerRight: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerRight];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLeftDisplay];
}

- (IBAction)moveFrontMostWindowToRightDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionRightDisplay];
}

- (IBAction)moveFrontMostWindowToTopDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTopDisplay];
}

- (IBAction)moveFrontMostWindowToBottomDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionBottomDisplay];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionNextThird];
}

- (IBAction)moveFrontMostWindowToPreviousThird: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionPreviousThird];
}

#pragma mark -

- (IBAction)undoLastWindowAction: (id)sender {
    [myWindowPositionManager undoLastWindowAction];
}

- (IBAction)redoLastWindowAction: (id)sender {
    [myWindowPositionManager redoLastWindowAction];
}

@end
