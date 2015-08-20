#import "SpectacleCalculationResult.h"

@implementation SpectacleCalculationResult

- (instancetype)initWithAction:(SpectacleWindowAction)action windowRect:(CGRect)windowRect
{
  if (self = [super init]) {
    _action = action;
    _windowRect = windowRect;
  }

  return self;
}

+ (instancetype)resultWithAction:(SpectacleWindowAction)action windowRect:(CGRect)windowRect
{
  return [[SpectacleCalculationResult alloc] initWithAction:action windowRect:windowRect];
}

@end
