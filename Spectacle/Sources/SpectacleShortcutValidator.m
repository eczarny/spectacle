#import "SpectacleShortcut.h"
#import "SpectacleShortcutTranslator.h"
#import "SpectacleShortcutValidator.h"
#import "SpectacleShortcutValidatorProtocol.h"

@implementation SpectacleShortcutValidator

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut error:(NSError **)error
{
  return [SpectacleShortcutValidator isShortcutValid:shortcut withValidators:@[] error:error];
}

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut withValidators:(NSArray *)validators error:(NSError **)error
{
  CFArrayRef shortcuts = NULL;
  
  if (CopySymbolicHotKeys(&shortcuts)) {
    return YES;
  }
  
  for (CFIndex i = 0; i < CFArrayGetCount(shortcuts); i++) {
    CFDictionaryRef shortcutDictionary = (CFDictionaryRef)CFArrayGetValueAtIndex(shortcuts, i);
    
    if (!shortcutDictionary || (CFGetTypeID(shortcutDictionary) != CFDictionaryGetTypeID())) {
      continue;
    }
    
    if (kCFBooleanTrue != (CFBooleanRef)CFDictionaryGetValue(shortcutDictionary, kHISymbolicHotKeyEnabled)) {
      continue;
    }
    
    NSInteger keyCode = [SpectacleShortcutValidator keyCodeFromDictionary:shortcutDictionary];
    NSUInteger modifiers = [SpectacleShortcutValidator modifiersFromDictionary:shortcutDictionary];
    
    if (([shortcut shortcutCode] == keyCode) && [SpectacleShortcutValidator shortcut:shortcut containsModifiers:modifiers]) {
      if (error) {
        *error = [SpectacleShortcutValidator errorWithShortcut:shortcut
                                                   description:@"Shortcut %@ already in use."
                                            recoverySuggestion:@"The shortcut \"%@\" is already used by a system-wide keyboard shortcut.\n\nTo use this shortcut change the existing shortcut in the Keyboard preference pane under System Preferences."];
      }
      
      return NO;
    }
  }
  
  for (id<SpectacleShortcutValidatorProtocol> validator in validators) {
    if ([validator conformsToProtocol:@protocol(SpectacleShortcutValidatorProtocol)] && ![validator isShortcutValid:shortcut]) {
      if (error) {
        *error = [SpectacleShortcutValidator errorWithShortcut:shortcut
                                                   description:@"Shortcut %@ already in use."
                                            recoverySuggestion:@"The shortcut \"%@\" is already in use. Please select a new shortcut."];
      }
      
      return NO;
    }
  }

  return [self isShortcut:shortcut availableInMenu:[[NSApplication sharedApplication] mainMenu] error:error];
}

#pragma mark -

+ (NSInteger)keyCodeFromDictionary:(CFDictionaryRef)dictionary
{
  CFNumberRef keyCodeFromDictionary = (CFNumberRef)CFDictionaryGetValue(dictionary, kHISymbolicHotKeyCode);
  NSInteger keyCode = 0;
  
  CFNumberGetValue(keyCodeFromDictionary, kCFNumberLongType, &keyCode);
  
  return keyCode;
}

+ (NSUInteger)modifiersFromDictionary:(CFDictionaryRef)dictionary
{
  CFNumberRef modifiersFromDictionary = (CFNumberRef)CFDictionaryGetValue(dictionary, kHISymbolicHotKeyModifiers);
  NSUInteger modifiers = 0;
  
  CFNumberGetValue(modifiersFromDictionary, kCFNumberLongType, &modifiers);
  
  return modifiers;
}

#pragma mark -

+ (BOOL)shortcut:(SpectacleShortcut *)shortcut containsModifiers:(NSUInteger)modifiers
{
  return shortcut.shortcutModifiers == [SpectacleShortcutTranslator convertModifiersToCarbonIfNecessary:modifiers];
}

#pragma mark -

+ (NSError *)errorWithShortcut:(SpectacleShortcut *)shortcut
                   description:(NSString *)description
            recoverySuggestion:(NSString *)recoverySuggestion
{
  NSString *shortcutString = [SpectacleShortcutTranslator.sharedTranslator translateShortcut:shortcut];
  NSMutableDictionary *userInfo = [NSMutableDictionary new];
  
  userInfo[NSLocalizedDescriptionKey] = [NSString stringWithFormat:NSLocalizedString(description, description), shortcutString];
  
  userInfo[NSLocalizedRecoverySuggestionErrorKey] = [NSString stringWithFormat:NSLocalizedString(recoverySuggestion, recoverySuggestion), shortcutString];
  
  userInfo[NSLocalizedRecoveryOptionsErrorKey] = @[NSLocalizedString(@"OK", @"OK")];
  
  return [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
}

#pragma mark -

+ (BOOL)isShortcut:(SpectacleShortcut *)shortcut availableInMenu:(NSMenu *)menu error:(NSError **)error
{
  for (NSMenuItem *menuItem in menu.itemArray) {
    if ([menuItem hasSubmenu] && ![self isShortcut:shortcut availableInMenu:menuItem.submenu error:error]) {
      return NO;
    }
    
    NSString *keyEquivalent = menuItem.keyEquivalent;
    
    if (!keyEquivalent || [keyEquivalent isEqualToString:@""]) {
      continue;
    }
    
    NSString *keyCode = [SpectacleShortcutTranslator.sharedTranslator translateKeyCode:shortcut.shortcutCode];
    
    if ([[keyEquivalent uppercaseString] isEqualToString:keyCode]
        && [SpectacleShortcutValidator shortcut:shortcut containsModifiers:menuItem.keyEquivalentModifierMask]) {
      if (error) {
        *error = [SpectacleShortcutValidator errorWithShortcut:shortcut
                                                   description:@"Shortcut %@ already in use."
                                            recoverySuggestion:@"The shortcut \"%@\" is already used in the menu."];
      }
      
      return NO;
    }
  }
  
  return YES;
}

@end
