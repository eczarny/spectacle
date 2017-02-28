//
//  NotificationWindow.h
//  Spectacle
//
//  Created by Worriorbg on 1/17/2017.
//
//

#import <Cocoa/Cocoa.h>
#import "SpectacleWindowAction.h"

@interface SpectacleNotificationController : NSWindowController

@property (nonatomic, assign) NSTimeInterval hideDelay;

- (instancetype)initWindow;
- (void)showWindowWithAction:(SpectacleWindowAction*)action;
- (void)setCaption:(NSString*)titleText;

@end
