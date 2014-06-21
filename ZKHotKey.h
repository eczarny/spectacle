#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@class ZKHotKey;

typedef void(^ZKHotKeyAction)(ZKHotKey *);

@interface ZKHotKey : NSObject<NSCoding>

@property (nonatomic) NSInteger handle;
@property (nonatomic) NSString *hotKeyName;
@property (nonatomic, copy) ZKHotKeyAction hotKeyAction;
@property (nonatomic) NSInteger hotKeyCode;
@property (nonatomic) NSUInteger hotKeyModifiers;
@property (nonatomic) EventHotKeyRef hotKeyRef;
@property (nonatomic) BOOL enabled;

#pragma mark -

- (id)initWithHotKeyCode: (NSInteger)hotKeyCode hotKeyModifiers: (NSUInteger)hotKeyModifiers;

#pragma mark -

- (OSStatus)updateEnabled: (BOOL)enabled;

#pragma mark -

+ (ZKHotKey *)clearedHotKey;

+ (ZKHotKey *)clearedHotKeyWithName: (NSString *)name;

#pragma mark -

- (void)triggerHotKeyAction;

#pragma mark -

- (BOOL)isClearedHotKey;

#pragma mark -

- (NSString *)displayString;

#pragma mark -

+ (BOOL)validCocoaModifiers: (NSUInteger)modifiers;

#pragma mark -

- (BOOL)isEqual: (id)object;

- (BOOL)isEqualToHotKey: (ZKHotKey *)hotKey;

@end
