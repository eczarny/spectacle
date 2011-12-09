#import <Cocoa/Cocoa.h>
#import "SpectacleUtilities.h"

@class ZeroKitHotKeyAction;

@interface SpectaclePreferencePaneUtilities : SpectacleUtilities

+ (NSBundle *)preferencePaneBundle;

+ (NSBundle *)helperApplicationBundle;

#pragma mark -

+ (NSString *)preferencePaneVersion;

+ (NSString *)helperApplicationVersion;

#pragma mark -

+ (void)startSpectacle;

+ (void)stopSpectacle;

#pragma mark -

+ (BOOL)isSpectacleRunning;

#pragma mark -

+ (NSImage *)imageFromResource: (NSString *)resource;

@end
