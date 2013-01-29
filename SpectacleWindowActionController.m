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
    NSMutableDictionary *hotKeysFromUserDefaults = [NSMutableDictionary new];
    
    for (NSString *hotKeyName in [SpectacleUtilities hotKeyNames]) {
        hotKeysFromUserDefaults[hotKeyName] = [userDefaults dataForKey: hotKeyName];
    }
    
    [myHotKeyManager registerHotKeys: [SpectacleUtilities hotKeysFromDictionary: hotKeysFromUserDefaults hotKeyTarget: self]];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToCenter {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionCenter];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToFullscreen {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionFullscreen];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLeftHalf];
}

- (IBAction)moveFrontMostWindowToRightHalf {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionRightHalf];
}

- (IBAction)moveFrontMostWindowToTopHalf {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTopHalf];
}

- (IBAction)moveFrontMostWindowToBottomHalf {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionBottomHalf];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperLeft];
}

- (IBAction)moveFrontMostWindowToLowerLeft {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerLeft];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperRight];
}

- (IBAction)moveFrontMostWindowToLowerRight {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerRight];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextDisplay {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionNextDisplay];
}

- (IBAction)moveFrontMostWindowToPreviousDisplay {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionPreviousDisplay];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionNextThird];
}

- (IBAction)moveFrontMostWindowToPreviousThird {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionPreviousThird];
}

#pragma mark -

- (IBAction)undoLastWindowAction {
    [myWindowPositionManager undoLastWindowAction];
}

- (IBAction)redoLastWindowAction {
    [myWindowPositionManager redoLastWindowAction];
}

@end
