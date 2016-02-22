#import <Foundation/Foundation.h>

@class JSContext;
@class JSValue;
@class SpectacleWindowPositionCalculationResult;

@interface SpectacleJavaScriptEnvironment : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithContextBuilder:(void(^)(JSContext *))contextBuilder NS_DESIGNATED_INITIALIZER;

- (JSValue *)valueWithRect:(CGRect)rect;

@end
