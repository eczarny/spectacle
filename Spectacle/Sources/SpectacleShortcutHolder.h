#import <Carbon/Carbon.h>

@class SpectacleShortcut;

@interface SpectacleShortcutHolder : NSObject

@property (nonatomic, readonly) EventHotKeyID shortcutID;
@property (nonatomic, readonly) SpectacleShortcut *shortcut;
@property (nonatomic, readonly) EventHotKeyRef shortcutRef;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithShortcutID:(EventHotKeyID)shortcutID;

- (instancetype)initWithShortcutID:(EventHotKeyID)shortcutID
                          shortcut:(SpectacleShortcut *)shortcut;

- (instancetype)initWithShortcutID:(EventHotKeyID)shortcutID
                          shortcut:(SpectacleShortcut *)shortcut
                       shortcutRef:(EventHotKeyRef)shortcutRef NS_DESIGNATED_INITIALIZER;

- (instancetype)copyWithShortcut:(SpectacleShortcut *)shortcut;
- (instancetype)copyWithShortcutRef:(EventHotKeyRef)shortcutRef;
- (instancetype)copyWithClearedShortcut;

@end
