#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@class SpectacleShortcut;

typedef void(^SpectacleShortcutAction)(SpectacleShortcut *);

@interface SpectacleShortcut : NSObject<NSCoding>

@property (nonatomic) NSInteger handle;
@property (nonatomic) NSString *shortcutName;
@property (nonatomic, copy) SpectacleShortcutAction shortcutAction;
@property (nonatomic) NSInteger shortcutCode;
@property (nonatomic) NSUInteger shortcutModifiers;
@property (nonatomic) EventHotKeyRef ref;

#pragma mark -

- (instancetype)initWithShortcutCode:(NSInteger)shortcutCode
                   shortcutModifiers:(NSUInteger)shortcutModifiers NS_DESIGNATED_INITIALIZER;

#pragma mark -

+ (SpectacleShortcut *)clearedShortcut;

+ (SpectacleShortcut *)clearedShortcutWithName:(NSString *)name;

#pragma mark -

- (void)triggerShortcutAction;

#pragma mark -

- (BOOL)isClearedShortcut;

#pragma mark -

- (NSString *)displayString;

#pragma mark -

+ (BOOL)validCocoaModifiers:(NSUInteger)modifiers;

#pragma mark -

- (BOOL)isEqual:(id)object;

- (BOOL)isEqualToShortcut:(SpectacleShortcut *)shortcut;

@end
