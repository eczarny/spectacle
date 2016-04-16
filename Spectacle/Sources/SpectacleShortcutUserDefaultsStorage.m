#import "SpectacleShortcutUserDefaultsStorage.h"

@implementation SpectacleShortcutUserDefaultsStorage

+ (void)initialize
{
  [NSKeyedUnarchiver setClass:[SpectacleShortcut class] forClassName:@"SpectacleHotKey"];
  [NSKeyedUnarchiver setClass:[SpectacleShortcut class] forClassName:@"ZeroKitHotKey"];
  [NSKeyedUnarchiver setClass:[SpectacleShortcut class] forClassName:@"ZKHotKey"];
}

#pragma mark -

- (NSArray<SpectacleShortcut *> *)loadShortcutsWithAction:(SpectacleShortcutAction)action
{
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  NSMutableDictionary<NSString *, NSData *> *shortcutsFromUserDefaults = [NSMutableDictionary new];

  for (NSString *shortcutName in self.shortcutNames) {
    shortcutsFromUserDefaults[shortcutName] = [userDefaults dataForKey:shortcutName];
  }

  return [self shortcutsFromDictionary:shortcutsFromUserDefaults action:action];
}

- (NSArray<SpectacleShortcut *> *)defaultShortcutsWithAction:(SpectacleShortcutAction)action
{
  NSDictionary<NSString *, SpectacleShortcut *> *defaultShortcuts = [self defaultShortcutsWithNames:self.shortcutNames];
  NSMutableArray<SpectacleShortcut *> *shortcuts = [NSMutableArray new];

  for (NSString *shortcutName in defaultShortcuts) {
    SpectacleShortcut *defaultShortcut = defaultShortcuts[shortcutName];

    defaultShortcut.shortcutAction = action;

    [shortcuts addObject:defaultShortcut];
  }

  return shortcuts;
}

#pragma mark -

- (void)storeShortcuts: (NSArray<SpectacleShortcut *> *)shortcuts
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

- (NSArray<NSString *> *)shortcutNames
{
  return @[@"MoveToCenter",
           @"MoveToFullscreen",
           @"SetDimensions",
           @"MoveToLeftHalf",
           @"MoveToRightHalf",
           @"MoveToTopHalf",
           @"MoveToBottomHalf",
           @"MoveToUpperLeft",
           @"MoveToLowerLeft",
           @"MoveToUpperRight",
           @"MoveToLowerRight",
           @"MoveToNextDisplay",
           @"MoveToPreviousDisplay",
           @"MoveToNextThird",
           @"MoveToPreviousThird",
           @"MakeLarger",
           @"MakeSmaller",
           @"UndoLastMove",
           @"RedoLastMove"];
}

#pragma mark -

- (NSDictionary<NSString *, SpectacleShortcut *> *)defaultShortcutsWithNames:(NSArray<NSString *> *)names
{
  NSBundle *bundle = NSBundle.mainBundle;
  NSString *path = [bundle pathForResource:@"Defaults" ofType:@"plist"];

  NSDictionary *applicationDefaults = [NSDictionary dictionaryWithContentsOfFile:path];
  NSMutableDictionary<NSString *, SpectacleShortcut *> *defaultShortcuts = [NSMutableDictionary new];

  for (NSString *shortcutName in names) {
    NSData *defaultShortcutData = applicationDefaults[shortcutName];
    SpectacleShortcut *defaultShortcut = [NSKeyedUnarchiver unarchiveObjectWithData:defaultShortcutData];

    defaultShortcuts[shortcutName] = defaultShortcut;
  }

  return defaultShortcuts;
}

#pragma mark -

- (NSArray<SpectacleShortcut *> *)shortcutsFromDictionary:(NSDictionary<NSString *, NSData *> *)dictionary
                                                   action:(SpectacleShortcutAction)action
{
  NSDictionary<NSString *, SpectacleShortcut *> *defaultShortcuts = [self defaultShortcutsWithNames:dictionary.allKeys];
  NSMutableArray<SpectacleShortcut *> *shortcuts = [NSMutableArray new];

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

- (void)updateShortcut:(SpectacleShortcut *)shortcut withPotentiallyNewDefault:(SpectacleShortcut *)defaultShortcut
{
  NSString *shortcutName = shortcut.shortcutName;
  NSInteger defaultShortcutCode;

  if (![shortcutName isEqualToString:@"MoveToLowerLeft"] && ![shortcutName isEqualToString:@"MoveToLowerRight"]) {
    return;
  }

  defaultShortcutCode = defaultShortcut.shortcutCode;

  if ((shortcut.shortcutCode == defaultShortcutCode) && (shortcut.shortcutModifiers == 768)) {
    shortcut.shortcutCode = defaultShortcutCode;

    shortcut.shortcutModifiers = defaultShortcut.shortcutModifiers;
  }
}

@end
