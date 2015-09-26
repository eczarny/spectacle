#import <Foundation/Foundation.h>

#import "SpectacleWindowMoverProtocol.h"

@interface SpectacleStandardWindowMover : NSObject<SpectacleWindowMoverProtocol>

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover NS_DESIGNATED_INITIALIZER;

@end
