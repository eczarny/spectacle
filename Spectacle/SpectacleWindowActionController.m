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

#pragma mark -

- (IBAction)tag1WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTag1];
}

- (IBAction)goTo1WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionGoTo1];
}

#pragma mark -

- (IBAction)tag2WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTag2];
}

- (IBAction)goTo2WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionGoTo2];
}

#pragma mark -

- (IBAction)tag3WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTag3];
}

- (IBAction)goTo3WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionGoTo3];
}

#pragma mark -

- (IBAction)tag4WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTag4];
}

- (IBAction)goTo4WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionGoTo4];
}

#pragma mark -

- (IBAction)tag5WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTag5];
}

- (IBAction)goTo5WindowAction: (id)sender {
    [_windowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionGoTo5];
}

@end
