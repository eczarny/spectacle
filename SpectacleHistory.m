#import "SpectacleHistory.h"
#import "SpectacleHistoryItem.h"

@implementation SpectacleHistory

- (id)init {
    if ((self = [super init])) {
        firstHistoryItem = nil;
        lastHistoryItem = firstHistoryItem;
        currentHistoryItem = firstHistoryItem;
    }
    
    return self;
}

#pragma mark -

- (void)addHistoryItem: (SpectacleHistoryItem *)historyItem {
    if (!firstHistoryItem) {
        currentHistoryItem = historyItem;
        firstHistoryItem = currentHistoryItem;
        lastHistoryItem = firstHistoryItem;
    } else {
        [historyItem setPreviousHistoryItem: firstHistoryItem];
        
        [firstHistoryItem setNextHistoryItem: historyItem];
        
        firstHistoryItem = historyItem;
        
        currentHistoryItem = firstHistoryItem;
    }
}

#pragma mark -

- (SpectacleHistoryItem *)nextHistoryItem {
    SpectacleHistoryItem *historyItem = [currentHistoryItem nextHistoryItem];
    
    if (historyItem) {
        currentHistoryItem = historyItem;
    }
    
    return historyItem;
}

- (SpectacleHistoryItem *)previousHistoryItem {
    SpectacleHistoryItem *historyItem = [currentHistoryItem previousHistoryItem];
    
    if (historyItem) {
        currentHistoryItem = historyItem;
    }
    
    return historyItem;
}

#pragma mark -

- (BOOL)isEmpty {
    return !firstHistoryItem;
}

@end
