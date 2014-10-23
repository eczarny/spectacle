#import <Cocoa/Cocoa.h>
#import "ZKHotKeyRecorderDelegate.h"

@class ZKHotKeyRecorder, ZKHotKey;

@interface ZKHotKeyRecorderCell : NSCell

@property (nonatomic) ZKHotKeyRecorder *hotKeyRecorder;
@property (nonatomic) NSString *hotKeyName;
@property (nonatomic) ZKHotKey *hotKey;
@property (nonatomic, assign) id<ZKHotKeyRecorderDelegate> delegate;
@property (nonatomic) NSArray *additionalHotKeyValidators;

#pragma mark -

- (BOOL)resignFirstResponder;

#pragma mark -

- (BOOL)performKeyEquivalent: (NSEvent *)event;

- (void)flagsChanged: (NSEvent *)event;

@end
