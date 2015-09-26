#import <Foundation/Foundation.h>

#import "SpectacleWindowMoverProtocol.h"

@interface SpectacleBestEffortWindowMover : NSObject<SpectacleWindowMoverProtocol>

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover NS_DESIGNATED_INITIALIZER;

@end
