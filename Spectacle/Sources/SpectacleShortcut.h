#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"
#import "SpectacleWindowAction.h"

@class SpectacleShortcut;

typedef void(^SpectacleShortcutAction)(SpectacleShortcut *);

@interface SpectacleShortcut : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *shortcutName;
@property (nonatomic, assign, readonly) NSInteger shortcutCode;
@property (nonatomic, assign, readonly) NSUInteger shortcutModifiers;
@property (nonatomic, strong, readonly) SpectacleShortcutAction shortcutAction;
@property (nonatomic, strong, readonly) SpectacleWindowAction *windowAction;

- (instancetype)initWithShortcutName:(NSString *)shortcutName
                        shortcutCode:(NSInteger)shortcutCode
                   shortcutModifiers:(NSUInteger)shortcutModifiers;

- (instancetype)initWithShortcutName:(NSString *)shortcutName
                        shortcutCode:(NSInteger)shortcutCode
                   shortcutModifiers:(NSUInteger)shortcutModifiers
                      shortcutAction:(SpectacleShortcutAction)shortcutAction NS_DESIGNATED_INITIALIZER;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

- (instancetype)copyWithShortcutAction:(SpectacleShortcutAction)shortcutAction;

- (void)triggerShortcutAction;

- (BOOL)isClearedShortcut;

- (NSString *)displayString;

+ (BOOL)validCocoaModifiers:(NSUInteger)modifiers;

- (BOOL)isEqual:(id)object;
- (BOOL)isEqualToShortcut:(SpectacleShortcut *)shortcut;

@end
