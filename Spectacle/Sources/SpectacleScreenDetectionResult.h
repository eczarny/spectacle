#import <Foundation/Foundation.h>

@class NSScreen;

@interface SpectacleScreenDetectionResult : NSObject

@property (nonatomic, readonly) NSScreen *sourceScreen;
@property (nonatomic, readonly) NSScreen *destinationScreen;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSourceScreen:(NSScreen *)sourceScreen
                   destinationScreen:(NSScreen *)destinationScreen NS_DESIGNATED_INITIALIZER;

+ (instancetype)resultWithSourceScreen:(NSScreen *)sourceScreen
                     destinationScreen:(NSScreen *)destinationScreen;

@end
