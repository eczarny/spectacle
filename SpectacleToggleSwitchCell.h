#import <Cocoa/Cocoa.h>
#import "SpectacleToggleSwitchDelegate.h"

@class SpectacleToggleSwitch;

@interface SpectacleToggleSwitchCell : NSCell {
    SpectacleToggleSwitch *myToggleSwitch;
    id<SpectacleToggleSwitchDelegate> myDelegate;
    NSImage *mySliderBackground;
    NSImage *mySliderMask;
    NSImage *myHandle;
    NSImage *myHandlePressed;
    NSPoint myHandlePosition;
    BOOL isMouseDown;
    BOOL isMouseDragging;
    BOOL isMouseAboveHandle;
}

- (void)setToggleSwitch: (SpectacleToggleSwitch *)toggleSwitch;

#pragma mark -

- (id<SpectacleToggleSwitchDelegate>)delegate;

- (void)setDelegate: (id<SpectacleToggleSwitchDelegate>)delegate;

@end
