#import <Foundation/Foundation.h>

@class SpectacleHistoryItem;

@interface SpectacleHistory : NSObject {
    SpectacleHistoryItem *firstHistoryItem;
    SpectacleHistoryItem *lastHistoryItem;
    SpectacleHistoryItem *currentHistoryItem;
}

- (void)addHistoryItem: (SpectacleHistoryItem *)aHistoryItem;

#pragma mark -

- (SpectacleHistoryItem *)nextHistoryItem;

- (SpectacleHistoryItem *)previousHistoryItem;

#pragma mark -

- (BOOL)isEmpty;

@end
