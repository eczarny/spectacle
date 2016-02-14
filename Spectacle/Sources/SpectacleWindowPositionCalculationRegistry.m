#import "SpectacleWindowPositionCalculationRegistry.h"
#import "SpectacleWindowPositionCalculationResult.h"

@interface SpectacleWindowPositionCalculationRegistry ()

@property (nonatomic, readonly) JSContext *context;

@end

@implementation SpectacleWindowPositionCalculationRegistry
{
  NSMutableDictionary<NSNumber *, SpectacleWindowPositionCalculation> *_windowPositionCalculations;
}

- (instancetype)initWithContext:(JSContext *)context
{
  if (self = [super init]) {
    _context = context;
    _windowPositionCalculations = [NSMutableDictionary new];
  }
  return self;
}

- (instancetype)init
{
  return [self initWithContext:nil];
}

- (void)registerWindowPositionCalculation:(JSValue *)windowPositionCalculation withAction:(SpectacleWindowAction)action
{
  __weak __typeof__(self) weakSelf = self;
  _windowPositionCalculations[@(action)] = ^SpectacleWindowPositionCalculationResult *(CGRect windowRect, CGRect visibleFrameOfScreen) {
    NSArray<JSValue *> *arguments = @[[JSValue valueWithRect:windowRect inContext:weakSelf.context],
                                      [JSValue valueWithRect:visibleFrameOfScreen inContext:weakSelf.context],];
    JSValue *windowPositionCalculationResult = [windowPositionCalculation callWithArguments:arguments];
    return [windowPositionCalculationResult toObjectOfClass:[SpectacleWindowPositionCalculationResult class]];
  };
}

- (SpectacleWindowPositionCalculation)windowPositionCalculationWithAction:(SpectacleWindowAction)action
{
  return _windowPositionCalculations[@(action)];
}

@end
