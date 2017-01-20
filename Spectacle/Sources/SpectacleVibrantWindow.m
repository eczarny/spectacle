//
//  VibrantWindow.m
//  Spectacle
//
//  Created by Worriorbg on 1/19/2017.
//
//

#import "SpectacleVibrantWindow.h"
#import "SpectacleUtilities.h"

static const CGFloat kDefaultCornerRadius = 15.0f;

@interface SpectacleVibrantWindow ()
@property (nonatomic, strong, readonly) NSView *vibrantView;

@end

@implementation SpectacleVibrantWindow

@synthesize vibrantView = _vibrantView;

+ (CGFloat)titleBarHeightForFrame:(CGRect)frame
{
  NSRect contentRect = [NSWindow contentRectForFrameRect: frame
                                               styleMask: NSTitledWindowMask];
  
  return (frame.size.height - contentRect.size.height);
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
  // account for the title bar
  CGFloat titleBarHeight = [SpectacleVibrantWindow titleBarHeightForFrame:contentRect];
  contentRect.origin.y += titleBarHeight;
  
  if (self = [super initWithContentRect:contentRect
                              styleMask:NSBorderlessWindowMask
                                backing:NSBackingStoreBuffered defer:flag]) {
    [self setBackgroundColor:[NSColor clearColor]];
    [self setOpaque:NO];
    [self setExcludedFromWindowsMenu:YES];
    [self setIgnoresMouseEvents:YES];
    [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
  }
  
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self tryVibrantView];
  self.contentView.wantsLayer = YES;
}

- (void)tryVibrantView {
  Class vibrantClass=NSClassFromString(@"NSVisualEffectView");
  if (vibrantClass && [self.contentView isKindOfClass:vibrantClass])
  {
    NSVisualEffectView *vibrant= self.contentView;
    [vibrant setMaskImage:[SpectacleUtilities maskImageWithCornerRadius:kDefaultCornerRadius]];
    [vibrant setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
    [vibrant setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
    
    vibrant.material = NSVisualEffectMaterialDark;
    if (NSAppKitVersionNumber >= NSAppKitVersionNumber10_11) {
      vibrant.material = NSVisualEffectMaterialMenu;
    }
    vibrant.state = NSVisualEffectStateActive;
  } else {
    self.contentView.layer.cornerRadius = kDefaultCornerRadius;
    self.contentView.layer.backgroundColor = [NSColor colorWithWhite:0.2 alpha:.8f].CGColor;
    self.contentView.layer.masksToBounds = YES;
  }
}

- (BOOL)canBecomeKeyWindow {
  return NO;
}

- (BOOL)canBecomeMainWindow {
  return NO;
}

- (BOOL)canBeVisibleOnAllSpaces {
  return YES;
}

@end

