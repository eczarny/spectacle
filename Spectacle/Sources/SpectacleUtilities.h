#import <Cocoa/Cocoa.h>

@interface SpectacleUtilities : NSObject

+ (NSString *)applicationVersion;

#pragma mark -

+ (void)registerDefaultsForBundle:(NSBundle *)bundle;

#pragma mark -

+ (void)displayRunningInBackgroundAlertWithCallback:(void (^)(BOOL, BOOL))callback;

+ (void)displayRestoreDefaultsAlertWithConfirmationCallback:(void (^)())callback;

#pragma mark -

+ (NSString *)pathForPreferencePaneNamed:(NSString *)preferencePaneName;

@end
