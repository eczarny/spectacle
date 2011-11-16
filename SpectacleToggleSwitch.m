#import "SpectacleToggleSwitch.h"
#import "SpectacleToggleSwitchCell.h"

#define MyCell (SpectacleToggleSwitchCell *)[self cell]

#pragma mark -

@implementation SpectacleToggleSwitch

- (id)initWithFrame: (NSRect)frame {
    if (self = [super initWithFrame: frame]) {
        [MyCell setToggleSwitch: self];
    }
    
    return self;
}

#pragma mark -

+ (Class)cellClass {
    return [SpectacleToggleSwitchCell class];
}

#pragma mark -

- (NSInteger)state {
    return [MyCell state];
}

- (void)setState: (NSInteger)state {
    [MyCell setState: state];
}

#pragma mark -

- (id<SpectacleToggleSwitchDelegate>)delegate {
    return [MyCell delegate];
}

- (void)setDelegate: (id<SpectacleToggleSwitchDelegate>)delegate {
    [MyCell setDelegate: delegate];
}

@end
