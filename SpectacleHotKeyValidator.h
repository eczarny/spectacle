#import <Foundation/Foundation.h>
#import <ZeroKit/ZeroKit.h>

@interface SpectacleHotKeyValidator : NSObject<ZKHotKeyValidatorProtocol>

- (BOOL)isHotKeyValid: (ZKHotKey *)hotKey;

@end
