#import "SpectacleWindowPositionCalculationResult.h"

@implementation SpectacleWindowPositionCalculationResult

@synthesize action = _action;
@synthesize windowRect = _windowRect;

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
  return [[SpectacleWindowPositionCalculationResult alloc] initWithAction:action windowRect:windowRect];
}

@end
