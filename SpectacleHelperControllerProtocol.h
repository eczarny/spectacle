#import <Cocoa/Cocoa.h>

@class ZeroKitHotKey;

@protocol SpectacleHelperControllerProtocol

- (bycopy ZeroKitHotKey *)registeredHotKeyForName: (NSString *)name;

#pragma mark -

- (oneway void)updateHotKeyWithKeyCode: (NSInteger)keyCode modifiers: (NSInteger)modifiers name: (NSString *)name;

#pragma mark -

- (oneway void)unregisterHotKeyWithName: (NSString *)name;

#pragma mark -

- (BOOL)automaticallyChecksForUpdates;

- (oneway void)setAutomaticallyChecksForUpdates: (BOOL)automaticallyChecksForUpdates;

@end
