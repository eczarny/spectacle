#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "SpectacleWindowAction.h"

@class SpectacleWindowPositionCalculationResult;

typedef CGRect *(^SpectacleWindowPositionCalculation)(CGRect windowRect,
                                                      CGRect visibleFrameOfSourceScreen,
                                                      CGRect visibleFrameOfDestinationScreen);

@protocol SpectacleWindowPositionCalculationRegistryExports <JSExport>

- (void)registerWindowPositionCalculation:(JSValue *)windowPositionCalculation withAction:(NSString *)action;

@end

@interface SpectacleWindowPositionCalculationRegistry : NSObject <SpectacleWindowPositionCalculationRegistryExports>

- (JSValue *)windowPositionCalculationWithAction:(SpectacleWindowAction *)action;

@end
