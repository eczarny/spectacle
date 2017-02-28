//
//  NotificationWindow.m
//  Spectacle
//
//  Created by Worriorbg on 1/17/2017.
//
//

#import "SpectacleNotificationController.h"
#import "SpectacleMacros.h"

static const NSTimeInterval kDefaultHideDelay = 0.25f;
static const NSTimeInterval kDefaultHideDuration = 0.25f;

@interface SpectacleNotificationController ()
@property (weak) IBOutlet NSTextField *titleField;
@property (nonatomic, retain) NSImage* maskImage;
@property (weak) IBOutlet NSImageView *imageView;

@property (nonatomic, readonly) NSDictionary<SpectacleWindowAction*, NSString*>* titlesDictionary;
@property (nonatomic, readonly) NSDictionary* imageNamesDictionary;
@end

@implementation SpectacleNotificationController

@synthesize titlesDictionary = _titlesDictionary;
@synthesize imageNamesDictionary = _imageNamesDictionary;

- (instancetype)initWindow {
  if (self = [super initWithWindowNibName:@"SpectacleNotificationWindow"]) {
    // force window loading from nib
    [self window];
  }
  return self;
}

- (NSDictionary *)titlesDictionary {
  if (!_titlesDictionary) {
    _titlesDictionary = @{
      kSpectacleWindowActionCenter : LOCALIZE_TEXT(@"NotificationTextCenter"),
      kSpectacleWindowActionFullscreen : LOCALIZE_TEXT(@"NotificationTextFullScreen"),
      kSpectacleWindowActionLeftHalf : LOCALIZE_TEXT(@"NotificationTextLeftHalf"),
      kSpectacleWindowActionRightHalf : LOCALIZE_TEXT(@"NotificationTextRightHalf"),
      kSpectacleWindowActionTopHalf : LOCALIZE_TEXT(@"NotificationTextTopHalf"),
      kSpectacleWindowActionBottomHalf : LOCALIZE_TEXT(@"NotificationTextBottomHalf"),
      kSpectacleWindowActionUpperLeft : LOCALIZE_TEXT(@"NotificationTextUpperLeft"),
      kSpectacleWindowActionLowerLeft : LOCALIZE_TEXT(@"NotificationTextLowerLeft"),
      kSpectacleWindowActionUpperRight : LOCALIZE_TEXT(@"NotificationTextUpperRight"),
      kSpectacleWindowActionLowerRight : LOCALIZE_TEXT(@"NotificationTextLowerRight"),
      kSpectacleWindowActionNextDisplay : LOCALIZE_TEXT(@"NotificationTextNextDisplay"),
      kSpectacleWindowActionPreviousDisplay : LOCALIZE_TEXT(@"NotificationTextPreviousDisplay"),
      kSpectacleWindowActionNextThird : LOCALIZE_TEXT(@"NotificationTextNextThird"),
      kSpectacleWindowActionPreviousThird : LOCALIZE_TEXT(@"NotificationTextPreviousThird"),
      kSpectacleWindowActionLarger : LOCALIZE_TEXT(@"NotificationTextLarger"),
      kSpectacleWindowActionSmaller : LOCALIZE_TEXT(@"NotificationTextSmaller"),
      kSpectacleWindowActionUndo : LOCALIZE_TEXT(@"NotificationTextUndo"),
      kSpectacleWindowActionRedo : LOCALIZE_TEXT(@"NotificationTextRedo"),
    };
  }
  
  return _titlesDictionary;
}

- (NSString*)titleForAction:(SpectacleWindowAction*)action {
  NSString* title = @"";
  if ([[self.titlesDictionary allKeys] containsObject:action]) {
    title = [self.titlesDictionary objectForKey:action];
  }
  
  return title;
}

- (NSDictionary *)imageNamesDictionary {
  if (!_imageNamesDictionary) {
    _imageNamesDictionary = @{
      kSpectacleWindowActionCenter : @"notif_center",
      kSpectacleWindowActionFullscreen : @"notif_full_screen",
      kSpectacleWindowActionLeftHalf : @"notif_left",
      kSpectacleWindowActionRightHalf : @"notif_right",
      kSpectacleWindowActionTopHalf : @"notif_top",
      kSpectacleWindowActionBottomHalf : @"notif_bottom",
      kSpectacleWindowActionUpperLeft : @"notif_top_left",
      kSpectacleWindowActionLowerLeft : @"notif_bottom_left",
      kSpectacleWindowActionUpperRight : @"notif_top_right",
      kSpectacleWindowActionLowerRight : @"notif_bottom_right",
      kSpectacleWindowActionNextDisplay : @"notif_next_monitor",
      kSpectacleWindowActionPreviousDisplay : @"notif_prev_monitor",
      kSpectacleWindowActionNextThird : @"notif_next_third",
      kSpectacleWindowActionPreviousThird : @"notif_prev_third",
      kSpectacleWindowActionLarger : @"notif_bigger",
      kSpectacleWindowActionSmaller : @"notif_smaller",
      kSpectacleWindowActionUndo : @"notif_undo",
      kSpectacleWindowActionRedo : @"notif_redo",
    };
  }
  
  return _imageNamesDictionary;
}

- (NSString*)imageNameForAction:(SpectacleWindowAction*)action {
  NSString* imageName = @"notif_not_supported";
  if ([[self.imageNamesDictionary allKeys] containsObject:action]) {
    imageName = [self.imageNamesDictionary objectForKey:action];
  }
  
  return imageName;
}

- (void)showWindowWithAction:(SpectacleWindowAction*)action {
  [self.window setLevel:NSPopUpMenuWindowLevel];
  [self showWindow:nil];
  [self setCaption:[self titleForAction:action]];
  [self.imageView setImage:[NSImage imageNamed:[self imageNameForAction:action]]];
  [self.window invalidateShadow];
  
  [self.window.animator setAlphaValue:0.0f];
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutWindowWithCompletion:) object:nil];
  [self fadeInWindowWithCompletion:^{
    [self performSelector:@selector(fadeOutWindowWithCompletion:) withObject:nil afterDelay:kDefaultHideDelay + kDefaultHideDuration];
  }];
}

- (void)setCaption:(NSString *)titleText {
  self.titleField.stringValue = titleText;
}

- (void)fadeInWindowWithCompletion:(nullable void (^)(void))completionHandler {
  [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
    [context setDuration:kDefaultHideDuration];
    [self.window.animator setAlphaValue:1.0f];
  } completionHandler:completionHandler];
}

- (void)fadeOutWindowWithCompletion:(nullable void (^)(void))completionHandler {
  [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
    [context setDuration:kDefaultHideDuration];
    [self.window.animator setAlphaValue:0.0f];
  } completionHandler:completionHandler];
}

@end
