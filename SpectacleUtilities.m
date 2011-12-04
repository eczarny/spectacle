#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectacleUtilities (SpectacleUtilitiesPrivate)

+ (NSString *)versionOfBundle: (NSBundle *)bundle;

#pragma mark -

+ (void)updateHotKey: (ZeroKitHotKey *)hotKey withPotentiallyNewDefaultHotKey: (ZeroKitHotKey *)defaultHotKey;

#pragma mark -

+ (NSDictionary *)defaultHotKeysWithNames: (NSArray *)names;

@end

#pragma mark -

@implementation SpectacleUtilities

+ (NSBundle *)preferencePaneBundle {
    NSString *preferencePanePath = [SpectacleUtilities pathForPreferencePaneNamed: SpectaclePreferencePaneName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSBundle *preferencePaneBundle = nil;
    
    if (preferencePanePath && [fileManager fileExistsAtPath: preferencePanePath isDirectory: nil]) {
        preferencePaneBundle = [NSBundle bundleWithPath: preferencePanePath];
    }
    
    if (!preferencePaneBundle) {
        NSLog(@"The preference pane does not exist at path: %@", preferencePanePath);
    }
    
    return preferencePaneBundle;
}

+ (NSBundle *)helperApplicationBundle {
    NSBundle *preferencePaneBundle = [SpectacleUtilities preferencePaneBundle];
    NSURL *bundleURL = [preferencePaneBundle URLForResource: SpectacleHelperApplicationName withExtension: SpectacleApplicationBundleExtension];
    NSBundle *helperApplicationBundle = nil;
    
    if (preferencePaneBundle && bundleURL) {
        helperApplicationBundle = [NSBundle bundleWithURL: bundleURL];
    } else {
        helperApplicationBundle = [NSBundle mainBundle];
    }
    
    return helperApplicationBundle;
}

#pragma mark -

+ (NSString *)preferencePaneVersion {
    return [SpectacleUtilities versionOfBundle: [SpectacleUtilities preferencePaneBundle]];
}

+ (NSString *)helperApplicationVersion {
    return [SpectacleUtilities versionOfBundle: [SpectacleUtilities helperApplicationBundle]];
}

+ (NSString *)standaloneApplicationVersion {
    return [SpectacleUtilities versionOfBundle: [SpectacleUtilities applicationBundle]];
}

#pragma mark -

+ (void)displayAccessibilityAPIAlert {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    NSURL *preferencePaneURL = [NSURL fileURLWithPath: [SpectacleUtilities pathForPreferencePaneNamed: @"UniversalAccessPref"]];
    
    [alert setAlertStyle: NSWarningAlertStyle];
    [alert setMessageText: ZeroKitLocalizedString(@"Spectacle requires that the Accessibility API be enabled")];
    [alert setInformativeText: ZeroKitLocalizedString(@"Would you like to open the Universal Access preferences so that you can turn on \"Enable access for assistive devices\"?")];
    [alert addButtonWithTitle: ZeroKitLocalizedString(@"Open Universal Access Preferences")];
    [alert addButtonWithTitle: ZeroKitLocalizedString(@"Stop Spectacle")];
    
    switch ([alert runModal]) {
        case NSAlertFirstButtonReturn:
            [[NSWorkspace sharedWorkspace] openURL: preferencePaneURL];
            
            break;
        case NSAlertSecondButtonReturn:
        default:
            break;
    }
}

+ (void)displayRunningInBackgroundAlertWithCallback: (void ( ^ )(BOOL, BOOL))callback {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    
    [alert setAlertStyle: NSInformationalAlertStyle];
    [alert setShowsSuppressionButton: YES];
    [alert setMessageText: ZeroKitLocalizedString(@"This will cause Spectacle to run in the background")];
    [alert setInformativeText: ZeroKitLocalizedString(@"Running Spectacle in the background, without a menu in the status bar.\n\nTo access Spectacle's preferences click on Spectacle in Launchpad, or open Spectacle in Finder.")];
    [alert addButtonWithTitle: ZeroKitLocalizedString(@"OK")];
    [alert addButtonWithTitle: ZeroKitLocalizedString(@"Cancel")];
    
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

+ (void)startSpectacle {
    NSWorkspace *sharedWorkspace = [NSWorkspace sharedWorkspace];
    NSBundle *helperApplicationBundle = [SpectacleUtilities helperApplicationBundle];
    NSURL *helperApplicationURL = nil;
    
    if ([SpectacleUtilities isSpectacleRunning]) {
        NSLog(@"Unable to start the Spectacle helper application as it is already running.");
        
        return;
    }
    
    if (!helperApplicationBundle) {
        NSLog(@"Unable to locate the Spectacle helper application bundle.");
    } else {
        helperApplicationURL = [helperApplicationBundle bundleURL];
        
        [sharedWorkspace launchApplicationAtURL: helperApplicationURL
                                        options: NSWorkspaceLaunchWithoutAddingToRecents | NSWorkspaceLaunchAsync
                                  configuration: nil
                                          error: nil];
    }
}

+ (void)stopSpectacle {
    if (![SpectacleUtilities isSpectacleRunning]) {
        NSLog(@"Unable to stop the Spectacle helper application as it is not running.");
        
        return;
    }
    
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName: SpectacleHelperShouldTerminateNotification
                                                                   object: nil
                                                                 userInfo: nil
                                                       deliverImmediately: YES];
}

#pragma mark -

+ (BOOL)isSpectacleRunning {
    NSArray *runningApplications = [NSRunningApplication runningApplicationsWithBundleIdentifier: SpectacleHelperBundleIdentifier];
    
    if (runningApplications && ([runningApplications count] > 0)) {
        return YES;
    }
    
    return NO;
}

#pragma mark -

+ (NSArray *)hotKeyNames {
    NSBundle *bundle = [SpectacleUtilities helperApplicationBundle];
    NSString *path = [bundle pathForResource: SpectacleHotKeyNamesPropertyListFile ofType: ZeroKitPropertyListFileExtension];
    NSArray *hotKeyNames = [NSArray arrayWithContentsOfFile: path];
    
    return hotKeyNames;
}

#pragma mark -

+ (NSArray *)hotKeysFromDictionary: (NSDictionary *)dictionary hotKeyTarget: (id)target {
    NSDictionary *defaultHotKeys = [SpectacleUtilities defaultHotKeysWithNames: [dictionary allKeys]];
    NSMutableArray *hotKeys = [NSMutableArray array];
    
    [NSKeyedUnarchiver setClass: [ZeroKitHotKey class] forClassName: @"SpectacleHotKey"];
    
    for (NSData *hotKeyData in [dictionary allValues]) {
        ZeroKitHotKey *hotKey = [NSKeyedUnarchiver unarchiveObjectWithData: hotKeyData];
        
        if (![hotKey isClearedHotKey]) {
            NSString *hotKeyName = [hotKey hotKeyName];
            
            [hotKey setHotKeyAction: [SpectacleUtilities actionForHotKeyWithName: hotKeyName target: target]];
            
            [SpectacleUtilities updateHotKey: hotKey withPotentiallyNewDefaultHotKey: [defaultHotKeys objectForKey: hotKeyName]];
            
            [hotKeys addObject: hotKey];
        }
    }
    
    return hotKeys;
}

#pragma mark -

+ (ZeroKitHotKeyAction *)actionForHotKeyWithName: (NSString *)name target: (id)target {
    SEL selector = NULL;
    
    if ([name isEqualToString: SpectacleWindowActionMoveToCenter]) {
        selector = @selector(moveFrontMostWindowToCenter:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToFullscreen]) {
        selector = @selector(moveFrontMostWindowToFullscreen:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLeftHalf]) {
        selector = @selector(moveFrontMostWindowToLeftHalf:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToRightHalf]) {
        selector = @selector(moveFrontMostWindowToRightHalf:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToTopHalf]) {
        selector = @selector(moveFrontMostWindowToTopHalf:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToBottomHalf]) {
        selector = @selector(moveFrontMostWindowToBottomHalf:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToUpperLeft]) {
        selector = @selector(moveFrontMostWindowToUpperLeft:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLowerLeft]) {
        selector = @selector(moveFrontMostWindowToLowerLeft:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToUpperRight]) {
        selector = @selector(moveFrontMostWindowToUpperRight:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLowerRight]) {
        selector = @selector(moveFrontMostWindowToLowerRight:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLeftDisplay]) {
        selector = @selector(moveFrontMostWindowToLeftDisplay:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToRightDisplay]) {
        selector = @selector(moveFrontMostWindowToRightDisplay:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToTopDisplay]) {
        selector = @selector(moveFrontMostWindowToTopDisplay:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToBottomDisplay]) {
        selector = @selector(moveFrontMostWindowToBottomDisplay:);
    } else if ([name isEqualToString: SpectacleWindowActionUndoLastMove]) {
        selector = @selector(undoLastWindowAction:);
    } else if ([name isEqualToString: SpectacleWindowActionRedoLastMove]) {
        selector = @selector(redoLastWindowAction:);
    }
    
    return [ZeroKitHotKeyAction hotKeyActionFromTarget: target selector: selector];
}

#pragma mark -

+ (NSInteger)currentWorkspace {
    CGWindowListOption options = kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements;
    CFArrayRef windows = CGWindowListCreate(options, kCGNullWindowID);
    CFArrayRef windowDescriptions = CGWindowListCreateDescriptionFromArray(windows);
    NSInteger currentWorkspace = 0;
    
    for (NSInteger i = 0; i < CFArrayGetCount(windowDescriptions); i++) {
        CFDictionaryRef windowDescription = CFArrayGetValueAtIndex(windowDescriptions, i);
        NSNumber *workspace = (NSNumber *)CFDictionaryGetValue(windowDescription, kCGWindowWorkspace);
        
        if (workspace) {
            currentWorkspace = [workspace integerValue];
            
            break;
        }
    }
    
    CFRelease(windows);
    CFRelease(windowDescriptions);
    
    return currentWorkspace;
}

#pragma mark -

+ (NSImage *)imageFromResource: (NSString *)resource {
    return [SpectacleUtilities imageFromResource: resource inBundle: [SpectacleUtilities preferencePaneBundle]];
}

@end

#pragma mark -

@implementation SpectacleUtilities (SpectacleUtilitiesPrivate)

+ (NSString *)versionOfBundle: (NSBundle *)bundle {
    NSString *bundleVersion = [bundle objectForInfoDictionaryKey: ZeroKitApplicationBundleShortVersionString];
    
    if (!bundleVersion) {
        bundleVersion = [bundle objectForInfoDictionaryKey: ZeroKitApplicationBundleVersion];
    }
    
    return bundleVersion;
}

#pragma mark -

+ (void)updateHotKey: (ZeroKitHotKey *)hotKey withPotentiallyNewDefaultHotKey: (ZeroKitHotKey *)defaultHotKey {
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
    NSBundle *bundle = [SpectacleUtilities helperApplicationBundle];
    NSString *path = [bundle pathForResource: ZeroKitDefaultPreferencesFile ofType: ZeroKitPropertyListFileExtension];
    NSDictionary *applicationDefaults = [NSDictionary dictionaryWithContentsOfFile: path];
    NSMutableDictionary *defaultHotKeys = [NSMutableDictionary dictionary];
    
    for (NSString *hotKeyName in names) {
        NSData *defaultHotKeyData = [applicationDefaults objectForKey: hotKeyName];
        ZeroKitHotKey *defaultHotKey = [NSKeyedUnarchiver unarchiveObjectWithData: defaultHotKeyData];
        
        [defaultHotKeys setObject: defaultHotKey forKey: hotKeyName];
    }
    
    return defaultHotKeys;
}

@end
