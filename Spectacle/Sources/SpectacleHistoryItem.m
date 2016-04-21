#import "SpectacleHistoryItem.h"

@implementation SpectacleHistoryItem

- (instancetype)initWithAccessibilityElement:(SpectacleAccessibilityElement *)accessibilityElement windowRect:(CGRect)windowRect
{
  if (self = [super init]) {
    _accessibilityElement = accessibilityElement;
    _windowRect = windowRect;
  }
  return self;
}

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement:(SpectacleAccessibilityElement *)accessibilityElement
                                                   windowRect:(CGRect)windowRect
{
  return [[SpectacleHistoryItem alloc] initWithAccessibilityElement:accessibilityElement windowRect:windowRect];
}

@end
