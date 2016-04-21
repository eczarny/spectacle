#import <Foundation/Foundation.h>

@interface SpectacleLoginItemHelper : NSObject

+ (BOOL)isLoginItemEnabledForBundle:(NSBundle *)bundle;

+ (void)enableLoginItemForBundle:(NSBundle *)bundle;
+ (void)disableLoginItemForBundle:(NSBundle *)bundle;

@end
