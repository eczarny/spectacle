#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"
#import "SpectacleWindowAction.h"

@class SpectacleShortcut;

typedef void(^SpectacleShortcutAction)(SpectacleShortcut *);

@interface SpectacleShortcut : NSObject <NSCoding>

@property (nonatomic, readonly, copy) NSString *shortcutName;
@property (nonatomic, readonly, assign) NSInteger shortcutKeyCode;
@property (nonatomic, readonly, assign) NSUInteger shortcutModifiers;
@property (nonatomic, readonly, strong) SpectacleShortcutAction shortcutAction;
@property (nonatomic, readonly, copy) NSString *shortcutKeyBinding;
@property (nonatomic, readonly, strong) SpectacleWindowAction *windowAction;

- (instancetype)initWithShortcutName:(NSString *)shortcutName shortcutKeyBinding:(NSString *)shortcutKeyBinding;

- (instancetype)initWithShortcutName:(NSString *)shortcutName
                  shortcutKeyBinding:(NSString *)shortcutKeyBinding
                      shortcutAction:(SpectacleShortcutAction)shortcutAction;

- (instancetype)initWithShortcutName:(NSString *)shortcutName
                     shortcutKeyCode:(NSInteger)shortcutKeyCode
                   shortcutModifiers:(NSUInteger)shortcutModifiers;

- (instancetype)initWithShortcutName:(NSString *)shortcutName
                     shortcutKeyCode:(NSInteger)shortcutKeyCode
                   shortcutModifiers:(NSUInteger)shortcutModifiers
                      shortcutAction:(SpectacleShortcutAction)shortcutAction NS_DESIGNATED_INITIALIZER;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

- (instancetype)copyWithShortcutAction:(SpectacleShortcutAction)shortcutAction;

- (void)triggerShortcutAction;

- (BOOL)isClearedShortcut;

- (NSString *)displayString;

- (BOOL)isEqual:(id)object;
- (BOOL)isEqualToShortcut:(SpectacleShortcut *)shortcut;

- (BOOL)containsModifiers:(NSUInteger)modifiers;

+ (BOOL)validCocoaModifiers:(NSUInteger)modifiers;

@end
