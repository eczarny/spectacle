#import "SpectacleShortcutUserDefaultsStorage.h"

@implementation SpectacleShortcutUserDefaultsStorage

+ (void)initialize
{
  [NSKeyedUnarchiver setClass:[SpectacleShortcut class] forClassName:@"SpectacleHotKey"];
  [NSKeyedUnarchiver setClass:[SpectacleShortcut class] forClassName:@"ZeroKitHotKey"];
  [NSKeyedUnarchiver setClass:[SpectacleShortcut class] forClassName:@"ZKHotKey"];
}

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
    [shortcuts addObject:[defaultShortcuts[shortcutName] copyWithShortcutAction:action]];
  }
  return shortcuts;
}

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

- (NSArray<NSString *> *)shortcutNames
{
  return @[
           @"MoveToCenter",
           @"MoveToFullscreen",
           @"MoveToLeftHalf",
           @"MoveToRightHalf",
           @"MoveToTopHalf",
           @"MoveToBottomHalf",
           @"MoveToUpperLeft",
           @"MoveToLowerLeft",
           @"MoveToUpperRight",
           @"MoveToLowerRight",
           @"MoveToUpperThirdRight",
           @"MoveToMiddleThirdRight",
           @"MoveToLowerThirdRight",
           @"MoveToUpperThirdLeft",
           @"MoveToMiddleThirdLeft",
           @"MoveToLowerThirdLeft",
           @"MoveToNextDisplay",
           @"MoveToPreviousDisplay",
           @"MoveToNextThird",
           @"MoveToPreviousThird",
           @"MakeLarger",
           @"MakeSmaller",
           @"UndoLastMove",
           @"RedoLastMove",
           ];
}

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

- (NSArray<SpectacleShortcut *> *)shortcutsFromDictionary:(NSDictionary<NSString *, NSData *> *)dictionary
                                                   action:(SpectacleShortcutAction)action
{
  NSMutableArray<SpectacleShortcut *> *shortcuts = [NSMutableArray new];
  for (NSData *shortcutData in dictionary.allValues) {
    SpectacleShortcut *shortcut = [NSKeyedUnarchiver unarchiveObjectWithData:shortcutData];
    [shortcuts addObject:[shortcut copyWithShortcutAction:action]];
  }
  return shortcuts;
}

@end
