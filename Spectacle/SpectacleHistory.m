#import "SpectacleHistory.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleConstants.h"

@interface SpectacleHistory ()

@property (nonatomic) SpectacleHistoryItem *firstHistoryItem;
@property (nonatomic) SpectacleHistoryItem *lastHistoryItem;
@property (nonatomic) SpectacleHistoryItem *currentHistoryItem;
@property (nonatomic) NSInteger size;

@end

#pragma mark -

@implementation SpectacleHistory

- (id)init {
    if ((self = [super init])) {
        _firstHistoryItem = nil;
        _lastHistoryItem = _firstHistoryItem;
        _currentHistoryItem = _firstHistoryItem;
        _size = 0;
    }
    
    return self;
}

#pragma mark -

- (void)addHistoryItem: (SpectacleHistoryItem *)historyItem {
    if ([self isEmpty]) {
        _currentHistoryItem = historyItem;
        _firstHistoryItem = _currentHistoryItem;
        _lastHistoryItem = _firstHistoryItem;
    } else {
        historyItem.nextHistoryItem = _currentHistoryItem.nextHistoryItem;
        historyItem.previousHistoryItem = _currentHistoryItem;
        
        _currentHistoryItem.nextHistoryItem.previousHistoryItem = historyItem;
        _currentHistoryItem.nextHistoryItem = historyItem;
        
        if (![historyItem nextHistoryItem]) {
            _firstHistoryItem = historyItem;
        }
        
        if (![historyItem previousHistoryItem]) {
            _lastHistoryItem = historyItem;
        }
        
        _currentHistoryItem = historyItem;
    }
    
    if (++_size >= SpectacleWindowActionHistorySize) {
        _lastHistoryItem.nextHistoryItem.previousHistoryItem = _lastHistoryItem.previousHistoryItem;
        
        _lastHistoryItem = _lastHistoryItem.nextHistoryItem;
        
        _size--;
    }
}

#pragma mark -

- (SpectacleHistoryItem *)nextHistoryItem {
    return [self moveCurrentHistoryItemToHistoryItem: _currentHistoryItem.nextHistoryItem];
}

- (SpectacleHistoryItem *)previousHistoryItem {
    return [self moveCurrentHistoryItemToHistoryItem: _currentHistoryItem.previousHistoryItem];
}

#pragma mark -

- (BOOL)isEmpty {
    return _size == 0;
}

#pragma mark -

- (SpectacleHistoryItem *)moveCurrentHistoryItemToHistoryItem: (SpectacleHistoryItem *)historyItem {
    if (historyItem) {
        _currentHistoryItem = historyItem;
    }
    
    return historyItem;
}

@end
