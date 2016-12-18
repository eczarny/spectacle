#import "SpectacleShortcutJSONStorage.h"

@implementation SpectacleShortcutJSONStorage

- (NSArray<SpectacleShortcut *> *)loadShortcutsWithAction:(SpectacleShortcutAction)action
{
  NSError *error;
  NSURL *shortcutsFileURL = findShortcutsFileURL(&error);
  if (!shortcutsFileURL) {
    NSLog(@"Unable to locate the shortcuts file: %@", error.localizedDescription);
    return nil;
  }
  NSData *content = [NSData dataWithContentsOfURL:shortcutsFileURL];
  NSArray<NSDictionary *> *jsonArray = [NSJSONSerialization JSONObjectWithData:content
                                                                       options:0
                                                                         error:&error];
  if (!jsonArray) {
    NSLog(@"Deserializing shortcuts failed: %@", error.localizedDescription);
    return nil;
  }
  return shortcutsFromJsonObject(jsonArray, action);
}

- (void)storeShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts
{
  NSError *error;
  NSURL *shortcutsFileURL = findShortcutsFileURL(&error);
  if (!shortcutsFileURL) {
    NSLog(@"Unable to locate the shortcuts file: %@", error.localizedDescription);
    return;
  }
  NSData *contents = [NSJSONSerialization dataWithJSONObject:jsonObjectFromShortcuts(shortcuts)
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  if (![contents writeToURL:shortcutsFileURL atomically:YES]) {
    NSLog(@"Unable to store shortcuts at location: %@", [shortcutsFileURL path]);
  }
}

- (BOOL)isMigrationNeeded
{
  NSError *error;
  NSURL *shortcutsFileURL = findShortcutsFileURL(&error);
  if (!shortcutsFileURL) {
    NSLog(@"Unable to locate the shortcuts file: %@", error.localizedDescription);
    return YES;
  }
  return ![[NSFileManager defaultManager] fileExistsAtPath:[shortcutsFileURL path]];
}

static NSURL *findShortcutsFileURL(NSError **error)
{
  NSURL *shortcutsFileURL = [findOrCreateSpectacleDirectory(error) URLByAppendingPathComponent:@"Shortcuts.json"];
  return shortcutsFileURL.URLByResolvingSymlinksInPath;
}

static NSURL *findOrCreateSpectacleDirectory(NSError **error)
{
  NSURL *applicationSupportDirectory = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:YES
                                                                                 error:error];
  if (!applicationSupportDirectory) {
    return nil;
  }
  NSURL *spectacleDirectory = [applicationSupportDirectory URLByAppendingPathComponent:@"Spectacle"];
  BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:spectacleDirectory
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:error];
  if (!success) {
    return nil;
  }
  return spectacleDirectory;
}

static NSArray<NSDictionary *> *jsonObjectFromShortcuts(NSArray<SpectacleShortcut *> *shortcuts)
{
  NSMutableArray<NSDictionary *> *jsonArray = [NSMutableArray new];
  for (SpectacleShortcut *shortcut in shortcuts) {
    [jsonArray addObject:@{
                           @"shortcut_name" : shortcut.shortcutName,
                           @"shortcut_key_binding" : shortcut.shortcutKeyBinding ?: [NSNull null],
                           }];
  }
  return jsonArray;
}

static NSArray<SpectacleShortcut *> *shortcutsFromJsonObject(NSArray<NSDictionary *> *jsonArray, SpectacleShortcutAction action)
{
  NSMutableArray<SpectacleShortcut *> *shortcuts = [NSMutableArray new];
  for (NSDictionary *jsonObject in jsonArray) {
    NSString *shortcutName = jsonObject[@"shortcut_name"];
    NSString *shortcutKeyBinding = jsonObject[@"shortcut_key_binding"];
    [shortcuts addObject:[[SpectacleShortcut alloc] initWithShortcutName:shortcutName
                                                      shortcutKeyBinding:[shortcutKeyBinding isKindOfClass:[NSNull class]] ? nil : shortcutKeyBinding
                                                          shortcutAction:action]];
  }
  return shortcuts;
}

@end
