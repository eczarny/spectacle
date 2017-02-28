#pragma once

#ifndef SPECTACLE_INIT_AND_NEW_UNAVAILABLE
#define SPECTACLE_INIT_AND_NEW_UNAVAILABLE \
- (instancetype)init NS_UNAVAILABLE; \
+ (instancetype)new NS_UNAVAILABLE;
#endif // SPECTACLE_INIT_AND_NEW_UNAVAILABLE

#define LOCALIZE_TEXT(text) \
NSLocalizedString(text, text)
