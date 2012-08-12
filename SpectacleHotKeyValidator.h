#import <Foundation/Foundation.h>

@interface SpectacleHotKeyValidator : NSObject<ZeroKitHotKeyValidatorProtocol>

- (BOOL)isHotKeyValid: (ZeroKitHotKey *)hotKey;

@end
