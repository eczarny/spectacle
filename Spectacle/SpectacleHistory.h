#import <Foundation/Foundation.h>

@class SpectacleHistoryItem;

@interface SpectacleHistory : NSObject

- (void)addHistoryItem:(SpectacleHistoryItem *)aHistoryItem;

#pragma mark -

- (SpectacleHistoryItem *)nextHistoryItem;

- (SpectacleHistoryItem *)previousHistoryItem;

#pragma mark -

- (BOOL)isEmpty;

@end
