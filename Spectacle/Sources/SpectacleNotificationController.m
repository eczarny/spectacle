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
      kSpectacleWindowActionCenter : LOCALIZE_TEXT(@"Center"),
      kSpectacleWindowActionFullscreen : LOCALIZE_TEXT(@"Full Screen"),
      kSpectacleWindowActionLeftHalf : LOCALIZE_TEXT(@"Left Half"),
      kSpectacleWindowActionRightHalf : LOCALIZE_TEXT(@"Right Half"),
      kSpectacleWindowActionTopHalf : LOCALIZE_TEXT(@"Top Half"),
      kSpectacleWindowActionBottomHalf : LOCALIZE_TEXT(@"Bottom Half"),
      kSpectacleWindowActionUpperLeft : LOCALIZE_TEXT(@"Upper Left"),
      kSpectacleWindowActionLowerLeft : LOCALIZE_TEXT(@"Lower Left"),
      kSpectacleWindowActionUpperRight : LOCALIZE_TEXT(@"Upper Right"),
      kSpectacleWindowActionLowerRight : LOCALIZE_TEXT(@"Lower Right"),
      kSpectacleWindowActionNextDisplay : LOCALIZE_TEXT(@"Next Display"),
      kSpectacleWindowActionPreviousDisplay : LOCALIZE_TEXT(@"Prevous Display"),
      kSpectacleWindowActionNextThird : LOCALIZE_TEXT(@"Next Third"),
      kSpectacleWindowActionPreviousThird : LOCALIZE_TEXT(@"Prevous Third"),
      kSpectacleWindowActionLarger : LOCALIZE_TEXT(@"Larger"),
      kSpectacleWindowActionSmaller : LOCALIZE_TEXT(@"Smaller"),
      kSpectacleWindowActionUndo : LOCALIZE_TEXT(@"Undo"),
      kSpectacleWindowActionRedo : LOCALIZE_TEXT(@"Redo"),
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
