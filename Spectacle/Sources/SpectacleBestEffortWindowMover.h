#import <Foundation/Foundation.h>

#import "SpectacleWindowMover.h"

@interface SpectacleBestEffortWindowMover : NSObject <SpectacleWindowMover>

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMover>)innerWindowMover NS_DESIGNATED_INITIALIZER;

@end
