#import "SpectacleHotKeyValidator.h"

#import "SpectacleHotKeyManager.h"

@implementation SpectacleHotKeyValidator

- (BOOL)isHotKeyValid:(ZKHotKey *)hotKey
{
    return ![SpectacleHotKeyManager.sharedManager isHotKeyRegistered:hotKey];
}

@end
