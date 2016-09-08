#import "SpectacleShortcutValidation.h"

#import <Carbon/Carbon.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutTranslations.h"
#import "SpectacleShortcutValidator.h"

@implementation SpectacleShortcutValidation
{
  SpectacleShortcutManager *_shortcutManager;
  NSArray<id<SpectacleShortcutValidator>> *_validators;
}

- (instancetype)initWithShortcutManager:(SpectacleShortcutManager *)shortcutManager
                             validators:(NSArray<id<SpectacleShortcutValidator>> *)validators
{
  if (self = [super init]) {
    _shortcutManager = shortcutManager;
    _validators = validators;
  }
  return self;
}

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut error:(NSError **)error
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
    NSInteger keyCode = keyCodeFromDictionary(shortcutDictionary);
    NSUInteger modifiers = modifiersFromDictionary(shortcutDictionary);
    if (([shortcut shortcutKeyCode] == keyCode) && [shortcut containsModifiers:modifiers]) {
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
  for (id<SpectacleShortcutValidator> validator in _validators) {
    if ([validator conformsToProtocol:@protocol(SpectacleShortcutValidator)]
        && ![validator isShortcutValid:shortcut shortcutManager:_shortcutManager]) {
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

+ (NSError *)errorWithShortcut:(SpectacleShortcut *)shortcut
                   description:(NSString *)description
            recoverySuggestion:(NSString *)recoverySuggestion
{
  NSString *shortcutString = SpectacleTranslateShortcut(shortcut);
  return [NSError errorWithDomain:NSCocoaErrorDomain
                             code:0
                         userInfo:@{
                                    NSLocalizedDescriptionKey: [NSString stringWithFormat:description, shortcutString],
                                    NSLocalizedRecoverySuggestionErrorKey: [NSString stringWithFormat:recoverySuggestion, shortcutString],
                                    NSLocalizedRecoveryOptionsErrorKey: @[NSLocalizedString(@"ButtonLabelAffirmative", @"The button label used in the affirmative")]
                                    }];
}

static NSInteger keyCodeFromDictionary(CFDictionaryRef dictionary)
{
  CFNumberRef keyCodeFromDictionary = (CFNumberRef)CFDictionaryGetValue(dictionary, kHISymbolicHotKeyCode);
  NSInteger keyCode = 0;
  CFNumberGetValue(keyCodeFromDictionary, kCFNumberLongType, &keyCode);
  return keyCode;
}

static NSUInteger modifiersFromDictionary(CFDictionaryRef dictionary)
{
  CFNumberRef modifiersFromDictionary = (CFNumberRef)CFDictionaryGetValue(dictionary, kHISymbolicHotKeyModifiers);
  NSUInteger modifiers = 0;
  CFNumberGetValue(modifiersFromDictionary, kCFNumberLongType, &modifiers);
  return modifiers;
}

@end
