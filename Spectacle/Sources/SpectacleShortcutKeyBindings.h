#import <Foundation/Foundation.h>

@class SpectacleShortcut;

NSNumber *SpectacleConvertShortcutKeyBindingToKeyCode(NSString *keyBinding);
NSNumber *SpectacleConvertShortcutKeyBindingToModifiers(NSString *keyBinding);

NSString *SpectacleConvertShortcutToKeyBinding(SpectacleShortcut *shortcut);
