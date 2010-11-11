// 
// Copyright (c) 2010 Eric Czarny <eczarny@gmail.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of  this  software  and  associated documentation files (the "Software"), to
// deal  in  the Software without restriction, including without limitation the
// rights  to  use,  copy,  modify,  merge,  publish,  distribute,  sublicense,
// and/or sell copies  of  the  Software,  and  to  permit  persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The  above  copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE  SOFTWARE  IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED,  INCLUDING  BUT  NOT  LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS  OR  COPYRIGHT  HOLDERS  BE  LIABLE  FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY,  WHETHER  IN  AN  ACTION  OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
// 

#import "SpectacleToggleSwitchCell.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectacleToggleSwitchCell (SpectacleToggleSwitchCellPrivate)

- (void)drawString: (NSString *)string withForegroundColor: (NSColor *)foregroundcolor inRect: (NSRect)rect;

@end

#pragma mark -

@implementation SpectacleToggleSwitchCell

- (void)drawWithFrame: (NSRect)frame inView: (NSView *)view {
    NSBundle *bundle = [SpectacleUtilities preferencePaneBundle];
    NSImage *sliderWell = [SpectacleUtilities imageFromResource: SpectacleSliderWellImage inBundle: bundle];
    NSImage *sliderMask = [SpectacleUtilities imageFromResource: SpectacleSliderMaskImage inBundle: bundle];
    NSImage *sliderHandle = [SpectacleUtilities imageFromResource: SpectacleSliderHandleImage inBundle: bundle];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    CGSize sliderWellSize = [sliderWell size];
    CGSize sliderMaskSize = [sliderMask size];
    CGFloat x = floor(frame.size.width / 2.0f) - floor(sliderWellSize.width / 2.0f);
    
    [sliderWell drawAtPoint: NSMakePoint(x, 1.0f) fromRect: frame operation: NSCompositeCopy fraction: 1.0f];
    [sliderHandle drawAtPoint: NSMakePoint(x - 2.0f, 1.0f) fromRect: frame operation: NSCompositeSourceOver fraction: 1.0f];
    
    x = x - floor((sliderMaskSize.width - sliderWellSize.width) / 2.0f);
    
    [sliderMask drawAtPoint: NSMakePoint(x, 0.0f) fromRect: frame operation: NSCompositeSourceAtop fraction: 1.0f];
    
    NSRect offRect = NSMakeRect(x - 46.0f, frame.origin.y, 40.0f, frame.size.height);
    NSRect onRect = NSMakeRect(x + sliderMaskSize.width + 2.0f, frame.origin.y, 40.0f, frame.size.height);
    
    [self drawString: @"OFF" withForegroundColor: [NSColor disabledControlTextColor] inRect: offRect];
    [self drawString: @"ON" withForegroundColor: [NSColor disabledControlTextColor] inRect: onRect];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

@end

#pragma mark -

@implementation SpectacleToggleSwitchCell (SpectacleToggleSwitchCellPrivate)

- (void)drawString: (NSString *)string withForegroundColor: (NSColor *)foregroundcolor inRect: (NSRect)rect {
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    NSShadow *textShadow = [[[NSShadow alloc] init] autorelease];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSRect labelRect = rect;
    
    [paragraphStyle setLineBreakMode: NSLineBreakByTruncatingTail];
    [paragraphStyle setAlignment: NSCenterTextAlignment];
    
    [textShadow setShadowColor: [NSColor whiteColor]];
    [textShadow setShadowOffset: NSMakeSize(0.0f, -1.0)];
    [textShadow setShadowBlurRadius: 0.0f];
    
    [attributes setObject: paragraphStyle forKey: NSParagraphStyleAttributeName];
    [attributes setObject: [NSFont systemFontOfSize: 20.0f] forKey: NSFontAttributeName];
    [attributes setObject: foregroundcolor forKey: NSForegroundColorAttributeName];
    [attributes setObject: textShadow forKey: NSShadowAttributeName];
    
    labelRect.origin.y = -(NSMidY(rect) - [string sizeWithAttributes: attributes].height / 2.0f);
    
    [string drawInRect: labelRect withAttributes: attributes];
}

@end
