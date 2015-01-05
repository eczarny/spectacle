#import "SpectacleWindowActionController.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleUtilities.h"

@interface SpectacleWindowActionController ()

@property (nonatomic) SpectacleWindowPositionManager *windowPositionManager;
@property (nonatomic) SpectacleHotKeyManager *hotKeyManager;

@end

#pragma mark -

@implementation SpectacleWindowActionController

- (id)init {
    if (self = [super init]) {
        _windowPositionManager = SpectacleWindowPositionManager.sharedManager;
        _hotKeyManager = SpectacleHotKeyManager.sharedManager;
    }
    
    return self;
}

#pragma mark -

- (void)registerHotKeys {
    NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
    NSMutableDictionary *hotKeysFromUserDefaults = [NSMutableDictionary new];
    
    for (NSString *hotKeyName in SpectacleUtilities.hotKeyNames) {
        hotKeysFromUserDefaults[hotKeyName] = [userDefaults dataForKey: hotKeyName];
    }

    NSArray *hotKeys = [SpectacleUtilities hotKeysFromDictionary: hotKeysFromUserDefaults action: ^(ZKHotKey *hotKey) {
        [_windowPositionManager moveFrontMostWindowWithAction: [_windowPositionManager windowActionForHotKey: hotKey]];
    }];

    [_hotKeyManager registerHotKeys: hotKeys];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToCenter: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionCenter];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToFullscreen: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionFullscreen];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLeftHalf];
}

- (IBAction)moveFrontMostWindowToRightHalf: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionRightHalf];
}

- (IBAction)moveFrontMostWindowToTopHalf: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTopHalf];
}

- (IBAction)moveFrontMostWindowToBottomHalf: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionBottomHalf];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperLeft];
}

- (IBAction)moveFrontMostWindowToLowerLeft: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerLeft];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperRight];
}

- (IBAction)moveFrontMostWindowToLowerRight: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerRight];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextDisplay: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionNextDisplay];
}

- (IBAction)moveFrontMostWindowToPreviousDisplay: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionPreviousDisplay];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionNextThird];
}

- (IBAction)moveFrontMostWindowToPreviousThird: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionPreviousThird];
}

#pragma mark -

- (IBAction)makeFrontMostWindowLarger: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLarger];
}

- (IBAction)makeFrontMostWindowSmaller: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionSmaller];
}

#pragma mark -

- (IBAction)undoLastWindowAction: (id)sender {
    [_windowPositionManager undoLastWindowAction];
}

- (IBAction)redoLastWindowAction: (id)sender {
    [_windowPositionManager redoLastWindowAction];
}

@end
