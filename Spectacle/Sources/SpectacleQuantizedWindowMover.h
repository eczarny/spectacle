#import <Foundation/Foundation.h>

#import "SpectacleWindowMover.h"

@interface SpectacleQuantizedWindowMover : NSObject <SpectacleWindowMover>

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMover>)innerWindowMover NS_DESIGNATED_INITIALIZER;

@end
