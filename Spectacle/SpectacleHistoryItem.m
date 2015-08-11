#import "SpectacleHistoryItem.h"

@implementation SpectacleHistoryItem

- (instancetype)initWithAccessibilityElement:(ZKAccessibilityElement *)accessibilityElement windowRect:(CGRect)windowRect
{
    if (self = [super init]) {
        _accessibilityElement = accessibilityElement;
        _windowRect = windowRect;
    }
    
    return self;
}

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement:(ZKAccessibilityElement *)accessibilityElement
                                                   windowRect:(CGRect)windowRect
{
    return [[SpectacleHistoryItem alloc] initWithAccessibilityElement:accessibilityElement windowRect:windowRect];
}

@end
