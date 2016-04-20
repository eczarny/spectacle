#import <Foundation/Foundation.h>

#import "SpectacleWindowPositionManager.h"

@interface SpectacleWindowPositionCalculationResult : NSObject

@property (nonatomic, readonly) SpectacleWindowAction action;
@property (nonatomic, readonly) CGRect windowRect;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAction:(SpectacleWindowAction)action windowRect:(CGRect)windowRect NS_DESIGNATED_INITIALIZER;

+ (instancetype)resultWithAction:(SpectacleWindowAction)action windowRect:(CGRect)windowRect;

@end
