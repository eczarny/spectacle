#import <Foundation/Foundation.h>

#import "SpectacleWindowPositionManager.h"

@interface SpectacleCalculationResult : NSObject

@property (nonatomic) SpectacleWindowAction action;
@property (nonatomic) CGRect windowRect;

#pragma mark -

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAction:(SpectacleWindowAction)action windowRect:(CGRect)windowRect NS_DESIGNATED_INITIALIZER;

#pragma mark -

+ (instancetype)resultWithAction:(SpectacleWindowAction)action windowRect:(CGRect)windowRect;

@end
