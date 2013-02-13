#import "SpectacleUtilities.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleConstants.h"

@interface ZeroKitHotKey : ZKHotKey

@end

#pragma mark -

@interface SpectacleUtilities (SpectacleUtilitiesPrivate)

+ (void)updateHotKey: (ZKHotKey *)hotKey withPotentiallyNewDefaultHotKey: (ZKHotKey *)defaultHotKey;

#pragma mark -

+ (NSDictionary *)defaultHotKeysWithNames: (NSArray *)names;

@end

#pragma mark -

@implementation SpectacleUtilities

+ (void)displayAccessibilityAPIAlert {
    NSAlert *alert = [NSAlert new];
    NSURL *preferencePaneURL = [NSURL fileURLWithPath: [SpectacleUtilities pathForPreferencePaneNamed: @"UniversalAccessPref"]];
    
    [alert setAlertStyle: NSWarningAlertStyle];
    [alert setMessageText: ZKLocalizedString(@"Spectacle requires that the Accessibility API be enabled")];
    [alert setInformativeText: ZKLocalizedString(@"Would you like to open the Universal Access preferences so that you can turn on \"Enable access for assistive devices\"?")];
    [alert addButtonWithTitle: ZKLocalizedString(@"Open Universal Access Preferences")];
    [alert addButtonWithTitle: ZKLocalizedString(@"Stop Spectacle")];
    
    switch ([alert runModal]) {
        case NSAlertFirstButtonReturn:
            [[NSWorkspace sharedWorkspace] openURL: preferencePaneURL];
            
            break;
        case NSAlertSecondButtonReturn:
        default:
            break;
    }
}

+ (void)displayRunningInBackgroundAlertWithCallback: (void (^)(BOOL, BOOL))callback {
    NSAlert *alert = [NSAlert new];
    
    [alert setAlertStyle: NSInformationalAlertStyle];
    [alert setShowsSuppressionButton: YES];
    [alert setMessageText: ZKLocalizedString(@"This will cause Spectacle to run in the background")];
    [alert setInformativeText: ZKLocalizedString(@"Run Spectacle in the background without a menu in the status bar.\n\nTo access Spectacle's preferences click on Spectacle in Launchpad, or open Spectacle in Finder.")];
    [alert addButtonWithTitle: ZKLocalizedString(@"OK")];
    [alert addButtonWithTitle: ZKLocalizedString(@"Cancel")];
    
    NSInteger response = [alert runModal];
    BOOL isAlertSuppressed = [[alert suppressionButton] state] == NSOnState;
    
    switch (response) {
        case NSAlertFirstButtonReturn:
            callback(YES, isAlertSuppressed);
            
            break;
        case NSAlertSecondButtonReturn:
            callback(NO, isAlertSuppressed);
            
            break;
        default:
            break;
    }
}

#pragma mark -

+ (NSArray *)hotKeyNames {
    NSBundle *bundle = [SpectacleUtilities applicationBundle];
    NSString *path = [bundle pathForResource: SpectacleHotKeyNamesPropertyListFile ofType: ZKPropertyListFileExtension];
    NSArray *hotKeyNames = [NSArray arrayWithContentsOfFile: path];
    
    return hotKeyNames;
}

#pragma mark -

+ (NSArray *)hotKeysFromDictionary: (NSDictionary *)dictionary action: (ZKHotKeyAction)action {
    NSDictionary *defaultHotKeys = [SpectacleUtilities defaultHotKeysWithNames: [dictionary allKeys]];
    NSMutableArray *hotKeys = [NSMutableArray new];
    
    [NSKeyedUnarchiver setClass: [ZeroKitHotKey class] forClassName: @"SpectacleHotKey"];
    
    for (NSData *hotKeyData in [dictionary allValues]) {
        ZKHotKey *hotKey = [NSKeyedUnarchiver unarchiveObjectWithData: hotKeyData];
        
        if (![hotKey isClearedHotKey]) {
            NSString *hotKeyName = [hotKey hotKeyName];
            
            [hotKey setHotKeyAction: action];
            
            [SpectacleUtilities updateHotKey: hotKey withPotentiallyNewDefaultHotKey: defaultHotKeys[hotKeyName]];
            
            [hotKeys addObject: hotKey];
        }
    }
    
    return hotKeys;
}

@end

#pragma mark -

@implementation ZeroKitHotKey

@end

#pragma mark -

@implementation SpectacleUtilities (SpectacleUtilitiesPrivate)

+ (void)updateHotKey: (ZKHotKey *)hotKey withPotentiallyNewDefaultHotKey: (ZKHotKey *)defaultHotKey {
    NSString *hotKeyName = [hotKey hotKeyName];
    NSInteger defaultHotKeyCode;
    
    if (![hotKeyName isEqualToString: SpectacleWindowActionMoveToLowerLeft] && ![hotKeyName isEqualToString: SpectacleWindowActionMoveToLowerRight]) {
        return;
    }
    
    defaultHotKeyCode = [defaultHotKey hotKeyCode];
    
    if (([hotKey hotKeyCode] == defaultHotKeyCode) && ([hotKey hotKeyModifiers] == 768)) {
        [hotKey setHotKeyCode: defaultHotKeyCode];
        
        [hotKey setHotKeyModifiers: [defaultHotKey hotKeyModifiers]];
    }
}

#pragma mark -

+ (NSDictionary *)defaultHotKeysWithNames: (NSArray *)names {
    NSBundle *bundle = [SpectacleUtilities applicationBundle];
    NSString *path = [bundle pathForResource: ZKDefaultPreferencesFile ofType: ZKPropertyListFileExtension];
    NSDictionary *applicationDefaults = [NSDictionary dictionaryWithContentsOfFile: path];
    NSMutableDictionary *defaultHotKeys = [NSMutableDictionary new];
    
    for (NSString *hotKeyName in names) {
        NSData *defaultHotKeyData = applicationDefaults[hotKeyName];
        ZKHotKey *defaultHotKey = [NSKeyedUnarchiver unarchiveObjectWithData: defaultHotKeyData];
        
        defaultHotKeys[hotKeyName] = defaultHotKey;
    }
    
    return defaultHotKeys;
}

@end
