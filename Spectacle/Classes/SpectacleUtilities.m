#import "SpectacleUtilities.h"

#import "SpectacleConstants.h"
#import "SpectacleShortcutManager.h"
#import "SpectacleWindowPositionManager.h"

extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));

@interface ZKHotKey : SpectacleShortcut

@end

#pragma mark -

@implementation SpectacleUtilities

+ (NSString *)applicationVersion
{
  NSBundle *bundle = NSBundle.mainBundle;
  NSString *bundleVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

  if (!bundleVersion) {
    bundleVersion = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
  }

  return bundleVersion;
}

#pragma mark -

+ (void)registerDefaultsForBundle:(NSBundle *)bundle
{
  NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
  NSString *path = [bundle pathForResource:SpectacleDefaultPreferencesPropertyListFile ofType:SpectaclePropertyListFileExtension];
  NSDictionary *applicationDefaults = [[NSDictionary alloc] initWithContentsOfFile:path];

  [defaults registerDefaults:applicationDefaults];
}

#pragma mark -

+ (void)displayRunningInBackgroundAlertWithCallback:(void (^)(BOOL, BOOL))callback
{
  NSAlert *alert = [NSAlert new];
  
  alert.alertStyle = NSInformationalAlertStyle;
  alert.showsSuppressionButton = YES;
  alert.messageText = LocalizedString(@"This will cause Spectacle to run in the background");
  alert.informativeText = LocalizedString(@"Run Spectacle in the background without a menu in the status bar.\n\nTo access Spectacle's preferences click on Spectacle in Launchpad, or open Spectacle in Finder.");
  
  [alert addButtonWithTitle:LocalizedString(@"OK")];
  [alert addButtonWithTitle:LocalizedString(@"Cancel")];
  
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

+ (void)displayRestoreDefaultsAlertWithCallback:(void (^)(BOOL))callback
{
  NSAlert *alert = [NSAlert new];

  alert.messageText = LocalizedString(@"This will restore Spectacle's default hot keys");
  alert.informativeText = LocalizedString(@"Would you like to restore the default hot keys? Any custom hot keys will be lost.");

  [alert addButtonWithTitle:LocalizedString(@"OK")];
  [alert addButtonWithTitle:LocalizedString(@"Cancel")];

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

+ (SpectacleApplicationTrust)spectacleTrust
{
  BOOL result = SpectacleIsTrusted;
  
  if ((AXIsProcessTrustedWithOptions != NULL) && !AXIsProcessTrustedWithOptions(NULL)) {
    result = SpectacleIsNotTrusted;
  }
  
  return result;
}

#pragma mark -

+ (NSArray *)shortcutNames
{
  NSBundle *bundle = NSBundle.mainBundle;
  NSString *path = [bundle pathForResource:SpectacleShortcutNamesPropertyListFile ofType:SpectaclePropertyListFileExtension];
  NSArray *shortcutNames = [NSArray arrayWithContentsOfFile:path];
  
  return shortcutNames;
}

#pragma mark -

+ (NSArray *)shortcutsFromDictionary:(NSDictionary *)dictionary action:(SpectacleShortcutAction)action
{
  NSDictionary *defaultShortcuts = [SpectacleUtilities defaultShortcutsWithNames:dictionary.allKeys];
  NSMutableArray *shortcuts = [NSMutableArray new];
  
  [NSKeyedUnarchiver setClass:ZKHotKey.class forClassName:@"SpectacleShortcut"];
  
  for (NSData *shortcutData in dictionary.allValues) {
    SpectacleShortcut *shortcut = [NSKeyedUnarchiver unarchiveObjectWithData:shortcutData];
    
    if (![shortcut isClearedShortcut]) {
      NSString *shortcutName = shortcut.shortcutName;
      
      shortcut.shortcutAction = action;
      
      [SpectacleUtilities updateShortcut:shortcut withPotentiallyNewDefaultShortcut:defaultShortcuts[shortcutName]];
      
      [shortcuts addObject:shortcut];
    }
  }
  
  return shortcuts;
}

#pragma mark -

+ (void)restoreDefaultShortcuts
{
  SpectacleWindowPositionManager *windowPositionManager = SpectacleWindowPositionManager.sharedManager;
  SpectacleShortcutManager *shortcutManager = SpectacleShortcutManager.sharedManager;
  NSDictionary *defaultShortcuts = [SpectacleUtilities defaultShortcutsWithNames:SpectacleUtilities.shortcutNames];

  for (NSString *shortcutName in defaultShortcuts) {
    SpectacleShortcut *defaultShortcut = defaultShortcuts[shortcutName];

    defaultShortcut.shortcutAction = ^(SpectacleShortcut *shortcut) {
      [windowPositionManager moveFrontMostWindowWithAction:[windowPositionManager windowActionForShortcut:shortcut]];
    };

    [shortcutManager registerShortcut:defaultShortcut];
  }
}

#pragma mark -

+ (void)updateShortcut:(SpectacleShortcut *)shortcut withPotentiallyNewDefaultShortcut:(SpectacleShortcut *)defaultShortcut
{
  NSString *shortcutName = shortcut.shortcutName;
  NSInteger defaultShortcutCode;
  
  if (![shortcutName isEqualToString:SpectacleWindowActionMoveToLowerLeft]
    && ![shortcutName isEqualToString:SpectacleWindowActionMoveToLowerRight]) {
    return;
  }
  
  defaultShortcutCode = defaultShortcut.shortcutCode;
  
  if ((shortcut.shortcutCode == defaultShortcutCode) && (shortcut.shortcutModifiers == 768)) {
    shortcut.shortcutCode = defaultShortcutCode;
    
    shortcut.shortcutModifiers = defaultShortcut.shortcutModifiers;
  }
}

#pragma mark -

+ (NSDictionary *)defaultShortcutsWithNames:(NSArray *)names
{
  NSBundle *bundle = NSBundle.mainBundle;
  NSString *path = [bundle pathForResource:SpectacleDefaultPreferencesPropertyListFile ofType:SpectaclePropertyListFileExtension];
  NSDictionary *applicationDefaults = [NSDictionary dictionaryWithContentsOfFile:path];
  NSMutableDictionary *defaultShortcuts = [NSMutableDictionary new];
  
  for (NSString *shortcutName in names) {
    NSData *defaultShortcutData = applicationDefaults[shortcutName];
    SpectacleShortcut *defaultShortcut = [NSKeyedUnarchiver unarchiveObjectWithData:defaultShortcutData];
    
    defaultShortcuts[shortcutName] = defaultShortcut;
  }
  
  return defaultShortcuts;
}

#pragma mark -

+ (NSString *)pathForPreferencePaneNamed:(NSString *)preferencePaneName
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSAllDomainsMask, YES);
  NSFileManager *fileManager = NSFileManager.defaultManager;
  NSString *preferencePanePath = nil;

  if (preferencePaneName) {
    preferencePaneName = [preferencePaneName stringByAppendingFormat:@".%@", SpectaclePreferencePaneExtension];

    for (__strong NSString *path in paths) {
      path = [path stringByAppendingPathComponent:preferencePaneName];

      if (path && [fileManager fileExistsAtPath:path isDirectory:nil]) {
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

+ (BOOL)isLoginItemEnabledForBundle:(NSBundle *)bundle
{
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

        if ([resolvedApplicationPath compare:applicationPath] == NSOrderedSame) {
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

+ (void)enableLoginItemForBundle:(NSBundle *)bundle
{
  LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
  NSString *applicationPath = bundle.bundlePath;
  NSURL *applicationPathURL = [NSURL fileURLWithPath:applicationPath];

  if (sharedFileList) {
    LSSharedFileListItemRef sharedFileListItem = LSSharedFileListInsertItemURL(sharedFileList,
                                                                               kLSSharedFileListItemLast,
                                                                               NULL,
                                                                               NULL,
                                                                               (__bridge CFURLRef)applicationPathURL,
                                                                               NULL,
                                                                               NULL);

    if (sharedFileListItem) {
      CFRelease(sharedFileListItem);
    }

    CFRelease(sharedFileList);
  } else {
    NSLog(@"Unable to create the shared file list.");
  }
}

+ (void)disableLoginItemForBundle:(NSBundle *)bundle
{
  LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
  NSString *applicationPath = bundle.bundlePath;

  if (sharedFileList) {
    NSArray *sharedFileListArray = nil;
    UInt32 seedValue;

    sharedFileListArray = CFBridgingRelease(LSSharedFileListCopySnapshot(sharedFileList, &seedValue));

    for (id sharedFile in sharedFileListArray) {
      LSSharedFileListItemRef sharedFileListItem = (__bridge LSSharedFileListItemRef)sharedFile;
      CFURLRef applicationPathURL;

      if (LSSharedFileListItemResolve(sharedFileListItem, 0, &applicationPathURL, NULL) == noErr) {
        NSString *resolvedApplicationPath = [(__bridge NSURL *)applicationPathURL path];

        if ([resolvedApplicationPath compare:applicationPath] == NSOrderedSame) {
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

+ (NSMutableDictionary *)stringAttributesWithShadow
{
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

@implementation ZKHotKey

@end
