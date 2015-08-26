#import "SpectacleConstants.h"
#import "SpectacleHistory.h"
#import "SpectacleHistoryItem.h"

@interface SpectacleHistory ()

@property (nonatomic) SpectacleHistoryItem *firstHistoryItem;
@property (nonatomic) SpectacleHistoryItem *lastHistoryItem;
@property (nonatomic) SpectacleHistoryItem *currentHistoryItem;
@property (nonatomic) NSInteger size;

@end

#pragma mark -

@implementation SpectacleHistory

- (instancetype)init
{
  if ((self = [super init])) {
    _lastHistoryItem = self.firstHistoryItem;
    _currentHistoryItem = self.firstHistoryItem;
    _size = 0;
  }

  return self;
}

#pragma mark -

- (void)addHistoryItem:(SpectacleHistoryItem *)historyItem
{
  if ([self isEmpty]) {
    self.currentHistoryItem = historyItem;
    self.firstHistoryItem = self.currentHistoryItem;
    self.lastHistoryItem = self.firstHistoryItem;
  } else {
    historyItem.nextHistoryItem = self.currentHistoryItem.nextHistoryItem;
    historyItem.previousHistoryItem = self.currentHistoryItem;

    self.currentHistoryItem.nextHistoryItem.previousHistoryItem = historyItem;
    self.currentHistoryItem.nextHistoryItem = historyItem;

    if (![historyItem nextHistoryItem]) {
      self.firstHistoryItem = historyItem;
    }

    if (![historyItem previousHistoryItem]) {
      self.lastHistoryItem = historyItem;
    }

    self.currentHistoryItem = historyItem;
  }

  if (++_size >= kWindowActionHistorySize) {
    self.lastHistoryItem.nextHistoryItem.previousHistoryItem = self.lastHistoryItem.previousHistoryItem;

    self.lastHistoryItem = self.lastHistoryItem.nextHistoryItem;

    _size--;
  }
}

#pragma mark -

- (SpectacleHistoryItem *)nextHistoryItem
{
  return [self moveCurrentHistoryItemToHistoryItem:self.currentHistoryItem.nextHistoryItem];
}

- (SpectacleHistoryItem *)previousHistoryItem
{
  return [self moveCurrentHistoryItemToHistoryItem:self.currentHistoryItem.previousHistoryItem];
}

#pragma mark -

- (BOOL)isEmpty
{
  return _size == 0;
}

#pragma mark -

- (SpectacleHistoryItem *)moveCurrentHistoryItemToHistoryItem:(SpectacleHistoryItem *)historyItem
{
  if (historyItem) {
    self.currentHistoryItem = historyItem;
  }

  return historyItem;
}

@end
