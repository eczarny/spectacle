#import "SpectacleHistory.h"

#import "SpectacleHistoryItem.h"

@implementation SpectacleHistory
{
  SpectacleHistoryItem *_lastHistoryItem;
  SpectacleHistoryItem *_currentHistoryItem;
  NSInteger _size;
}

- (void)addHistoryItem:(SpectacleHistoryItem *)historyItem
{
  if ([self isEmpty]) {
    _currentHistoryItem = historyItem;
    _lastHistoryItem = _currentHistoryItem;
  } else {
    historyItem.previousHistoryItem = _currentHistoryItem;
    _currentHistoryItem.nextHistoryItem.previousHistoryItem = historyItem;
    _currentHistoryItem.nextHistoryItem = historyItem;
    if (![historyItem previousHistoryItem]) {
      _lastHistoryItem = historyItem;
    }
    _currentHistoryItem = historyItem;
  }
  if (++_size > 50) {
    _lastHistoryItem.nextHistoryItem.previousHistoryItem = nil;
    _lastHistoryItem = _lastHistoryItem.nextHistoryItem;
    _size--;
  }
}

- (SpectacleHistoryItem *)nextHistoryItem
{
  SpectacleHistoryItem *historyItem = _currentHistoryItem.nextHistoryItem;
  if (historyItem) {
    _currentHistoryItem = historyItem;
    _size++;
  }
  return historyItem;
}

- (SpectacleHistoryItem *)previousHistoryItem
{
  SpectacleHistoryItem *historyItem = _currentHistoryItem.previousHistoryItem;
  if (historyItem) {
    _currentHistoryItem = historyItem;
    _size--;
  }
  return historyItem;
}

- (BOOL)isEmpty
{
  return _size == 0;
}

@end
