#import "SpectacleUtilities.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleConstants.h"

extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));

@interface ZeroKitHotKey : ZKHotKey

@end

#pragma mark -

@implementation SpectacleUtilities

+ (NSString *)applicationVersion {
    NSBundle *bundle = NSBundle.mainBundle;
    NSString *bundleVersion = [bundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"];

    if (!bundleVersion) {
        bundleVersion = [bundle objectForInfoDictionaryKey: @"CFBundleVersion"];
    }

    return bundleVersion;
}

#pragma mark -

+ (void)registerDefaultsForBundle: (NSBundle *)bundle {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSString *path = [bundle pathForResource: SpectacleDefaultPreferencesPropertyListFile ofType: SpectaclePropertyListFileExtension];
    NSDictionary *applicationDefaults = [[NSDictionary alloc] initWithContentsOfFile: path];

    [defaults registerDefaults: applicationDefaults];
}

#pragma mark -

+ (void)displayAccessibilityAPIAlert {
    NSAlert *alert = [NSAlert new];
    NSURL *preferencePaneURL = [NSURL fileURLWithPath: [SpectacleUtilities pathForPreferencePaneNamed: SpectacleUniversalAccessPreferencePaneName]];

    alert.messageText = LocalizedString(@"Spectacle requires that the Accessibility API be enabled");
    alert.informativeText = LocalizedString(@"Would you like to open the Universal Access preferences so that you can turn on \"Enable access for assistive devices\"?");
    
    [alert addButtonWithTitle: LocalizedString(@"Open Universal Access Preferences")];
    [alert addButtonWithTitle: LocalizedString(@"Stop Spectacle")];
    
    switch ([alert runModal]) {
        case NSAlertFirstButtonReturn:
            [NSWorkspace.sharedWorkspace openURL: preferencePaneURL];
            
            break;
        case NSAlertSecondButtonReturn:
            [NSApplication.sharedApplication terminate: self];
            
            break;
        default:
            break;
    }
}

+ (void)displayRunningInBackgroundAlertWithCallback: (void (^)(BOOL, BOOL))callback {
    NSAlert *alert = [NSAlert new];
    
    alert.alertStyle = NSInformationalAlertStyle;
    alert.showsSuppressionButton = YES;
    alert.messageText = LocalizedString(@"This will cause Spectacle to run in the background");
    alert.informativeText = LocalizedString(@"Run Spectacle in the background without a menu in the status bar.\n\nTo access Spectacle's preferences click on Spectacle in Launchpad, or open Spectacle in Finder.");
    
    [alert addButtonWithTitle: LocalizedString(@"OK")];
    [alert addButtonWithTitle: LocalizedString(@"Cancel")];
    
    NSInteger response = [alert runModal];
    BOOL isAlertSuppressed = [alert.suppressionButton state] == NSOnState;
    
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

+ (void)displayRestoreDefaultsAlertWithCallback: (void (^)(BOOL))callback {
    NSAlert *alert = [NSAlert new];

    alert.messageText = LocalizedString(@"This will restore Spectacle's default hot keys");
    alert.informativeText = LocalizedString(@"Would you like to restore the default hot keys? Any custom hot keys will be lost.");

    [alert addButtonWithTitle: LocalizedString(@"OK")];
    [alert addButtonWithTitle: LocalizedString(@"Cancel")];

    NSInteger response = [alert runModal];

    switch (response) {
        case NSAlertFirstButtonReturn:
            callback(YES);

            break;
        case NSAlertSecondButtonReturn:
            callback(NO);

            break;
        default:
            break;
    }
}

#pragma mark -

+ (SpectacleApplicationTrust)spectacleTrust {
    BOOL result = SpectacleIsTrusted;
    
    if ((AXIsProcessTrustedWithOptions != NULL) && !AXIsProcessTrustedWithOptions(NULL)) {
        result = SpectacleIsNotTrustedOnOrAfterMavericks;
    } else if (!AXAPIEnabled()) {
        result = SpectacleIsNotTrustedBeforeMavericks;
    }
    
    return result;
}

#pragma mark -

+ (NSArray *)hotKeyNames {
    NSBundle *bundle = NSBundle.mainBundle;
    NSString *path = [bundle pathForResource: SpectacleHotKeyNamesPropertyListFile ofType: SpectaclePropertyListFileExtension];
    NSArray *hotKeyNames = [NSArray arrayWithContentsOfFile: path];
    
    return hotKeyNames;
}

#pragma mark -

+ (NSArray *)hotKeysFromDictionary: (NSDictionary *)dictionary action: (ZKHotKeyAction)action {
    NSDictionary *defaultHotKeys = [SpectacleUtilities defaultHotKeysWithNames: dictionary.allKeys];
    NSMutableArray *hotKeys = [NSMutableArray new];
    
    [NSKeyedUnarchiver setClass: ZeroKitHotKey.class forClassName: @"SpectacleHotKey"];
    
    for (NSData *hotKeyData in dictionary.allValues) {
        ZKHotKey *hotKey = [NSKeyedUnarchiver unarchiveObjectWithData: hotKeyData];
        
        if (![hotKey isClearedHotKey]) {
            NSString *hotKeyName = hotKey.hotKeyName;
            
            hotKey.hotKeyAction = action;
            
            [SpectacleUtilities updateHotKey: hotKey withPotentiallyNewDefaultHotKey: defaultHotKeys[hotKeyName]];
            
            [hotKeys addObject: hotKey];
        }
    }
    
    return hotKeys;
}

#pragma mark -

+ (void)restoreDefaultHotKeys {
    SpectacleWindowPositionManager *windowPositionManager = SpectacleWindowPositionManager.sharedManager;
    SpectacleHotKeyManager *hotKeyManager = SpectacleHotKeyManager.sharedManager;
    NSDictionary *defaultHotKeys = [SpectacleUtilities defaultHotKeysWithNames: SpectacleUtilities.hotKeyNames];

    for (NSString *hotKeyName in defaultHotKeys) {
        ZKHotKey *defaultHotKey = defaultHotKeys[hotKeyName];

        defaultHotKey.hotKeyAction = ^(ZKHotKey *hotKey) {
            [windowPositionManager moveFrontMostWindowWithAction: [windowPositionManager windowActionForHotKey: hotKey]];
        };

        [hotKeyManager registerHotKey: defaultHotKey];
    }
}

#pragma mark -

+ (void)updateHotKey: (ZKHotKey *)hotKey withPotentiallyNewDefaultHotKey: (ZKHotKey *)defaultHotKey {
    NSString *hotKeyName = hotKey.hotKeyName;
    NSInteger defaultHotKeyCode;
    
    if (![hotKeyName isEqualToString: SpectacleWindowActionMoveToLowerLeft] && ![hotKeyName isEqualToString: SpectacleWindowActionMoveToLowerRight]) {
        return;
    }
    
    defaultHotKeyCode = defaultHotKey.hotKeyCode;
    
    if ((hotKey.hotKeyCode == defaultHotKeyCode) && (hotKey.hotKeyModifiers == 768)) {
        hotKey.hotKeyCode = defaultHotKeyCode;
        
        hotKey.hotKeyModifiers = defaultHotKey.hotKeyModifiers;
    }
}

#pragma mark -

+ (NSDictionary *)defaultHotKeysWithNames: (NSArray *)names {
    NSBundle *bundle = NSBundle.mainBundle;
    NSString *path = [bundle pathForResource: SpectacleDefaultPreferencesPropertyListFile ofType: SpectaclePropertyListFileExtension];
    NSDictionary *applicationDefaults = [NSDictionary dictionaryWithContentsOfFile: path];
    NSMutableDictionary *defaultHotKeys = [NSMutableDictionary new];
    
    for (NSString *hotKeyName in names) {
        NSData *defaultHotKeyData = applicationDefaults[hotKeyName];
        ZKHotKey *defaultHotKey = [NSKeyedUnarchiver unarchiveObjectWithData: defaultHotKeyData];
        
        defaultHotKeys[hotKeyName] = defaultHotKey;
    }
    
    return defaultHotKeys;
}

#pragma mark -

+ (NSString *)pathForPreferencePaneNamed: (NSString *)preferencePaneName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSAllDomainsMask, YES);
    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSString *preferencePanePath = nil;

    if (preferencePaneName) {
        preferencePaneName = [preferencePaneName stringByAppendingFormat: @".%@", SpectaclePreferencePaneExtension];

        for (__strong NSString *path in paths) {
            path = [path stringByAppendingPathComponent: preferencePaneName];

            if (path && [fileManager fileExistsAtPath: path isDirectory: nil]) {
                preferencePanePath = path;

                break;
            }
        }

        if (!preferencePanePath) {
            NSLog(@"There was a problem obtaining the path for the specified preference pane: %@", preferencePaneName);
        }
    }

    return preferencePanePath;
}

#pragma mark -

+ (BOOL)isLoginItemEnabledForBundle: (NSBundle *)bundle {
    LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *applicationPath = bundle.bundlePath;
    BOOL result = NO;

    if (sharedFileList) {
        NSArray *sharedFileListArray = nil;
        UInt32 seedValue;

        sharedFileListArray = CFBridgingRelease(LSSharedFileListCopySnapshot(sharedFileList, &seedValue));

        for (id sharedFile in sharedFileListArray) {
            LSSharedFileListItemRef sharedFileListItem = (__bridge LSSharedFileListItemRef)sharedFile;
            CFURLRef applicationPathURL = NULL;

            LSSharedFileListItemResolve(sharedFileListItem, 0, (CFURLRef *)&applicationPathURL, NULL);

            if (applicationPathURL != NULL) {
                NSString *resolvedApplicationPath = [(__bridge NSURL *)applicationPathURL path];

                CFRelease(applicationPathURL);

                if ([resolvedApplicationPath compare: applicationPath] == NSOrderedSame) {
                    result = YES;

                    break;
                }
            }
        }

        CFRelease(sharedFileList);
    } else {
        NSLog(@"Unable to create the shared file list.");
    }

    return result;
}

#pragma mark -

+ (void)enableLoginItemForBundle: (NSBundle *)bundle {
    LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *applicationPath = bundle.bundlePath;
    NSURL *applicationPathURL = [NSURL fileURLWithPath: applicationPath];

    if (sharedFileList) {
        LSSharedFileListItemRef sharedFileListItem = LSSharedFileListInsertItemURL(sharedFileList, kLSSharedFileListItemLast, NULL, NULL, (__bridge CFURLRef)applicationPathURL, NULL, NULL);

        if (sharedFileListItem) {
            CFRelease(sharedFileListItem);
        }

        CFRelease(sharedFileList);
    } else {
        NSLog(@"Unable to create the shared file list.");
    }
}

+ (void)disableLoginItemForBundle: (NSBundle *)bundle {
    LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *applicationPath = bundle.bundlePath;

    if (sharedFileList) {
        NSArray *sharedFileListArray = nil;
        UInt32 seedValue;

        sharedFileListArray = CFBridgingRelease(LSSharedFileListCopySnapshot(sharedFileList, &seedValue));

        for (id sharedFile in sharedFileListArray) {
            LSSharedFileListItemRef sharedFileListItem = (__bridge LSSharedFileListItemRef)sharedFile;
            CFURLRef applicationPathURL;

            LSSharedFileListItemResolve(sharedFileListItem, 0, &applicationPathURL, NULL);

            if (applicationPathURL != NULL) {
                NSString *resolvedApplicationPath = [(__bridge NSURL *)applicationPathURL path];

                if ([resolvedApplicationPath compare: applicationPath] == NSOrderedSame) {
                    LSSharedFileListItemRemove(sharedFileList, sharedFileListItem);
                }

                CFRelease(applicationPathURL);
            }
        }

        CFRelease(sharedFileList);
    } else {
        NSLog(@"Unable to create the shared file list.");
    }
}

#pragma mark -

+ (NSMutableDictionary *)stringAttributesWithShadow {
    NSMutableParagraphStyle *paragraphStyle = NSParagraphStyle.defaultParagraphStyle.mutableCopy;
    NSShadow *textShadow = [NSShadow new];
    NSMutableDictionary *stringAttributes = [NSMutableDictionary new];

    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSCenterTextAlignment;

    textShadow.shadowColor = [NSColor whiteColor];
    textShadow.shadowOffset = NSMakeSize(0.0f, -1.0);
    textShadow.shadowBlurRadius = 0.0f;

    stringAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
    stringAttributes[NSShadowAttributeName] = textShadow;

    return stringAttributes;
}

@end

#pragma mark -

@implementation ZeroKitHotKey

@end
