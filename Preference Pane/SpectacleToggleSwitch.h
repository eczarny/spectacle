#import <Cocoa/Cocoa.h>
#import "SpectacleToggleSwitchDelegate.h"

@interface SpectacleToggleSwitch : NSControl {
    
}

- (NSInteger)state;

- (void)setState: (NSInteger)state;

#pragma mark -

- (id<SpectacleToggleSwitchDelegate>)delegate;

- (void)setDelegate: (id<SpectacleToggleSwitchDelegate>)delegate;

@end
