#import <Cocoa/Cocoa.h>
#import "ZKHotKeyRecorderDelegate.h"

@class ZKHotKey;

@interface ZKHotKeyRecorder : NSControl

- (NSString *)hotKeyName;

- (void)setHotKeyName: (NSString *)hotKeyName;

#pragma mark -

- (ZKHotKey *)hotKey;

- (void)setHotKey: (ZKHotKey *)hotKey;

#pragma mark -

- (id<ZKHotKeyRecorderDelegate>)delegate;

- (void)setDelegate: (id<ZKHotKeyRecorderDelegate>)delegate;

#pragma mark -

- (void)setAdditionalHotKeyValidators: (NSArray *)additionalHotKeyValidators;

@end
