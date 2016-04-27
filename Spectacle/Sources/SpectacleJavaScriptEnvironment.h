#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"

@class JSContext;
@class JSValue;
@class SpectacleWindowPositionCalculationResult;

@interface SpectacleJavaScriptEnvironment : NSObject

- (instancetype)initWithContextBuilder:(void(^)(JSContext *))contextBuilder NS_DESIGNATED_INITIALIZER;

- (JSValue *)valueWithRect:(CGRect)rect;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

@end
