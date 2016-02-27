#import "SpectacleSetDimensionsController.h"

@interface SpectacleSetDimensionsController ()

@end

@implementation SpectacleSetDimensionsController {
  NSInteger _dialogCode;
  __weak IBOutlet NSTextField *_xCoordinate;
  __weak IBOutlet NSTextField *_yCoordinate;
  __weak IBOutlet NSTextField *_width;
  __weak IBOutlet NSTextField *_height;
  CGRect _dimensions;
}

- (id)initWithWindowNibName:(NSString *)windowNibName dimensions:(CGRect)dimensions {
  self = [super initWithWindowNibName:windowNibName];
  _dimensions = dimensions;
  return self;
}

- (void)awakeFromNib {
  [_xCoordinate setStringValue:[NSString stringWithFormat:@"%.0f", _dimensions.origin.x]];
  [_yCoordinate setStringValue:[NSString stringWithFormat:@"%.0f", _dimensions.origin.y]];
  [_width setStringValue:[NSString stringWithFormat:@"%.0f", _dimensions.size.width]];
  [_height setStringValue:[NSString stringWithFormat:@"%.0f", _dimensions.size.height]];
}

- (void)windowWillClose:(NSNotification*)notification {
  _dialogCode = 0;
  [NSApp stopModalWithCode:_dialogCode];
  [self.window orderOut:nil];
}

- (IBAction)buttonAction:(NSButton*)sender {
  _dialogCode = sender.tag;
  [NSApp stopModalWithCode:_dialogCode];
  [self.window orderOut:nil];
}

- (CGRect)dimensions {
  _dimensions.origin.x = [[_xCoordinate stringValue] doubleValue];
  _dimensions.origin.y = [[_yCoordinate stringValue] doubleValue];
  _dimensions.size.width = [[_width stringValue] doubleValue];
  _dimensions.size.height = [[_height stringValue] doubleValue];
  return _dimensions;
}

- (Boolean)isSuccess {
  return _dialogCode == 1;
}

@end
