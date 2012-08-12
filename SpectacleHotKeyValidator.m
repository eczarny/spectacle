#import "SpectacleHotKeyValidator.h"
#import "SpectacleHotKeyManager.h"

@implementation SpectacleHotKeyValidator

- (BOOL)isHotKeyValid: (ZeroKitHotKey *)hotKey {
    return ![[SpectacleHotKeyManager sharedManager] isHotKeyRegistered: hotKey];
}

@end
