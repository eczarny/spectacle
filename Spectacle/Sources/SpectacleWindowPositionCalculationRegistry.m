#import "SpectacleJavaScriptEnvironment.h"
#import "SpectacleWindowPositionCalculationRegistry.h"
#import "SpectacleWindowPositionCalculationResult.h"

@interface SpectacleWindowPositionCalculationRegistry ()

@property (nonatomic, readonly) SpectacleJavaScriptEnvironment *javaScriptEnvironment;

@end

@implementation SpectacleWindowPositionCalculationRegistry
{
  NSMutableDictionary<NSNumber *, JSValue *> *_windowPositionCalculations;
}

- (instancetype)init
{
  if (self = [super init]) {
    _windowPositionCalculations = [NSMutableDictionary new];
  }
  return self;
}

- (void)registerWindowPositionCalculation:(JSValue *)windowPositionCalculation withAction:(SpectacleWindowAction)action
{
  _windowPositionCalculations[@(action)] = windowPositionCalculation;
}

- (JSValue *)windowPositionCalculationWithAction:(SpectacleWindowAction)action
{
  return _windowPositionCalculations[@(action)];
}

@end
