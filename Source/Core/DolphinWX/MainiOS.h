// Copyright 2016 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#import <Foundation/Foundation.h>

@interface MainiOS : NSObject

+ (void) SetUserDirectory:(NSString*) userDirectory;

+ (void) SaveDefaultPreferences;

+ (void) StartEmulationWithFile:(NSString*) file;

@end