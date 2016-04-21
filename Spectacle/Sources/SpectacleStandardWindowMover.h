#import <Foundation/Foundation.h>

#import "SpectacleWindowMover.h"

@interface SpectacleStandardWindowMover : NSObject <SpectacleWindowMover>

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMover>)innerWindowMover NS_DESIGNATED_INITIALIZER;

@end
