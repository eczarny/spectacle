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
  [_xCoordinate setIntegerValue:lroundf(_dimensions.origin.x)];
  [_yCoordinate setIntegerValue:lroundf(_dimensions.origin.y)];
  [_width setIntegerValue:lroundf(_dimensions.size.width)];
  [_height setIntegerValue:lroundf(_dimensions.size.height)];
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
  _dimensions.origin.x = [_xCoordinate integerValue];
  _dimensions.origin.y = [_yCoordinate integerValue];
  _dimensions.size.width = [_width integerValue];
  _dimensions.size.height = [_height integerValue];
  NSLog(@"(%f, %f), (%f, %f)", _dimensions.origin.x, _dimensions.origin.y, _dimensions.size.width, _dimensions.size.height);
  return _dimensions;
}

- (Boolean)isSuccess {
  return _dialogCode == 1;
}

@end
