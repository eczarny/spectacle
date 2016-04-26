#import <Foundation/Foundation.h>

#import "SpectacleWindowAction.h"

@class SpectacleWindowPositionCalculationResult;

@interface SpectacleWindowPositionCalculator : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithErrorHandler:(void(^)(NSString *message))errorHandler NS_DESIGNATED_INITIALIZER;

- (SpectacleWindowPositionCalculationResult *)calculateWindowRect:(CGRect)windowRect
                                  visibleFrameOfDestinationScreen:(CGRect)visibleFrameOfDestinationScreen
                                       visibleFrameOfSourceScreen:(CGRect)visibleFrameOfSourceScreen
                                                            action:(SpectacleWindowAction *)action;

@end
