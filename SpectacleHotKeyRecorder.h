#import <Cocoa/Cocoa.h>
#import "SpectacleHotKeyRecorderDelegate.h"

@class SpectacleHotKey;

@interface SpectacleHotKeyRecorder : NSControl {
    
}

- (NSString *)hotKeyName;

- (void)setHotKeyName: (NSString *)hotKeyName;

#pragma mark -

- (SpectacleHotKey *)hotKey;

- (void)setHotKey: (SpectacleHotKey *)hotKey;

#pragma mark -

- (id<SpectacleHotKeyRecorderDelegate>)delegate;

- (void)setDelegate: (id<SpectacleHotKeyRecorderDelegate>)delegate;

@end
