#import <Foundation/Foundation.h>

#import "SpectacleShortcut.h"

@interface SpectacleUtilities : NSObject

+ (NSString *)applicationVersion;

#pragma mark -

+ (void)registerDefaultsForBundle:(NSBundle *)bundle;

#pragma mark -

+ (void)displayRunningInBackgroundAlertWithCallback:(void (^)(BOOL, BOOL))callback;

+ (void)displayRestoreDefaultsAlertWithCallback:(void (^)(BOOL))callback;

#pragma mark -

+ (NSArray *)shortcutNames;

#pragma mark -

+ (NSArray *)shortcutsFromDictionary:(NSDictionary *)dictionary action:(SpectacleShortcutAction)action;

#pragma mark -

+ (void)restoreDefaultShortcuts;

#pragma mark -

+ (NSString *)pathForPreferencePaneNamed:(NSString *)preferencePaneName;

@end
