#import "SpectacleHotKeyPreferencePane.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectacleHotKeyPreferencePane (SpectacleHotKeyPreferencePanePrivate)

- (void)loadRegisteredHotKeys;

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled;

@end

#pragma mark -

@implementation SpectacleHotKeyPreferencePane

- (void)preferencePaneDidLoad {
    myHotKeyManager = [SpectacleHotKeyManager sharedManager];
    
    myHotKeyRecorders = [[NSDictionary alloc] initWithObjectsAndKeys:
                            myMoveToCenterHotKeyRecorder,        SpectacleWindowActionMoveToCenter,
                            myMoveToFullscreenHotKeyRecorder,    SpectacleWindowActionMoveToFullscreen,
                            myMoveToLeftHotKeyRecorder,          SpectacleWindowActionMoveToLeftHalf,
                            myMoveToRightHotKeyRecorder,         SpectacleWindowActionMoveToRightHalf,
                            myMoveToTopHotKeyRecorder,           SpectacleWindowActionMoveToTopHalf,
                            myMoveToBottomHotKeyRecorder,        SpectacleWindowActionMoveToBottomHalf,
                            myMoveToUpperLeftHotKeyRecorder,     SpectacleWindowActionMoveToUpperLeft,
                            myMoveToLowerLeftHotKeyRecorder,     SpectacleWindowActionMoveToLowerLeft,
                            myMoveToUpperRightHotKeyRecorder,    SpectacleWindowActionMoveToUpperRight,
                            myMoveToLowerRightHotKeyRecorder,    SpectacleWindowActionMoveToLowerRight,
                            myMoveToLeftDisplayHotKeyRecorder,   SpectacleWindowActionMoveToLeftDisplay,
                            myMoveToRightDisplayHotKeyRecorder,  SpectacleWindowActionMoveToRightDisplay,
                            myMoveToTopDisplayHotKeyRecorder,    SpectacleWindowActionMoveToTopDisplay,
                            myMoveToBottomDisplayHotKeyRecorder, SpectacleWindowActionMoveToBottomDisplay,
                            myUndoLastMoveHotKeyRecorder,        SpectacleWindowActionUndoLastMove,
                            myRedoLastMoveHotKeyRecorder,        SpectacleWindowActionRedoLastMove,
                            nil];
    
    [self loadRegisteredHotKeys];
}

#pragma mark -

- (NSString *)name {
    return ZeroKitLocalizedString(@"Hot Keys");
}

#pragma mark -

- (NSImage *)icon {
    return [SpectacleUtilities imageFromResource: @"Hot Key Preferences" inBundle: [SpectacleUtilities applicationBundle]];
}

#pragma mark -

- (NSString *)toolTip {
    return nil;
}

#pragma mark -

- (NSView *)view {
    return myView;
}

#pragma mark -

- (void)hotKeyRecorder: (ZeroKitHotKeyRecorder *)hotKeyRecorder didReceiveNewHotKey: (ZeroKitHotKey *)hotKey {
    [hotKey setHotKeyAction: [SpectacleUtilities actionForHotKeyWithName: [hotKey hotKeyName] target: myApplicationController]];
    
    [myHotKeyManager registerHotKey: hotKey];
}

- (void)hotKeyRecorder: (ZeroKitHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey: (ZeroKitHotKey *)hotKey {
    [myHotKeyManager unregisterHotKeyForName: [hotKey hotKeyName]];
}

#pragma mark -

- (void)dealloc {
    [myHotKeyRecorders release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectacleHotKeyPreferencePane (SpectacleHotKeyPreferencePanePrivate)

- (void)loadRegisteredHotKeys {
    for (NSString *hotKeyName in [myHotKeyRecorders allKeys]) {
        ZeroKitHotKeyRecorder *hotKeyRecorder = [myHotKeyRecorders objectForKey: hotKeyName];
        ZeroKitHotKey *hotKey = [myHotKeyManager registeredHotKeyForName: hotKeyName];
        
        [hotKeyRecorder setHotKeyName: hotKeyName];
        
        if (hotKey) {
            [hotKeyRecorder setHotKey: hotKey];
        }
        
        [hotKeyRecorder setDelegate: self];
    }
    
    [self enableHotKeyRecorders: YES];
}

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled {
    for (ZeroKitHotKeyRecorder *hotKeyRecorder in [myHotKeyRecorders allValues]) {
        if (!enabled) {
            [hotKeyRecorder setHotKey: nil];
        }
        
        [hotKeyRecorder setEnabled: enabled];
    }
}

@end
