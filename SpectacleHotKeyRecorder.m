#import "SpectacleHotKeyRecorder.h"
#import "SpectacleHotKeyRecorderCell.h"

#define MyCell (SpectacleHotKeyRecorderCell *)[self cell]

#pragma mark -

@implementation SpectacleHotKeyRecorder

- (id)initWithFrame: (NSRect)frame {
    if (self = [super initWithFrame: frame]) {
        [MyCell setHotKeyRecorder: self];
    }
    
    return self;
}

#pragma mark -

+ (Class)cellClass {
    return [SpectacleHotKeyRecorderCell class];
}

#pragma mark -

- (NSString *)hotKeyName {
    return [MyCell hotKeyName];
}

- (void)setHotKeyName: (NSString *)hotKeyName {
    [MyCell setHotKeyName: hotKeyName];
}

#pragma mark -

- (SpectacleHotKey *)hotKey {
    return [MyCell hotKey];
}

- (void)setHotKey: (SpectacleHotKey *)hotKey {
    [MyCell setHotKey: hotKey];
    
    [self updateCell: MyCell];
}

#pragma mark -

- (id<SpectacleHotKeyRecorderDelegate>)delegate {
    return [MyCell delegate];
}

- (void)setDelegate: (id<SpectacleHotKeyRecorderDelegate>)delegate {
    [MyCell setDelegate: delegate];
}

#pragma mark -

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)acceptsFirstMouse: (NSEvent *)event {
    return YES;
}

#pragma mark -

- (BOOL)performKeyEquivalent: (NSEvent *)event {
    if ([[[self window] firstResponder] isEqualTo: self]) {
        return [MyCell performKeyEquivalent: event];
    }
    
    return [super performKeyEquivalent: event];
}

- (void)keyDown: (NSEvent *)event {
    if ([self performKeyEquivalent: event]) {
        return;
    }
    
    [super keyDown: event];
}

- (void)flagsChanged: (NSEvent *)event {
    [MyCell flagsChanged: event];
}

#pragma mark -

- (BOOL)resignFirstResponder {
    return [MyCell resignFirstResponder];
}

@end
