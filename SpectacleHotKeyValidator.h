#import <Foundation/Foundation.h>

#import "ZKHotKeyValidatorProtocol.h"

@class ZKHotKey;

@interface SpectacleHotKeyValidator : NSObject<ZKHotKeyValidatorProtocol>

- (BOOL)isHotKeyValid: (ZKHotKey *)hotKey;

@end
