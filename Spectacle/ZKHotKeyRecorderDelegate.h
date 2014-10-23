#import <Foundation/Foundation.h>

@class ZKHotKeyRecorder, ZKHotKey;

@protocol ZKHotKeyRecorderDelegate<NSObject>

- (void)hotKeyRecorder: (ZKHotKeyRecorder *)hotKeyRecorder didReceiveNewHotKey: (ZKHotKey *)hotKey;

- (void)hotKeyRecorder: (ZKHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey: (ZKHotKey *)hotKey;

@end
