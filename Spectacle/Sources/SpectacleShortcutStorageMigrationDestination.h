#import <Foundation/Foundation.h>

#import "SpectacleShortcutStorage.h"

@protocol SpectacleShortcutStorageMigrationDestination <SpectacleShortcutStorage>

@property (nonatomic, readonly, assign, getter=isMigrationNeeded) BOOL migrationNeeded;

@end
