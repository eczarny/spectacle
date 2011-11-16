#import <Cocoa/Cocoa.h>
#import "SpectacleHelperControllerProtocol.h"

@class SpectacleHotKeyManager, SpectacleHelperApplicationController, SpectacleHotKey;

@interface SpectacleHelperController : NSObject<SpectacleHelperControllerProtocol> {
    SpectacleHotKeyManager *myHotKeyManager;
    IBOutlet SpectacleHelperApplicationController *myHelperApplicationController;
}

- (SpectacleHotKey *)registeredHotKeyForName: (NSString *)name;

#pragma mark -

- (void)updateHotKeyWithKeyCode: (NSInteger)keyCode modifiers: (NSInteger)modifiers name: (NSString *)name;

#pragma mark -

- (void)unregisterHotKeyWithName: (NSString *)name;

#pragma mark -

- (BOOL)automaticallyChecksForUpdates;

- (void)setAutomaticallyChecksForUpdates: (BOOL)automaticallyChecksForUpdates;

@end
