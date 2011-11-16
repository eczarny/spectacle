#import <Cocoa/Cocoa.h>
#import "SpectacleHotKeyRecorderDelegate.h"

@class SpectacleHotKeyRecorder, SpectacleHotKey;

@interface SpectacleHotKeyRecorderCell : NSCell {
    SpectacleHotKeyRecorder *myHotKeyRecorder;
    NSString *myHotKeyName;
    SpectacleHotKey *myHotKey;
    id<SpectacleHotKeyRecorderDelegate> myDelegate;
    NSInteger myModifierFlags;
    BOOL isRecording;
    NSTrackingArea *myTrackingArea;
    BOOL isMouseAboveBadge;
    BOOL isMouseDown;
}

- (void)setHotKeyRecorder: (SpectacleHotKeyRecorder *)hotKeyRecorder;

#pragma mark -

- (NSString *)hotKeyName;

- (void)setHotKeyName: (NSString *)hotKeyName;

#pragma mark -

- (SpectacleHotKey *)hotKey;

- (void)setHotKey: (SpectacleHotKey *)hotKey;

#pragma mark -

- (id<SpectacleHotKeyRecorderDelegate>)delegate;

- (void)setDelegate: (id<SpectacleHotKeyRecorderDelegate>)delegate;

#pragma mark -

- (BOOL)resignFirstResponder;

#pragma mark -

- (BOOL)performKeyEquivalent: (NSEvent *)event;

- (void)flagsChanged: (NSEvent *)event;

@end
