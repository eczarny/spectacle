#import <JavaScriptCore/JavaScriptCore.h>

#import "SpectacleJavaScriptEnvironment.h"
#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleWindowPositionCalculationRegistry.h"
#import "SpectacleWindowPositionCalculationResult.h"

@implementation SpectacleWindowPositionCalculator
{
  SpectacleWindowPositionCalculationRegistry *_windowPositionCalculationRegistry;
  SpectacleJavaScriptEnvironment *_javaScriptEnvironment;
}

- (instancetype)initWithErrorHandler:(void(^)(NSString *message))errorHandler
{
  if (self = [super init]) {
    _windowPositionCalculationRegistry = [SpectacleWindowPositionCalculationRegistry new];
    _javaScriptEnvironment = [[SpectacleJavaScriptEnvironment alloc] initWithContextBuilder:^(JSContext *context) {
      context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSString *errorName = [exception[@"name"] toString];
        NSString *errorMessage = [exception[@"message"] toString];
        errorHandler([NSString stringWithFormat:@"%@\n%@", errorName, errorMessage]);
      };
      context[@"windowPositionCalculationRegistry"] = _windowPositionCalculationRegistry;
    }];
  }
  return self;
}

- (SpectacleWindowPositionCalculationResult *)calculateWindowRect:(CGRect)windowRect
                                             visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
                                                           action:(SpectacleWindowAction *)action
{
  JSValue *windowPositionCalculation = [_windowPositionCalculationRegistry windowPositionCalculationWithAction:action];
  if (!windowPositionCalculation) {
    return nil;
  }
  JSValue *result = [windowPositionCalculation callWithArguments:@[[_javaScriptEnvironment valueWithRect:windowRect],
                                                                   [_javaScriptEnvironment valueWithRect:visibleFrameOfScreen],
                                                                   ]];
  return [SpectacleWindowPositionCalculationResult resultWithAction:action windowRect:[result toRect]];
}

@end
