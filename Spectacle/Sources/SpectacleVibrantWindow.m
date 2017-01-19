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
  contentRect.origin.y += [SpectacleVibrantWindow titleBarHeightForFrame:contentRect];
  
  if (self = [super initWithContentRect:contentRect
                              styleMask:NSBorderlessWindowMask
                                backing:NSBackingStoreBuffered defer:flag]) {
    self.backgroundColor = [NSColor clearColor];
    [self setOpaque:NO];
    [self setExcludedFromWindowsMenu:YES];
    [self setIgnoresMouseEvents:YES];
  }
  
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self tryVibrantView];
  self.contentView.wantsLayer = YES;
  self.contentView.layer.cornerRadius = kDefaultCornerRadius;
  self.contentView.layer.backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0.75f].CGColor;
  self.contentView.layer.masksToBounds = YES;
}

- (void)tryVibrantView {
  Class vibrantClass=NSClassFromString(@"NSVisualEffectView");
  if (vibrantClass && [self.contentView isKindOfClass:vibrantClass])
  {
    NSVisualEffectView *vibrant= self.contentView;
    [vibrant setMaskImage:[SpectacleUtilities maskImageWithCornerRadius:kDefaultCornerRadius]];
    [vibrant setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
    [vibrant setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
    vibrant.state = NSVisualEffectStateActive;
  }
}

- (BOOL)canBecomeKeyWindow {
  return NO;
}

- (BOOL)canBecomeMainWindow {
  return NO;
}

@end

