#import <Foundation/Foundation.h>

#import "SpectacleWindowPositionManager.h"

@interface SpectacleCalculationResult : NSObject

@property (nonatomic) SpectacleWindowAction action;
@property (nonatomic) CGRect windowRect;

- (id)initWithAction: (SpectacleWindowAction)action windowRect: (CGRect)windowRect;

+ (instancetype)resultWithAction: (SpectacleWindowAction)action windowRect: (CGRect)windowRect;

@end
