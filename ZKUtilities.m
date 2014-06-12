#import "SpectacleConstants.h"
#import "ZKUtilities.h"

@implementation ZKUtilities

+ (NSBundle *)applicationBundle {
    return NSBundle.mainBundle;
}

#pragma mark -

+ (NSString *)applicationVersion {
    return [ZKUtilities versionOfBundle: ZKUtilities.applicationBundle];
}

#pragma mark -

+ (NSString *)versionOfBundle: (NSBundle *)bundle {
    NSString *bundleVersion = [bundle objectForInfoDictionaryKey: ZKApplicationBundleShortVersionString];
    
    if (!bundleVersion) {
        bundleVersion = [bundle objectForInfoDictionaryKey: ZKApplicationBundleVersion];
    }
    
    return bundleVersion;
}

#pragma mark -

+ (void)registerDefaultsForBundle: (NSBundle *)bundle {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSString *path = [bundle pathForResource: SpectacleDefaultPreferencesPropertyListFile ofType: SpectaclePropertyListFileExtension];
    NSDictionary *applicationDefaults = [[NSDictionary alloc] initWithContentsOfFile: path];
    
    [defaults registerDefaults: applicationDefaults];
}

#pragma mark -

+ (NSString *)applicationSupportPathForBundle: (NSBundle *)bundle {
    NSString *applicationName = [bundle objectForInfoDictionaryKey: ZKApplicationBundleName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportPath = (paths.count > 0) ? paths[0] : NSTemporaryDirectory();
    NSFileManager *fileManager = NSFileManager.defaultManager;
    
    applicationSupportPath = [applicationSupportPath stringByAppendingPathComponent: applicationName];
    
    if (![fileManager fileExistsAtPath: applicationSupportPath isDirectory: nil]) {
        NSLog(@"The application support directory does not exist, it will be created.");
        
        if (![fileManager createDirectoryAtPath: applicationSupportPath withIntermediateDirectories: NO attributes: nil error: nil]) {
            NSLog(@"There was a problem creating the application support directory at path: %@", applicationSupportPath);
        }
    }
    
    return applicationSupportPath;
}

#pragma mark -

+ (NSString *)pathForPreferencePaneNamed: (NSString *)preferencePaneName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSAllDomainsMask, YES);
    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSString *preferencePanePath = nil;

    if (preferencePaneName) {
        preferencePaneName = [preferencePaneName stringByAppendingFormat: @".%@", SpectaclePreferencePaneExtension];

        for (__strong NSString *path in paths) {
            path = [path stringByAppendingPathComponent: preferencePaneName];

            if (path && [fileManager fileExistsAtPath: path isDirectory: nil]) {
                preferencePanePath = path;

                break;
            }
        }

        if (!preferencePanePath) {
            NSLog(@"There was a problem obtaining the path for the specified preference pane: %@", preferencePaneName);
        }
    }

    return preferencePanePath;
}

#pragma mark -

+ (BOOL)isLoginItemEnabledForBundle: (NSBundle *)bundle {
    LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *applicationPath = bundle.bundlePath;
    BOOL result = NO;
    
    if (sharedFileList) {
        NSArray *sharedFileListArray = nil;
        UInt32 seedValue;
        
        sharedFileListArray = CFBridgingRelease(LSSharedFileListCopySnapshot(sharedFileList, &seedValue));
        
        for (id sharedFile in sharedFileListArray) {
            LSSharedFileListItemRef sharedFileListItem = (__bridge LSSharedFileListItemRef)sharedFile;
            CFURLRef applicationPathURL = NULL;
            
            LSSharedFileListItemResolve(sharedFileListItem, 0, (CFURLRef *)&applicationPathURL, NULL);
            
            if (applicationPathURL != NULL) {
                NSString *resolvedApplicationPath = [(__bridge NSURL *)applicationPathURL path];
                
                CFRelease(applicationPathURL);
                
                if ([resolvedApplicationPath compare: applicationPath] == NSOrderedSame) {
                    result = YES;
                    
                    break;
                }
            }
        }
        
        CFRelease(sharedFileList);
    } else {
        NSLog(@"Unable to create the shared file list.");
    }
    
    return result;
}

#pragma mark -

+ (void)enableLoginItemForBundle: (NSBundle *)bundle {
    LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *applicationPath = bundle.bundlePath;
    CFURLRef applicationPathURL = CFBridgingRetain([NSURL fileURLWithPath: applicationPath]);
    
    if (sharedFileList) {
        LSSharedFileListItemRef sharedFileListItem = LSSharedFileListInsertItemURL(sharedFileList, kLSSharedFileListItemLast, NULL, NULL, applicationPathURL, NULL, NULL);
        
        if (sharedFileListItem) {
            CFRelease(sharedFileListItem);
        }
        
        CFRelease(sharedFileList);
    } else {
        NSLog(@"Unable to create the shared file list.");
    }
}

+ (void)disableLoginItemForBundle: (NSBundle *)bundle {
    LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *applicationPath = bundle.bundlePath;
    CFURLRef applicationPathURL = CFBridgingRetain([NSURL fileURLWithPath: applicationPath]);
    
    if (sharedFileList) {
        NSArray *sharedFileListArray = nil;
        UInt32 seedValue;
        
        sharedFileListArray = CFBridgingRelease(LSSharedFileListCopySnapshot(sharedFileList, &seedValue));
        
        for (id sharedFile in sharedFileListArray) {
            LSSharedFileListItemRef sharedFileListItem = (__bridge LSSharedFileListItemRef)sharedFile;
            
            LSSharedFileListItemResolve(sharedFileListItem, 0, (CFURLRef *)&applicationPathURL, NULL);
            
            if (applicationPathURL != NULL) {
                NSString *resolvedApplicationPath = [(__bridge NSURL *)applicationPathURL path];
                
                if ([resolvedApplicationPath compare: applicationPath] == NSOrderedSame) {
                    LSSharedFileListItemRemove(sharedFileList, sharedFileListItem);
                }
            }
        }
        
        CFRelease(sharedFileList);
    } else {
        NSLog(@"Unable to create the shared file list.");
    }
}

#pragma mark -

+ (NSImage *)imageFromResource: (NSString *)resource inBundle: (NSBundle *)bundle {
    return [[NSImage alloc] initWithContentsOfFile: [bundle pathForImageResource: resource]];
}

#pragma mark -

+ (BOOL)isStringEmpty: (NSString *)string {
    if (!string || [string isEqualToString: @""]) {
        return YES;
    }
    
    return NO;
}

#pragma mark -

+ (NSMutableDictionary *)stringAttributesWithShadow {
    NSMutableParagraphStyle *paragraphStyle = NSParagraphStyle.defaultParagraphStyle.mutableCopy;
    NSShadow *textShadow = [NSShadow new];
    NSMutableDictionary *stringAttributes = [NSMutableDictionary new];
    
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSCenterTextAlignment;
    
    textShadow.shadowColor = [NSColor whiteColor];
    textShadow.shadowOffset = NSMakeSize(0.0f, -1.0);
    textShadow.shadowBlurRadius = 0.0f;
    
    stringAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
    stringAttributes[NSShadowAttributeName] = textShadow;
    
    return stringAttributes;
}

@end
