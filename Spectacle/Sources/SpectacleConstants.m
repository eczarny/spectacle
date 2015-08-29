#import "SpectacleConstants.h"

NSString *const kPreferencesWindowNibName = @"SpectaclePreferencesWindow";

#pragma mark -

NSString *const kCFBundleShortVersionString = @"CFBundleShortVersionString";
NSString *const kCFBundleVersion = @"CFBundleVersion";

#pragma mark -

NSString *const kStatusItemEnabledNotification = @"SpectacleStatusItemEnabledNotification";
NSString *const kStatusItemDisabledNotification = @"SpectacleStatusItemDisabledNotification";

NSString *const kShortcutChangedNotification = @"SpectacleShortcutChangedNotification";

NSString *const kRestoreDefaultShortcutsNotification = @"SpectacleRestoreDefaultShortcutsNotification";

#pragma mark -

const NSInteger kMenuItemActivateIgnoringOtherApps = -1;

#pragma mark -

NSString *const kPropertyListFileExtension = @"plist";

NSString *const kDefaultPreferencesPropertyListFile = @"Defaults";

#pragma mark -

NSString *const kWindowActionMoveToCenter = @"MoveToCenter";
NSString *const kWindowActionMoveToFullscreen = @"MoveToFullscreen";

NSString *const kWindowActionMoveToLeftHalf = @"MoveToLeftHalf";
NSString *const kWindowActionMoveToRightHalf = @"MoveToRightHalf";
NSString *const kWindowActionMoveToTopHalf = @"MoveToTopHalf";
NSString *const kWindowActionMoveToBottomHalf = @"MoveToBottomHalf";

NSString *const kWindowActionMoveToUpperLeft = @"MoveToUpperLeft";
NSString *const kWindowActionMoveToLowerLeft = @"MoveToLowerLeft";
NSString *const kWindowActionMoveToUpperRight = @"MoveToUpperRight";
NSString *const kWindowActionMoveToLowerRight = @"MoveToLowerRight";

NSString *const kWindowActionMoveToNextDisplay = @"MoveToNextDisplay";
NSString *const kWindowActionMoveToPreviousDisplay = @"MoveToPreviousDisplay";

NSString *const kWindowActionMoveToNextThird = @"MoveToNextThird";
NSString *const kWindowActionMoveToPreviousThird = @"MoveToPreviousThird";

NSString *const kWindowActionMakeLarger = @"MakeLarger";
NSString *const kWindowActionMakeSmaller = @"MakeSmaller";

NSString *const kWindowActionUndoLastMove = @"UndoLastMove";
NSString *const kWindowActionRedoLastMove = @"RedoLastMove";

#pragma mark -

const NSInteger kWindowActionHistorySize = 50;

#pragma mark -

const CGFloat kWindowSizeOffset = 30.0f;
const CGFloat kMaximumGapNeededToStickToEdge = 5.0f;
const CGFloat kMinimumWindowSizeRatio = 4.0f;

#pragma mark -

NSString *const kStatusItemIcon = @"Spectacle Status Item";

#pragma mark -

NSString *const kPreferencePaneExtension = @"prefPane";

NSString *const kAutomaticUpdateCheckEnabledPreference = @"AutomaticUpdateCheckEnabled";
NSString *const kBackgroundAlertSuppressedPreference = @"BackgroundAlertSuppressed";
NSString *const kBlacklistedApplicationsPreference = @"BlacklistedApplications";
NSString *const kDisabledApplicationsPreference = @"DisabledApplications";
NSString *const kStatusItemEnabledPreference = @"StatusItemEnabled";

#pragma mark -

NSString *const kSecurityPreferencePaneName = @"Security";

#pragma mark -

NSString *const kSecurityAndPrivacyPreferencesScriptName = @"Security & Privacy System Preferences";

NSString *const kAppleScriptFileExtension = @"scpt";

#pragma mark -

NSString *const kShortcutTranslationsPropertyListFile = @"ShortcutTranslations";

NSString *const kShortcutTranslationsKey = @"ShortcutTranslations";
NSString *const kShortcutGlyphTranslationsKey = @"ShortcutGlyphTranslations";

