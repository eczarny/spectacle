//
//  DivideAlertController.m
//  Divide
//
//  Created by shseo on 2015. 6. 23..
//
//

#import "DivideAlertController.h"
#import "DivideWindowPositionManager.h"


@interface DivideAlertController ()

@property (nonatomic) IBOutlet NSView *currentView;
@property (nonatomic) IBOutlet NSImageView *icon;
@property (nonatomic) IBOutlet NSTextField *title;

@end


@implementation DivideAlertController

static NSString *StatusCenter = @"Center";
static NSString *StatusLeft = @"Left";
static NSString *StatusRight = @"Right";
static NSString *StatusTop = @"Top";
static NSString *StatusBottom = @"Bottom";
static NSString *StatusTopLeft = @"Top Left";
static NSString *StatusBottomLeft = @"Bottom Left";
static NSString *StatusTopRight = @"Top Right";
static NSString *StatusBottomRight = @"Bottom Right";


- (instancetype)init {
    self = [super initWithWindowNibName:@"DivideAlertWindow"];
    return self;
}


- (void)showWindow:(id)sender {
    [super showWindow:sender];
    
    NSImage *image = NULL;
    

    switch (_windowType) {
        case SpectacleWindowActionFullscreen:
            image = [NSImage imageNamed:@"window_full"];
            [_title setStringValue:StatusCenter];
            break;
            
        case SpectacleWindowActionLeftHalf:
            image = [NSImage imageNamed:@"window_left"];
            [_title setStringValue:StatusLeft];
            break;
            
        case SpectacleWindowActionRightHalf:
            image = [NSImage imageNamed:@"window_right"];
            [_title setStringValue:StatusRight];
            break;
            
        case SpectacleWindowActionTopHalf:
            image = [NSImage imageNamed:@"window_top"];
            [_title setStringValue:StatusTop];
            break;
            
        case SpectacleWindowActionBottomHalf:
            image = [NSImage imageNamed:@"window_bottom"];
            [_title setStringValue:StatusBottom];
            break;
            
        case SpectacleWindowActionUpperLeft:
            image = [NSImage imageNamed:@"window_top_left"];
            [_title setStringValue:StatusTopLeft];
            break;
            
        case SpectacleWindowActionLowerLeft:
            image = [NSImage imageNamed:@"window_bottom_left"];
            [_title setStringValue:StatusBottomLeft];
            break;
            
        case SpectacleWindowActionUpperRight:
            image = [NSImage imageNamed:@"window_top_right"];
            [_title setStringValue:StatusTopRight];
            break;
            
        case SpectacleWindowActionLowerRight:
            image = [NSImage imageNamed:@"window_bottom_right"];
            [_title setStringValue:StatusBottomRight];
            break;
            
        default:
            image = [NSImage imageNamed:@"blackList"];
            [_title setStringValue:@""];
            break;
    }
    
    if (image != NULL) {
        [_icon setImage:image];
    }
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window setStyleMask:NSBorderlessWindowMask];
    [self.window setOpaque:NO];
    [self.window setBackgroundColor:[NSColor clearColor]];
    
    
    NSColor *backgroundColor = [NSColor blackColor];
    backgroundColor = [backgroundColor colorWithAlphaComponent:0.5];
    
    
    _currentView.wantsLayer            = YES;
    _currentView.layer.frame           = _currentView.frame;
    _currentView.layer.cornerRadius    = 15.0;
    _currentView.layer.borderWidth     = 0.5;
    _currentView.layer.masksToBounds   = YES;
    _currentView.layer.borderColor     = [backgroundColor CGColor];
    _currentView.layer.backgroundColor = [backgroundColor CGColor];
}


@end
