#import <JavaScriptCore/JavaScriptCore.h>

#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleWindowPositionCalculationRegistry.h"
#import "SpectacleWindowPositionCalculationResult.h"

@implementation SpectacleWindowPositionCalculator
{
  JSContext *_context;
  SpectacleWindowPositionCalculationRegistry *_windowPositionCalculationRegistry;
}

- (instancetype)init
{
  if (self = [super init]) {
    _context = [JSContext new];
    _windowPositionCalculationRegistry = [[SpectacleWindowPositionCalculationRegistry alloc] initWithContext:_context];
    _context[@"SpectacleWindowPositionCalculationResult"] = [SpectacleWindowPositionCalculationResult class];
    _context[@"windowPositionCalculationRegistry"] = _windowPositionCalculationRegistry;
    [self evaluateBundledScripts];
  }
  return self;
}

- (SpectacleWindowPositionCalculationResult *)calculateWindowRect:(CGRect)windowRect
                                             visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
                                                           action:(SpectacleWindowAction)action
{
  SpectacleWindowPositionCalculation windowPositionCalculation = [_windowPositionCalculationRegistry windowPositionCalculationWithAction:action];
  if (!windowPositionCalculation) {
    return nil;
  }
  return windowPositionCalculation(windowRect, visibleFrameOfScreen);
}

- (void)evaluateBundledScripts
{
  NSArray<NSString *> *scriptPaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"js"
                                                                        inDirectory:@"Window Position Calculations"];
  [scriptPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull scriptPath, NSUInteger index, BOOL * _Nonnull stop) {
    NSString *script = loadScriptAtPath(scriptPath);
    if (script) {
      [_context evaluateScript:script];
    }
  }];
}

static NSString *loadScriptAtPath(NSString *scriptPath)
{
  NSError *error;
  NSString *script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
  if (!script) {
    NSLog(@"Unable to load script at path %@; reason %@", scriptPath, error.localizedDescription);
  }
  return script;
}

@end
