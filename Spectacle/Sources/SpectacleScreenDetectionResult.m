#import "SpectacleScreenDetectionResult.h"

@implementation SpectacleScreenDetectionResult

@synthesize sourceScreen = _sourceScreen;
@synthesize destinationScreen = _destinationScreen;

- (instancetype)initWithSourceScreen:(NSScreen *)sourceScreen
                   destinationScreen:(NSScreen *)destinationScreen
{
  if (self = [super init]) {
    _sourceScreen = sourceScreen;
    _destinationScreen = destinationScreen;
  }
  return self;
}

+ (instancetype)resultWithSourceScreen:(NSScreen *)sourceScreen
                     destinationScreen:(NSScreen *)destinationScreen
{
  return [[SpectacleScreenDetectionResult alloc] initWithSourceScreen:sourceScreen destinationScreen:destinationScreen];
}

@end
