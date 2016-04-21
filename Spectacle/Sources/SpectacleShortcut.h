#import <Foundation/Foundation.h>

#import "SpectacleWindowAction.h"

@class SpectacleShortcut;

typedef void(^SpectacleShortcutAction)(SpectacleShortcut *);

@interface SpectacleShortcut : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *shortcutName;
@property (nonatomic, readonly) NSInteger shortcutCode;
@property (nonatomic, readonly) NSUInteger shortcutModifiers;
@property (nonatomic, readonly) SpectacleShortcutAction shortcutAction;
@property (nonatomic, readonly) SpectacleWindowAction *windowAction;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithShortcutName:(NSString *)shortcutName
                        shortcutCode:(NSInteger)shortcutCode
                   shortcutModifiers:(NSUInteger)shortcutModifiers;

- (instancetype)initWithShortcutName:(NSString *)shortcutName
                        shortcutCode:(NSInteger)shortcutCode
                   shortcutModifiers:(NSUInteger)shortcutModifiers
                      shortcutAction:(SpectacleShortcutAction)shortcutAction NS_DESIGNATED_INITIALIZER;

- (instancetype)copyWithShortcutAction:(SpectacleShortcutAction)shortcutAction;

- (void)triggerShortcutAction;

- (BOOL)isClearedShortcut;

- (NSString *)displayString;

+ (BOOL)validCocoaModifiers:(NSUInteger)modifiers;

- (BOOL)isEqual:(id)object;
- (BOOL)isEqualToShortcut:(SpectacleShortcut *)shortcut;

@end
