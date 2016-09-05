#import "SpectacleWindowPositionCalculationRegistry.h"

#import "SpectacleJavaScriptEnvironment.h"
#import "SpectacleWindowPositionCalculationResult.h"

@interface SpectacleWindowPositionCalculationRegistry ()

@property (nonatomic, readonly, strong) SpectacleJavaScriptEnvironment *javaScriptEnvironment;

@end

@implementation SpectacleWindowPositionCalculationRegistry
{
  NSMutableDictionary<SpectacleWindowAction *, JSValue *> *_windowPositionCalculations;
}

- (instancetype)init
{
  if (self = [super init]) {
    _windowPositionCalculations = [NSMutableDictionary new];
  }
  return self;
}

- (void)registerWindowPositionCalculation:(JSValue *)windowPositionCalculation withAction:(SpectacleWindowAction *)action
{
  _windowPositionCalculations[action] = windowPositionCalculation;
}

- (JSValue *)windowPositionCalculationWithAction:(SpectacleWindowAction *)action
{
  return _windowPositionCalculations[action];
}

@end
