#import <Cocoa/Cocoa.h>

@class SpectacleToggleSwitch;

@protocol SpectacleToggleSwitchDelegate

- (void)toggleSwitchDidChangeState: (SpectacleToggleSwitch *)toggleSwitch;

@end
