#import <Foundation/Foundation.h>

@class ZKAccessibilityElement;

@interface SpectacleHistoryItem : NSObject

@property (nonatomic) ZKAccessibilityElement *accessibilityElement;
@property (nonatomic) CGRect windowRect;
@property (nonatomic) SpectacleHistoryItem *nextHistoryItem;
@property (nonatomic) SpectacleHistoryItem *previousHistoryItem;

#pragma mark -

- (instancetype)initWithAccessibilityElement:(ZKAccessibilityElement *)accessibilityElement
                                  windowRect:(CGRect)windowRect NS_DESIGNATED_INITIALIZER;

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement:(ZKAccessibilityElement *)accessibilityElement
                                                   windowRect:(CGRect)windowRect;

@end
