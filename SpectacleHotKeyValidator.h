#import <Foundation/Foundation.h>
#import <ZeroKit/ZeroKit.h>

@interface SpectacleHotKeyValidator : NSObject<ZeroKitHotKeyValidatorProtocol>

- (BOOL)isHotKeyValid: (ZeroKitHotKey *)hotKey;

@end
