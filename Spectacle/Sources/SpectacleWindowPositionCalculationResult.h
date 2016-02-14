#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "SpectacleWindowPositionManager.h"

@protocol SpectacleWindowPositionCalculationResultExports<JSExport>

@property (nonatomic, readonly) SpectacleWindowAction action;
@property (nonatomic, readonly) CGRect windowRect;

- (instancetype)initWithAction:(SpectacleWindowAction)action windowRect:(CGRect)windowRect;

@end

@interface SpectacleWindowPositionCalculationResult : NSObject<SpectacleWindowPositionCalculationResultExports>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAction:(SpectacleWindowAction)action windowRect:(CGRect)windowRect NS_DESIGNATED_INITIALIZER;

+ (instancetype)resultWithAction:(SpectacleWindowAction)action windowRect:(CGRect)windowRect;

@end
