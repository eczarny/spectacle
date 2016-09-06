#import "SpectacleShortcutKeyBindings.h"

#import <Carbon/Carbon.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutTranslations.h"

static NSDictionary<NSNumber *, NSString *> *keyCodeToKeyCodeComponentConversionTable(void);
static NSDictionary<NSNumber *, NSString *> *keyCodeToNamedKeyCodeComponentConversionTable(void);
static NSDictionary<NSString *, NSNumber *> *namedKeyCodeComponentToKeyCodeConversionTable(void);
static NSDictionary<NSString *, NSNumber *> *modiferComponentToCarbonModifierConversionTable(void);
static NSDictionary<NSString *, NSNumber *> *keyCodeComponentToKeyCodeConversionTable(void);
static NSString *keyCodeComponentForKeyCode(NSInteger keyCode);
static NSArray<NSString *> *modifierComponentsForModifiers(NSUInteger modifiers);

NSNumber *SpectacleConvertShortcutKeyBindingToKeyCode(NSString *keyBinding)
{
  NSString *keyCodeComponent = [[keyBinding componentsSeparatedByString:@"+"] lastObject];
  NSString *sanitizedKeyCodeComponent = [keyCodeComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (sanitizedKeyCodeComponent.length == 0) {
    return nil;
  }
  NSString *normalizedKeyCodeComponent = [sanitizedKeyCodeComponent uppercaseString];
  NSNumber *namedBindingKeyCode = namedKeyCodeComponentToKeyCodeConversionTable()[normalizedKeyCodeComponent];
  if (namedBindingKeyCode) {
    return namedBindingKeyCode;
  }
  return keyCodeComponentToKeyCodeConversionTable()[normalizedKeyCodeComponent];
}

NSNumber *SpectacleConvertShortcutKeyBindingToModifiers(NSString *keyBinding)
{
  NSArray<NSString *> *keyBindingComponents = [keyBinding componentsSeparatedByString:@"+"];
  if (keyBindingComponents.count < 2) {
    return nil;
  }
  NSRange rangeOfModifierComponents = NSMakeRange(0, keyBindingComponents.count - 1);
  NSArray<NSString *> *modifierComponents = [keyBindingComponents subarrayWithRange:rangeOfModifierComponents];
  NSNumber *modifiers = @0;
  for (NSString *modifierComponent in modifierComponents) {
    NSString *sanitizedModifierComponent = [modifierComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *normalizedModifierComponent = [sanitizedModifierComponent uppercaseString];
    NSNumber *modifier = modiferComponentToCarbonModifierConversionTable()[normalizedModifierComponent];
    if (modifier) {
      modifiers = @([modifiers unsignedIntegerValue] | [modifier unsignedIntegerValue]);
    }
  }
  return modifiers;
}

NSString *SpectacleConvertShortcutToKeyBinding(SpectacleShortcut *shortcut)
{
  NSString *keyCodeComponent = [keyCodeComponentForKeyCode(shortcut.shortcutKeyCode) lowercaseString];
  NSArray<NSString *> *modifierComponents = modifierComponentsForModifiers(shortcut.shortcutModifiers);
  if ([shortcut isClearedShortcut] || !keyCodeComponent) {
    return nil;
  }
  return [[modifierComponents arrayByAddingObject:keyCodeComponent] componentsJoinedByString:@"+"];
}

static NSDictionary<NSNumber *, NSString *> *keyCodeToKeyCodeComponentConversionTable(void)
{
  static dispatch_once_t onceToken;
  static NSDictionary<NSNumber *, NSString *> *conversionTable;
  dispatch_once(&onceToken, ^{
    conversionTable = @{
                        @(kVK_ANSI_0):            @"0",
                        @(kVK_ANSI_1):            @"1",
                        @(kVK_ANSI_2):            @"2",
                        @(kVK_ANSI_3):            @"3",
                        @(kVK_ANSI_4):            @"4",
                        @(kVK_ANSI_5):            @"5",
                        @(kVK_ANSI_6):            @"6",
                        @(kVK_ANSI_7):            @"7",
                        @(kVK_ANSI_8):            @"8",
                        @(kVK_ANSI_9):            @"9",
                        @(kVK_ANSI_A):            @"A",
                        @(kVK_ANSI_B):            @"B",
                        @(kVK_ANSI_C):            @"C",
                        @(kVK_ANSI_D):            @"D",
                        @(kVK_ANSI_E):            @"E",
                        @(kVK_ANSI_F):            @"F",
                        @(kVK_ANSI_G):            @"G",
                        @(kVK_ANSI_H):            @"H",
                        @(kVK_ANSI_I):            @"I",
                        @(kVK_ANSI_J):            @"J",
                        @(kVK_ANSI_K):            @"K",
                        @(kVK_ANSI_L):            @"L",
                        @(kVK_ANSI_M):            @"M",
                        @(kVK_ANSI_N):            @"N",
                        @(kVK_ANSI_O):            @"O",
                        @(kVK_ANSI_P):            @"P",
                        @(kVK_ANSI_Q):            @"Q",
                        @(kVK_ANSI_R):            @"R",
                        @(kVK_ANSI_S):            @"S",
                        @(kVK_ANSI_T):            @"T",
                        @(kVK_ANSI_U):            @"U",
                        @(kVK_ANSI_V):            @"V",
                        @(kVK_ANSI_W):            @"W",
                        @(kVK_ANSI_X):            @"X",
                        @(kVK_ANSI_Y):            @"Y",
                        @(kVK_ANSI_Z):            @"Z",

                        @(kVK_ANSI_Equal):        @"=",
                        @(kVK_ANSI_Minus):        @"-",
                        @(kVK_ANSI_RightBracket): @"]",
                        @(kVK_ANSI_LeftBracket):  @"[",
                        @(kVK_ANSI_Quote):        @"'",
                        @(kVK_ANSI_Semicolon):    @";",
                        @(kVK_ANSI_Backslash):    @"\\",
                        @(kVK_ANSI_Comma):        @",",
                        @(kVK_ANSI_Slash):        @"/",
                        @(kVK_ANSI_Period):       @".",
                        @(kVK_ANSI_Grave):        @"`",
                        };
  });
  return conversionTable;
}

static NSDictionary<NSNumber *, NSString *> *keyCodeToNamedKeyCodeComponentConversionTable(void)
{
  static dispatch_once_t onceToken;
  static NSDictionary<NSNumber *, NSString *> *conversionTable;
  dispatch_once(&onceToken, ^{
    NSMutableDictionary<NSNumber *, NSString *> *generatedConversionTable = [NSMutableDictionary new];
    for (NSString *namedKeyCodeComponent in [namedKeyCodeComponentToKeyCodeConversionTable() allKeys]) {
      generatedConversionTable[namedKeyCodeComponentToKeyCodeConversionTable()[namedKeyCodeComponent]] = namedKeyCodeComponent;
    }
    conversionTable = generatedConversionTable;
  });
  return conversionTable;
}

static NSDictionary<NSString *, NSNumber *> *namedKeyCodeComponentToKeyCodeConversionTable(void)
{
  static dispatch_once_t onceToken;
  static NSDictionary<NSString *, NSNumber *> *conversionTable;
  dispatch_once(&onceToken, ^{
    conversionTable = @{
                        @"F1":             @(kVK_F1),
                        @"F2":             @(kVK_F2),
                        @"F3":             @(kVK_F3),
                        @"F4":             @(kVK_F4),
                        @"F5":             @(kVK_F5),
                        @"F6":             @(kVK_F6),
                        @"F7":             @(kVK_F7),
                        @"F8":             @(kVK_F8),
                        @"F9":             @(kVK_F9),
                        @"F10":            @(kVK_F10),
                        @"F11":            @(kVK_F11),
                        @"F12":            @(kVK_F12),
                        @"F13":            @(kVK_F13),
                        @"F14":            @(kVK_F14),
                        @"F15":            @(kVK_F15),
                        @"F16":            @(kVK_F16),
                        @"F17":            @(kVK_F17),
                        @"F18":            @(kVK_F18),
                        @"F19":            @(kVK_F19),
                        @"F20":            @(kVK_F20),

                        @"KEYPADDECIMAL":  @(kVK_ANSI_KeypadDecimal),
                        @"KEYPADMULTIPLY": @(kVK_ANSI_KeypadMultiply),
                        @"KEYPADPLUS":     @(kVK_ANSI_KeypadPlus),
                        @"KEYPADCLEAR":    @(kVK_ANSI_KeypadClear),
                        @"KEYPADDIVIDE":   @(kVK_ANSI_KeypadDivide),
                        @"KEYPADENTER":    @(kVK_ANSI_KeypadEnter),
                        @"KEYPADMINUS":    @(kVK_ANSI_KeypadMinus),
                        @"KEYPADEQUALS":   @(kVK_ANSI_KeypadEquals),
                        @"KEYPAD0":        @(kVK_ANSI_Keypad0),
                        @"KEYPAD1":        @(kVK_ANSI_Keypad1),
                        @"KEYPAD2":        @(kVK_ANSI_Keypad2),
                        @"KEYPAD3":        @(kVK_ANSI_Keypad3),
                        @"KEYPAD4":        @(kVK_ANSI_Keypad4),
                        @"KEYPAD5":        @(kVK_ANSI_Keypad5),
                        @"KEYPAD6":        @(kVK_ANSI_Keypad6),
                        @"KEYPAD7":        @(kVK_ANSI_Keypad7),
                        @"KEYPAD8":        @(kVK_ANSI_Keypad8),
                        @"KEYPAD9":        @(kVK_ANSI_Keypad9),

                        @"RETURN":         @(kVK_Return),
                        @"TAB":            @(kVK_Tab),
                        @"SPACE":          @(kVK_Space),
                        @"DELETE":         @(kVK_Delete),
                        @"ESCAPE":         @(kVK_Escape),
                        @"COMMAND":        @(kVK_Command),
                        @"SHIFT":          @(kVK_Shift),
                        @"CAPSLOCK":       @(kVK_CapsLock),
                        @"OPTION":         @(kVK_Option),
                        @"CONTROL":        @(kVK_Control),
                        @"RIGHTSHIFT":     @(kVK_RightShift),
                        @"RIGHTOPTION":    @(kVK_RightOption),
                        @"RIGHTCONTROL":   @(kVK_RightControl),
                        @"FUNCTION":       @(kVK_Function),
                        @"VOLUMEUP":       @(kVK_VolumeUp),
                        @"VOLUMEDOWN":     @(kVK_VolumeDown),
                        @"MUTE":           @(kVK_Mute),
                        @"HELP":           @(kVK_Help),
                        @"HOME":           @(kVK_Home),
                        @"PAGEUP":         @(kVK_PageUp),
                        @"FORWARDDELETE":  @(kVK_ForwardDelete),
                        @"END":            @(kVK_End),
                        @"PAGEDOWN":       @(kVK_PageDown),
                        @"LEFT":           @(kVK_LeftArrow),
                        @"RIGHT":          @(kVK_RightArrow),
                        @"DOWN":           @(kVK_DownArrow),
                        @"UP":             @(kVK_UpArrow),
                        };
  });
  return conversionTable;
}

static NSDictionary<NSString *, NSNumber *> *modiferComponentToCarbonModifierConversionTable(void)
{
  static dispatch_once_t onceToken;
  static NSDictionary<NSString *, NSNumber *> *conversionTable;
  dispatch_once(&onceToken, ^{
    conversionTable = @{
                        @"COMMAND": @(cmdKey),
                        @"CMD":     @(cmdKey),     // Alias for "COMMAND"

                        @"SHIFT":   @(shiftKey),

                        @"OPTION":  @(optionKey),
                        @"ALT":     @(optionKey),  // Alias for "OPTION"

                        @"CONTROL": @(controlKey),
                        @"CTRL":    @(controlKey), // Alias for "CONTROL"
                        };
  });
  return conversionTable;
}

static NSDictionary<NSString *, NSNumber *> *keyCodeComponentToKeyCodeConversionTable(void)
{
  static dispatch_once_t onceToken;
  static NSDictionary<NSString *, NSNumber *> *conversionTable;
  dispatch_once(&onceToken, ^{
    NSMutableDictionary<NSString *, NSNumber *> *generatedConversionTable = [NSMutableDictionary new];
    for (NSNumber *keyCode in [keyCodeToKeyCodeComponentConversionTable() allKeys]) {
      generatedConversionTable[keyCodeComponentForKeyCode([keyCode integerValue])] = keyCode;
    }
    conversionTable = generatedConversionTable;
  });
  return conversionTable;
}

static NSString *keyCodeComponentForKeyCode(NSInteger keyCode)
{
  NSString *namedKeyCodeComponent = keyCodeToNamedKeyCodeComponentConversionTable()[@(keyCode)];
  return (namedKeyCodeComponent.length > 0) ? namedKeyCodeComponent : keyCodeToKeyCodeComponentConversionTable()[@(keyCode)];
}

static NSArray<NSString *> *modifierComponentsForModifiers(NSUInteger modifiers)
{
  NSMutableArray<NSString *> *modifierComponents = [NSMutableArray new];
  if (modifiers & controlKey) {
    [modifierComponents addObject:@"ctrl"];
  }
  if (modifiers & optionKey) {
    [modifierComponents addObject:@"alt"];
  }
  if (modifiers & shiftKey) {
    [modifierComponents addObject:@"shift"];
  }
  if (modifiers & cmdKey) {
    [modifierComponents addObject:@"cmd"];
  }
  return modifierComponents;
}
