#import "SpectacleWindowActionController.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@implementation SpectacleWindowActionController

- (id)init {
    if (self = [super init]) {
        windowPositionManager = [SpectacleWindowPositionManager sharedManager];
        hotKeyManager = [SpectacleHotKeyManager sharedManager];
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
    
    NSArray *hotKeys = [SpectacleUtilities hotKeysFromDictionary: hotKeysFromUserDefaults action: ^(ZKHotKey *hotKey) {
        [windowPositionManager moveFrontMostWindowWithAction: [windowPositionManager windowActionForHotKey: hotKey]];
    }];
    
    [hotKeyManager registerHotKeys: hotKeys];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToCenter: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionCenter];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToFullscreen: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionFullscreen];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLeftHalf];
}

- (IBAction)moveFrontMostWindowToRightHalf: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionRightHalf];
}

- (IBAction)moveFrontMostWindowToTopHalf: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTopHalf];
}

- (IBAction)moveFrontMostWindowToBottomHalf: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionBottomHalf];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperLeft];
}

- (IBAction)moveFrontMostWindowToLowerLeft: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerLeft];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperRight];
}

- (IBAction)moveFrontMostWindowToLowerRight: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerRight];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextDisplay: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionNextDisplay];
}

- (IBAction)moveFrontMostWindowToPreviousDisplay: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionPreviousDisplay];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionNextThird];
}

- (IBAction)moveFrontMostWindowToPreviousThird: (id)sender {
    [windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionPreviousThird];
}

#pragma mark -

- (IBAction)undoLastWindowAction: (id)sender {
    [windowPositionManager undoLastWindowAction];
}

- (IBAction)redoLastWindowAction: (id)sender {
    [windowPositionManager redoLastWindowAction];
}

@end
