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

- (void)moveFrontMostWindowToCenter: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionCenter];
}

#pragma mark -

- (void)moveFrontMostWindowToFullscreen: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionFullscreen];
}

#pragma mark -

- (void)moveFrontMostWindowToLeftHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLeftHalf];
}

- (void)moveFrontMostWindowToRightHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionRightHalf];
}

- (void)moveFrontMostWindowToTopHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTopHalf];
}

- (void)moveFrontMostWindowToBottomHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionBottomHalf];
}

#pragma mark -

- (void)moveFrontMostWindowToUpperLeft: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperLeft];
}

- (void)moveFrontMostWindowToLowerLeft: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerLeft];
}

#pragma mark -

- (void)moveFrontMostWindowToUpperRight: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperRight];
}

- (void)moveFrontMostWindowToLowerRight: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerRight];
}

#pragma mark -

- (void)moveFrontMostWindowToLeftDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLeftDisplay];
}

- (void)moveFrontMostWindowToRightDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionRightDisplay];
}

- (void)moveFrontMostWindowToTopDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTopDisplay];
}

- (void)moveFrontMostWindowToBottomDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionBottomDisplay];
}

#pragma mark -

- (void)undoLastWindowAction: (id)sender {
    [myWindowPositionManager undoLastWindowAction];
}

- (void)redoLastWindowAction: (id)sender {
    [myWindowPositionManager redoLastWindowAction];
}

@end
