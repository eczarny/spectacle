#import <Foundation/Foundation.h>

#import "SpectacleShortcutStorage.h"

@protocol SpectacleShortcutStorageMigrationDestination <SpectacleShortcutStorage>

@property (nonatomic, readonly, getter=isMigrationNeeded) BOOL migrationNeeded;

@end
