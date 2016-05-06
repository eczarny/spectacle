#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"
#import "SpectacleShortcutStorage.h"

@protocol SpectacleShortcutStorageMigrationDestination;

@interface SpectacleMigratingShortcutStorage : NSObject <SpectacleShortcutStorage>

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorage>)shortcutStorage
                   migrationDestination:(id<SpectacleShortcutStorageMigrationDestination>)migrationDestination NS_DESIGNATED_INITIALIZER;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

@end
