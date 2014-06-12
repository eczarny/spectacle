#import <Foundation/Foundation.h>

#define ZKApplicationBundleName               @"CFBundleName"
#define ZKApplicationBundleVersion            @"CFBundleVersion"
#define ZKApplicationBundleShortVersionString @"CFBundleShortVersionString"

#pragma mark -

#define ZKLocalizedString(string) NSLocalizedString(string, string)
#define ZKLocalizedStringFromCurrentBundle(string) NSLocalizedStringFromTableInBundle(string, nil, [NSBundle bundleForClass: [self class]], string)

#pragma mark -

@interface ZKUtilities : NSObject

+ (NSBundle *)applicationBundle;

#pragma mark -

+ (NSString *)applicationVersion;

#pragma mark -

+ (NSString *)versionOfBundle: (NSBundle *)bundle;

#pragma mark -

+ (void)registerDefaultsForBundle: (NSBundle *)bundle;

#pragma mark -

+ (NSString *)applicationSupportPathForBundle: (NSBundle *)bundle;

#pragma mark -

+ (NSString *)pathForPreferencePaneNamed: (NSString *)preferencePaneName;

#pragma mark -

+ (BOOL)isLoginItemEnabledForBundle: (NSBundle *)bundle;

#pragma mark -

+ (void)enableLoginItemForBundle: (NSBundle *)bundle;

+ (void)disableLoginItemForBundle: (NSBundle *)bundle;

#pragma mark -

+ (NSImage *)imageFromResource: (NSString *)resource inBundle: (NSBundle *)bundle;

#pragma mark -

+ (BOOL)isStringEmpty: (NSString *)string;

#pragma mark -

+ (NSMutableDictionary *)stringAttributesWithShadow;

@end
