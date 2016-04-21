#import <Foundation/Foundation.h>

@class SpectacleHistoryItem;

@interface SpectacleHistory : NSObject

- (void)addHistoryItem:(SpectacleHistoryItem *)historyItem;

- (SpectacleHistoryItem *)nextHistoryItem;
- (SpectacleHistoryItem *)previousHistoryItem;

- (BOOL)isEmpty;

@end
