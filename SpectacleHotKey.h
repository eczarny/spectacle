#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@class SpectacleHotKeyAction;

@interface SpectacleHotKey : NSObject<NSCoding> {
    NSInteger myHandle;
    NSString *myHotKeyName;
    SpectacleHotKeyAction *myHotKeyAction;
    NSInteger myHotKeyCode;
    NSInteger myHotKeyModifiers;
    EventHotKeyRef myHotKeyRef;
}

- (id)initWithHotKeyCode: (NSInteger)hotKeyCode hotKeyModifiers: (NSInteger)hotKeyModifiers;

#pragma mark -

- (NSInteger)handle;

- (void)setHandle: (NSInteger)handle;

#pragma mark -

- (NSString *)hotKeyName;

- (void)setHotKeyName: (NSString *)hotKeyName;

#pragma mark -

- (SpectacleHotKeyAction *)hotKeyAction;

- (void)setHotKeyAction: (SpectacleHotKeyAction *)hotKeyAction;

#pragma mark -

- (NSInteger)hotKeyCode;

- (void)setHotKeyCode: (NSInteger)hotKeyCode;

#pragma mark -

- (NSInteger)hotKeyModifiers;

- (void)setHotKeyModifiers: (NSInteger)hotKeyModifiers;

#pragma mark -

- (EventHotKeyRef)hotKeyRef;

- (void)setHotKeyRef: (EventHotKeyRef)hotKeyRef;

#pragma mark -

- (NSString *)displayString;

#pragma mark -

+ (BOOL)validCocoaModifiers: (NSInteger)modifiers;

@end
