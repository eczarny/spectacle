#import <Foundation/Foundation.h>

@class ZKHotKey;

@interface ZKHotKeyValidator : NSObject

+ (BOOL)isHotKeyValid: (ZKHotKey *)hotKey error: (NSError **)error;

+ (BOOL)isHotKeyValid: (ZKHotKey *)hotKey withValidators: (NSArray *)validators error: (NSError **)error;

@end
