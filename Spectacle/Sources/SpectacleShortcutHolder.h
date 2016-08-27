#import <Carbon/Carbon.h>

#import "SpectacleMacros.h"

@class SpectacleShortcut;

@interface SpectacleShortcutHolder : NSObject

@property (nonatomic, assign, readonly) EventHotKeyID shortcutID;
@property (nonatomic, strong, readonly) SpectacleShortcut *shortcut;
@property (nonatomic, assign, readonly) EventHotKeyRef shortcutRef;

- (instancetype)initWithShortcutID:(EventHotKeyID)shortcutID;

- (instancetype)initWithShortcutID:(EventHotKeyID)shortcutID
                          shortcut:(SpectacleShortcut *)shortcut;

- (instancetype)initWithShortcutID:(EventHotKeyID)shortcutID
                          shortcut:(SpectacleShortcut *)shortcut
                       shortcutRef:(EventHotKeyRef)shortcutRef NS_DESIGNATED_INITIALIZER;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

- (instancetype)copyWithShortcut:(SpectacleShortcut *)shortcut;
- (instancetype)copyWithShortcutRef:(EventHotKeyRef)shortcutRef;
- (instancetype)copyWithClearedShortcut;

@end
