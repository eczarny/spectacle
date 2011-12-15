#import "SpectaclePreferencePane.h"
#import "SpectacleHelperControllerProtocol.h"
#import "SpectacleToggleSwitch.h"
#import "SpectaclePreferencePaneUtilities.h"
#import "SpectacleConstants.h"

@interface SpectaclePreferencePane (SpectaclePreferencePanePrivate)

- (void)toggleControlsBasedOnSpectacleRunningState;

#pragma mark -

- (void)helperApplicationDidFinishLaunching;

- (void)helperApplicationDidTerminate;

#pragma mark -

- (void)connectToVendedHelperController;

#pragma mark -

- (void)handleConnectionException: (NSException *)exception withMessage: (NSString *)message;

#pragma mark -

- (void)loadRegisteredHotKeys;

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled;

@end

#pragma mark -

@implementation SpectaclePreferencePane

- (void)mainViewDidLoad {
    NSDistributedNotificationCenter *distributedNotificationCenter = [NSDistributedNotificationCenter defaultCenter];
    
    [distributedNotificationCenter addObserver: self
                                      selector: @selector(helperApplicationDidFinishLaunching)
                                          name: SpectacleHelperDidFinishLaunchingNotification
                                        object: nil
                            suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    
    [distributedNotificationCenter addObserver: self
                                      selector: @selector(helperApplicationDidTerminate)
                                          name: SpectacleHelperDidTerminateNotification
                                        object: nil
                            suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    
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
    
    [myToggleRunningStateSwitch setDelegate: self];
    
    [self toggleControlsBasedOnSpectacleRunningState];
    
    [mySpectacleVersionTextField setStringValue: [SpectaclePreferencePaneUtilities preferencePaneVersion]];
    
    NSMutableAttributedString *link = [[[NSMutableAttributedString alloc] init] autorelease];
    
    [link appendAttributedString: [NSAttributedString linkFromString: @"Iiro Jäppinen"
                                                             withURL: [NSURL URLWithString: @"http://iiro.eu/"]
                                                                font: [myArtworkCreditTextField font]]];
    
    [myArtworkCreditTextField setAllowsEditingTextAttributes: YES];
    [myArtworkCreditTextField setSelectable: YES];
    
    [myArtworkCreditTextField setAttributedStringValue: link];
}

#pragma mark -

- (void)didSelect {
    [self toggleControlsBasedOnSpectacleRunningState];
}

#pragma mark -

- (void)toggleLoginItem: (id)sender {
    NSBundle *helperApplicationBundle = [SpectaclePreferencePaneUtilities helperApplicationBundle];
    
    if ([myLoginItemEnabledButton state] == NSOnState) {
        [SpectaclePreferencePaneUtilities enableLoginItemForBundle: helperApplicationBundle];
    } else{
        [SpectaclePreferencePaneUtilities disableLoginItemForBundle: helperApplicationBundle];
    }
}

#pragma mark -

- (void)hotKeyRecorder: (ZeroKitHotKeyRecorder *)hotKeyRecorder didReceiveNewHotKey: (ZeroKitHotKey *)hotKey {
    @try {
        [myVendedHelperController updateHotKeyWithKeyCode: [hotKey hotKeyCode] modifiers: [hotKey hotKeyModifiers] name: [hotKey hotKeyName]];
    } @catch (NSException *e) {
        [self handleConnectionException: e
                            withMessage: @"There was a problem while updating a hot key."];
    }
}

- (void)hotKeyRecorder: (ZeroKitHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey: (ZeroKitHotKey *)hotKey {
    @try {
        [myVendedHelperController unregisterHotKeyWithName: [hotKey hotKeyName]];
    } @catch (NSException *e) {
        [self handleConnectionException: e
                            withMessage: @"There was a problem while clearing an existing hot key."];
    }
}

#pragma mark -

- (void)toggleSwitchDidChangeState: (SpectacleToggleSwitch *)toggleSwitch {
    if ([toggleSwitch state] == NSOnState) {
        [SpectaclePreferencePaneUtilities startSpectacle];
    } else {
        [SpectaclePreferencePaneUtilities stopSpectacle];
    }
    
    [myToggleRunningStateSwitch setEnabled: NO];
}

#pragma mark -

- (void)dealloc {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver: self];
    
    [myVendedHelperController release];
    [myHotKeyRecorders release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectaclePreferencePane (SpectaclePreferencePanePrivate)

- (void)toggleControlsBasedOnSpectacleRunningState {
    NSInteger loginItemEnabledState = [SpectaclePreferencePaneUtilities isLoginItemEnabledForBundle: [SpectaclePreferencePaneUtilities helperApplicationBundle]] ? NSOnState : NSOffState;
    
    [myLoginItemEnabledButton setState: loginItemEnabledState];
    
    if ([SpectaclePreferencePaneUtilities isSpectacleRunning]) {
        [myToggleRunningStateSwitch setState: NSOnState];
        
        [self connectToVendedHelperController];
    } else {
        [myToggleRunningStateSwitch setState: NSOffState];
        
        [self enableHotKeyRecorders: NO];
    }
}

#pragma mark -

- (void)helperApplicationDidFinishLaunching {
    [myToggleRunningStateSwitch setEnabled: YES];
    
    [self connectToVendedHelperController];
}

- (void)helperApplicationDidTerminate {
    [myToggleRunningStateSwitch setEnabled: YES];
    
    [self enableHotKeyRecorders: NO];
    
    [myVendedHelperController release];
    
    myVendedHelperController = nil;
}

#pragma mark -

- (void)connectToVendedHelperController {
    NSConnection *connection = [NSConnection connectionWithRegisteredName: SpectacleHelperControllerServiceName host: nil];
    
    if (connection) {
        [myVendedHelperController release];
        
        myVendedHelperController = [[connection rootProxy] retain];
        
        [myVendedHelperController setProtocolForProxy: @protocol(SpectacleHelperControllerProtocol)];
        
        [self loadRegisteredHotKeys];
    } else {
        NSLog(@"Connection to vended helper controller failed.");
    }
}

#pragma mark -

- (void)handleConnectionException: (NSException *)exception withMessage: (NSString *)message {
    NSLog(@"%@ (%@)", message, [exception name]);
    
    if (![SpectaclePreferencePaneUtilities isSpectacleRunning]) {
        [self helperApplicationDidTerminate];
    }
}

#pragma mark -

- (void)loadRegisteredHotKeys {
    for (NSString *hotKeyName in [myHotKeyRecorders allKeys]) {
        ZeroKitHotKeyRecorder *hotKeyRecorder = [myHotKeyRecorders objectForKey: hotKeyName];
        ZeroKitHotKey *hotKey = nil;
        
        @try {
            hotKey = [myVendedHelperController registeredHotKeyForName: hotKeyName];
        } @catch (NSException *e) {
            [self handleConnectionException: e
                                withMessage: @"There was a problem while fetching a hot key."];
        }
        
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
