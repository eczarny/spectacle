#import "SpectacleMigratingShortcutStorage.h"

#import "SpectacleShortcutStorageMigrationDestination.h"

@implementation SpectacleMigratingShortcutStorage
{
  id<SpectacleShortcutStorage> _shortcutStorage;
  id<SpectacleShortcutStorageMigrationDestination> _migrationDestination;
}

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorage>)shortcutStorage
                   migrationDestination:(id<SpectacleShortcutStorageMigrationDestination>)migrationDestination
{
  if (self = [super init]) {
    _shortcutStorage = shortcutStorage;
    _migrationDestination = migrationDestination;
  }
  return self;
}

- (NSArray<SpectacleShortcut *> *)loadShortcutsWithAction:(SpectacleShortcutAction)action
{
  return _migrationDestination.isMigrationNeeded ? [_shortcutStorage loadShortcutsWithAction:action] : [_migrationDestination loadShortcutsWithAction:action];
}

- (void)storeShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts
{
  [_migrationDestination storeShortcuts:shortcuts];
}

@end
