#import <Foundation/Foundation.h>

@class ZKHotKey;

@protocol ZKHotKeyValidatorProtocol<NSObject>

- (BOOL)isHotKeyValid: (ZKHotKey *)hotKey;

@end
