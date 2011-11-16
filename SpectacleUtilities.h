#import <Cocoa/Cocoa.h>

@class SpectacleHotKeyAction;

@interface SpectacleUtilities : ZeroKitUtilities {
    
}

+ (NSBundle *)preferencePaneBundle;

+ (NSBundle *)helperApplicationBundle;

#pragma mark -

+ (NSString *)preferencePaneVersion;

+ (NSString *)helperApplicationVersion;

#pragma mark -

+ (void)startSpectacle;

+ (void)stopSpectacle;

#pragma mark -

+ (BOOL)isSpectacleRunning;

#pragma mark -

+ (NSArray *)hotKeyNames;

#pragma mark -

+ (NSArray *)hotKeysFromDictionary: (NSDictionary *)dictionary hotKeyTarget: (id)target;

#pragma mark -

+ (SpectacleHotKeyAction *)actionForHotKeyWithName: (NSString *)key target: (id)target;

#pragma mark -

+ (NSInteger)currentWorkspace;

#pragma mark -

+ (NSImage *)imageFromResource: (NSString *)resource;

#pragma mark -

+ (NSMutableDictionary *)createStringAttributesWithShadow;

@end
