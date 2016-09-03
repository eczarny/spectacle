#import "SpectacleShortcut.h"
#import "SpectacleShortcutTranslator.h"
#import "SpectacleShortcutValidator.h"
#import "SpectacleShortcutValidation.h"

@implementation SpectacleShortcutValidation

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut
        shortcutManager:(SpectacleShortcutManager *)shortcutManager
                  error:(NSError **)error
{
  return [SpectacleShortcutValidation isShortcutValid:shortcut
                                      shortcutManager:shortcutManager
                                       withValidators:@[]
                                                error:error];
}

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut
        shortcutManager:(SpectacleShortcutManager *)shortcutManager
         withValidators:(NSArray<id<SpectacleShortcutValidator>> *)validators
                  error:(NSError **)error
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
    NSInteger keyCode = [SpectacleShortcutValidation keyCodeFromDictionary:shortcutDictionary];
    NSUInteger modifiers = [SpectacleShortcutValidation modifiersFromDictionary:shortcutDictionary];
    if (([shortcut shortcutCode] == keyCode) && [SpectacleShortcutValidation shortcut:shortcut containsModifiers:modifiers]) {
      if (error) {
        NSString *description = NSLocalizedString(@"AlertMessageTextShortcutValidationError", @"The message text of the alert displayed when a shortcut is invalid");
        NSString *recoverySuggestion = NSLocalizedString(@"AlertInformativeTextSystemWideShortcutAlreadyUsed", @"The informative text of the alert displayed when a system-wide shortcut is already in use");
        *error = [SpectacleShortcutValidation errorWithShortcut:shortcut
                                                    description:description
                                             recoverySuggestion:recoverySuggestion];
      }
      return NO;
    }
  }
  for (id<SpectacleShortcutValidator> validator in validators) {
    if ([validator conformsToProtocol:@protocol(SpectacleShortcutValidator)]
        && ![validator isShortcutValid:shortcut shortcutManager:shortcutManager]) {
      if (error) {
        NSString *description = NSLocalizedString(@"AlertMessageTextShortcutValidationError", @"The message text of the alert displayed when a shortcut is invalid");
        NSString *recoverySuggestion = NSLocalizedString(@"AlertInformativeTextShortcutAlreadyInUse", @"The informative text of the alert displayed when a shortcut is already in use");
        *error = [SpectacleShortcutValidation errorWithShortcut:shortcut
                                                    description:description
                                             recoverySuggestion:recoverySuggestion];
      }
      return NO;
    }
  }
  return YES;
}

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

+ (BOOL)shortcut:(SpectacleShortcut *)shortcut containsModifiers:(NSUInteger)modifiers
{
  return shortcut.shortcutModifiers == [SpectacleShortcutTranslator convertModifiersToCarbonIfNecessary:modifiers];
}

+ (NSError *)errorWithShortcut:(SpectacleShortcut *)shortcut
                   description:(NSString *)description
            recoverySuggestion:(NSString *)recoverySuggestion
{
  NSString *shortcutString = [SpectacleShortcutTranslator translateShortcut:shortcut];
  return [NSError errorWithDomain:NSCocoaErrorDomain
                             code:0
                         userInfo:@{
                                    NSLocalizedDescriptionKey: [NSString stringWithFormat:description, shortcutString],
                                    NSLocalizedRecoverySuggestionErrorKey: [NSString stringWithFormat:recoverySuggestion, shortcutString],
                                    NSLocalizedRecoveryOptionsErrorKey: @[NSLocalizedString(@"ButtonLabelAffirmative", @"The button label used in the affirmative")]
                                    }];
}

@end
