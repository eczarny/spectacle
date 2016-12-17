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
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:shortcutsFileURL error:&error];
  if (!fileHandle) {
    NSLog(@"Unable to read shortcuts file: %@", error.localizedDescription);
    return nil;
  }
  NSData *contents = [fileHandle readDataToEndOfFile];
  [fileHandle closeFile];
  if (!contents.length) {
    return nil;
  }
  NSArray<NSDictionary *> *jsonArray = [NSJSONSerialization JSONObjectWithData:contents
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
  if (!contents) {
    NSLog(@"Serializing shortcuts failed: %@", error.localizedDescription);
    return;
  }
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingToURL:shortcutsFileURL error:&error];
  if (!fileHandle) {
    NSLog(@"Unable to write shortcuts file: %@", error.localizedDescription);
    return;
  }
  [fileHandle writeData:contents];
  [fileHandle closeFile];
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
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:[shortcutsFileURL path]]) {
    [fileManager createFileAtPath:[shortcutsFileURL path]
                         contents:nil
                       attributes:nil];
  }
  return shortcutsFileURL;
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
