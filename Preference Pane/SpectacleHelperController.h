#import <Cocoa/Cocoa.h>
#import "SpectacleHelperControllerProtocol.h"

@class SpectacleHotKeyManager, SpectacleHelperApplicationController, ZeroKitHotKey;

@interface SpectacleHelperController : NSObject<SpectacleHelperControllerProtocol> {
    SpectacleHotKeyManager *myHotKeyManager;
    IBOutlet SpectacleHelperApplicationController *myHelperApplicationController;
}

- (ZeroKitHotKey *)registeredHotKeyForName: (NSString *)name;

#pragma mark -

- (void)updateHotKeyWithKeyCode: (NSInteger)keyCode modifiers: (NSInteger)modifiers name: (NSString *)name;

#pragma mark -

- (void)unregisterHotKeyWithName: (NSString *)name;

@end
