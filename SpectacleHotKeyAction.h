#import <Cocoa/Cocoa.h>

@interface SpectacleHotKeyAction : NSObject {
    id myTarget;
    SEL mySelector;
}

- (id)initWithTarget: (id)target selector: (SEL)selector;

#pragma mark -

+ (SpectacleHotKeyAction *)hotKeyActionFromTarget: (id)target selector: (SEL)selector;

#pragma mark -

- (void)trigger;

@end
