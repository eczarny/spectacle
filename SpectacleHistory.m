#import "SpectacleHistory.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleConstants.h"

@interface SpectacleHistory (SpectacleHistoryPrivate)

- (SpectacleHistoryItem *)moveCurrentHistoryItemToHistoryItem: (SpectacleHistoryItem *)historyItem;

@end

#pragma mark -

@implementation SpectacleHistory

- (id)init {
    if ((self = [super init])) {
        firstHistoryItem = nil;
        lastHistoryItem = firstHistoryItem;
        currentHistoryItem = firstHistoryItem;
        size = 0;
    }
    
    return self;
}

#pragma mark -

- (void)addHistoryItem: (SpectacleHistoryItem *)historyItem {
    if ([self isEmpty]) {
        currentHistoryItem = historyItem;
        firstHistoryItem = currentHistoryItem;
        lastHistoryItem = firstHistoryItem;
    } else {
        [historyItem setNextHistoryItem: [currentHistoryItem nextHistoryItem]];
        
        [historyItem setPreviousHistoryItem: currentHistoryItem];
        
        [[currentHistoryItem nextHistoryItem] setPreviousHistoryItem: historyItem];
        
        [currentHistoryItem setNextHistoryItem: historyItem];
        
        if (![historyItem nextHistoryItem]) {
            firstHistoryItem = historyItem;
        }
        
        if (![historyItem previousHistoryItem]) {
            lastHistoryItem = historyItem;
        }
        
        currentHistoryItem = historyItem;
    }
    
    if (++size >= SpectacleWindowActionHistorySize) {
        [[lastHistoryItem nextHistoryItem] setPreviousHistoryItem: [lastHistoryItem previousHistoryItem]];
        
        lastHistoryItem = [lastHistoryItem nextHistoryItem];
        
        size--;
    }
}

#pragma mark -

- (SpectacleHistoryItem *)nextHistoryItem {
    return [self moveCurrentHistoryItemToHistoryItem: [currentHistoryItem nextHistoryItem]];
}

- (SpectacleHistoryItem *)previousHistoryItem {
    return [self moveCurrentHistoryItemToHistoryItem: [currentHistoryItem previousHistoryItem]];
}

#pragma mark -

- (BOOL)isEmpty {
    return size == 0;
}

@end

#pragma mark -

@implementation SpectacleHistory (SpectacleHistoryPrivate)

- (SpectacleHistoryItem *)moveCurrentHistoryItemToHistoryItem: (SpectacleHistoryItem *)historyItem {
    if (historyItem) {
        currentHistoryItem = historyItem;
    }
    
    return historyItem;
}

@end
