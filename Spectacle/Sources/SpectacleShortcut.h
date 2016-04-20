#import <Carbon/Carbon.h>

#import "SpectacleWindowAction.h"

@class SpectacleShortcut;

typedef void(^SpectacleShortcutAction)(SpectacleShortcut *);

@interface SpectacleShortcut : NSObject<NSCoding>

@property (nonatomic, readwrite) EventHotKeyID shortcutID;
@property (nonatomic, readwrite) NSString *shortcutName;
@property (nonatomic, readwrite) SpectacleShortcutAction shortcutAction;
@property (nonatomic, readwrite) NSInteger shortcutCode;
@property (nonatomic, readwrite) NSUInteger shortcutModifiers;
@property (nonatomic, readwrite) EventHotKeyRef ref;

@property (nonatomic, readonly) SpectacleWindowAction *windowAction;

#pragma mark -

- (instancetype)init NS_UNAVAILABLE;

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
