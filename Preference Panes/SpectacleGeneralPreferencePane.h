#import <Foundation/Foundation.h>

@interface SpectacleGeneralPreferencePane : NSObject<ZeroKitPreferencePaneProtocol> {
    IBOutlet NSView *myView;
    IBOutlet NSTextField *mySpectacleVersionTextField;
    IBOutlet NSButton *myLoginItemEnabled;
    IBOutlet NSPopUpButton *myStatusItemEnabled;
}

- (NSString *)name;

#pragma mark -

- (NSImage *)icon;

#pragma mark -

- (NSString *)toolTip;

#pragma mark -

- (NSView *)view;

#pragma mark -

- (IBAction)toggleLoginItem: (id)sender;

- (IBAction)toggleStatusItem: (id)sender;

@end
