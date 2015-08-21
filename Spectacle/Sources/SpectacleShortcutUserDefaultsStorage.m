#import "SpectacleConstants.h"
#import "SpectacleShortcutUserDefaultsStorage.h"

@interface ZKHotKey : SpectacleShortcut

@end

#pragma mark -

@implementation SpectacleShortcutUserDefaultsStorage

+ (NSArray *)loadShortcutsWithAction:(SpectacleShortcutAction)action
{
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  NSMutableDictionary *shortcutsFromUserDefaults = [NSMutableDictionary new];

  for (NSString *shortcutName in self.shortcutNames) {
    shortcutsFromUserDefaults[shortcutName] = [userDefaults dataForKey:shortcutName];
  }

  return [self shortcutsFromDictionary:shortcutsFromUserDefaults action:action];
}

+ (NSArray *)defaultShortcutsWithAction:(SpectacleShortcutAction)action
{
  NSDictionary *defaultShortcuts = [self defaultShortcutsWithNames:self.shortcutNames];
  NSMutableArray *shortcuts = [NSMutableArray new];

  for (NSString *shortcutName in defaultShortcuts) {
    SpectacleShortcut *defaultShortcut = defaultShortcuts[shortcutName];

    defaultShortcut.shortcutAction = action;

    [shortcuts addObject:defaultShortcut];
  }

  return shortcuts;
}

#pragma mark -

+ (void)storeShortcuts: (NSArray *)shortcuts
{
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;

  for (SpectacleShortcut *shortcut in shortcuts) {
    NSData *shortcutData = [NSKeyedArchiver archivedDataWithRootObject:shortcut];
    NSString *shortcutName = shortcut.shortcutName;

    if (![shortcutData isEqualToData:[userDefaults dataForKey:shortcutName]]) {
      [userDefaults setObject:shortcutData forKey:shortcutName];
    }
  }
}

#pragma mark -

+ (NSArray *)shortcutNames
{
  return @[SpectacleWindowActionMoveToCenter,
           SpectacleWindowActionMoveToFullscreen,
           SpectacleWindowActionMoveToLeftHalf,
           SpectacleWindowActionMoveToRightHalf,
           SpectacleWindowActionMoveToTopHalf,
           SpectacleWindowActionMoveToBottomHalf,
           SpectacleWindowActionMoveToUpperLeft,
           SpectacleWindowActionMoveToLowerLeft,
           SpectacleWindowActionMoveToUpperRight,
           SpectacleWindowActionMoveToLowerRight,
           SpectacleWindowActionMoveToNextDisplay,
           SpectacleWindowActionMoveToPreviousDisplay,
           SpectacleWindowActionMoveToNextThird,
           SpectacleWindowActionMoveToPreviousThird,
           SpectacleWindowActionMakeLarger,
           SpectacleWindowActionMakeSmaller,
           SpectacleWindowActionUndoLastMove,
           SpectacleWindowActionRedoLastMove];
}

#pragma mark -

+ (NSDictionary *)defaultShortcutsWithNames:(NSArray *)names
{
  NSBundle *bundle = NSBundle.mainBundle;
  NSString *path = [bundle pathForResource:SpectacleDefaultPreferencesPropertyListFile
                                    ofType:SpectaclePropertyListFileExtension];

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

+ (NSArray *)shortcutsFromDictionary:(NSDictionary *)dictionary action:(SpectacleShortcutAction)action
{
  NSDictionary *defaultShortcuts = [self defaultShortcutsWithNames:dictionary.allKeys];
  NSMutableArray *shortcuts = [NSMutableArray new];

  [NSKeyedUnarchiver setClass:ZKHotKey.class forClassName:@"SpectacleShortcut"];

  for (NSData *shortcutData in dictionary.allValues) {
    SpectacleShortcut *shortcut = [NSKeyedUnarchiver unarchiveObjectWithData:shortcutData];

    if (!shortcut.isClearedShortcut) {
      NSString *shortcutName = shortcut.shortcutName;

      shortcut.shortcutAction = action;

      [self updateShortcut:shortcut withPotentiallyNewDefault:defaultShortcuts[shortcutName]];

      [shortcuts addObject:shortcut];
    }
  }

  return shortcuts;
}

#pragma mark -

+ (void)updateShortcut:(SpectacleShortcut *)shortcut withPotentiallyNewDefault:(SpectacleShortcut *)defaultShortcut
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

@end

#pragma mark -

@implementation ZKHotKey

@end
