#import <Cocoa/Cocoa.h>

@interface SpectacleSetDimensionsController : NSWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName dimensions:(CGRect)dimensions;
- (CGRect)dimensions;
- (Boolean)isSuccess;

@end
