#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "SpectacleWindowAction.h"

@class SpectacleWindowPositionCalculationResult;

typedef SpectacleWindowPositionCalculationResult *(^SpectacleWindowPositionCalculation)(CGRect windowRect, CGRect visibleFrameOfScreen);

@protocol SpectacleWindowPositionCalculationRegistryExports<JSExport>

- (void)registerWindowPositionCalculation:(JSValue *)windowPositionCalculation withAction:(SpectacleWindowAction)action;

@end

@interface SpectacleWindowPositionCalculationRegistry : NSObject<SpectacleWindowPositionCalculationRegistryExports>

- (instancetype)initWithContext:(JSContext *)context NS_DESIGNATED_INITIALIZER;

- (SpectacleWindowPositionCalculation)windowPositionCalculationWithAction:(SpectacleWindowAction)action;

@end
