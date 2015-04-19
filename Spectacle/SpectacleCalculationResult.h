#import <Foundation/Foundation.h>

#import "SpectacleWindowPositionManager.h"

@interface SpectacleCalculationResult : NSObject

@property (nonatomic) SpectacleWindowAction action;
@property (nonatomic) CGRect windowRect;

- (instancetype)initWithAction: (SpectacleWindowAction)action windowRect: (CGRect)windowRect NS_DESIGNATED_INITIALIZER;

+ (instancetype)resultWithAction: (SpectacleWindowAction)action windowRect: (CGRect)windowRect;

@end
