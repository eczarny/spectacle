#import <Cocoa/Cocoa.h>

#import "SpectacleShortcutJSONStorage.h"

@implementation SpectacleShortcutJSONStorage

- (NSArray<SpectacleShortcut *> *)loadShortcutsWithAction:(SpectacleShortcutAction)action
{
  NSError *error;
  NSURL *shortcutsURL = findShortcutsFileURL(&error);
  if (!shortcutsURL) {
    NSLog(@"Unable to locate the shortcuts file: %@", error.localizedDescription);
    return nil;
  }
  NSData *content = [NSData dataWithContentsOfURL:shortcutsURL];
  NSArray<NSDictionary *> *jsonArray = [NSJSONSerialization JSONObjectWithData:content
                                                                       options:0
                                                                         error:&error];
  if (!jsonArray) {
    NSLog(@"Deserializing shortcuts failed: %@", error.localizedDescription);
    return nil;
  }
  return shortcutsFromJsonObject(jsonArray);
}

- (void)storeShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts
{
  NSError *error;
  NSURL *shortcutsURL = findShortcutsFileURL(&error);
  if (!shortcutsURL) {
    NSLog(@"Unable to locate the shortcuts file: %@", error.localizedDescription);
    return;
  }
  NSData *contents = [NSJSONSerialization dataWithJSONObject:jsonObjectFromShortcuts(shortcuts)
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  if (![contents writeToURL:shortcutsURL atomically:YES]) {
    NSLog(@"Unable to store shortcuts at location: %@", [shortcutsURL path]);
  }
}

- (BOOL)isMigrationNeeded
{
  NSError *error;
  NSURL *shortcutsURL = findShortcutsFileURL(&error);
  if (!shortcutsURL) {
    NSLog(@"Unable to locate the shortcuts file: %@", error.localizedDescription);
    return YES;
  }
  return ![[NSFileManager defaultManager] fileExistsAtPath:[shortcutsURL path]];
}

static NSURL *findShortcutsFileURL(NSError **error)
{
  return [findOrCreateSpectacleDirectory(error) URLByAppendingPathComponent:@"Shortcuts.json"];
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
                           @"shortcut_code" : @(shortcut.shortcutCode),
                           @"shortcut_modifiers" : @(shortcut.shortcutModifiers),
                           }];
  }
  return jsonArray;
}

static NSArray<SpectacleShortcut *> *shortcutsFromJsonObject(NSArray<NSDictionary *> *jsonArray)
{
  NSMutableArray<SpectacleShortcut *> *shortcuts = [NSMutableArray new];
  for (NSDictionary *jsonObject in jsonArray) {
    NSString *shortcutName = jsonObject[@"shortcut_name"];
    NSNumber *shortcutCode = jsonObject[@"shortcut_code"];
    NSNumber *shortcutModifiers = jsonObject[@"shortcut_modifiers"];
    [shortcuts addObject:[[SpectacleShortcut alloc] initWithShortcutName:shortcutName
                                                            shortcutCode:[shortcutCode integerValue]
                                                       shortcutModifiers:[shortcutModifiers unsignedIntegerValue]]];
  }
  return shortcuts;
}

@end
