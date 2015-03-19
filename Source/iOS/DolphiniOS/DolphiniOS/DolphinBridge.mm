//
//  DolphinBridge.m
//  DolphiniOS
//
//  Created by mac on 2015-03-17.
//  Copyright (c) 2015 OatmealDome. All rights reserved.
//

#import "DolphinBridge.h"

#import <Foundation/Foundation.h>
#import "Common/FileUtil.h"

#include <cstdio>
#include <cstdlib>

#include "Android/ButtonManager.h"
#include "Common/CommonPaths.h"
#include "Common/CommonTypes.h"
#include "Common/CPUDetect.h"
#include "Common/Event.h"
#include "Common/FileUtil.h"
#include "Common/Logging/LogManager.h"
#include "Core/BootManager.h"
#include "Core/ConfigManager.h"
#include "Core/Core.h"
#include "Core/Host.h"
#include "Core/State.h"
#include "Core/HW/Wiimote.h"
#include "Core/PowerPC/PowerPC.h"

// Banner loading
#include "DiscIO/BannerLoader.h"
#include "DiscIO/Filesystem.h"
#include "DiscIO/VolumeCreator.h"

#include "UICommon/UICommon.h"

#include "VideoCommon/OnScreenDisplay.h"
#include "VideoCommon/VideoBackendBase.h"

// Based off various files for the Android port by Sonicadvance1
@implementation DolphinBridge : NSObject

- (void) createUserFolders
{
    //NSLog(@"path: %s", File::GetUserPath(D_CONFIG_IDX).c_str());
    //NSLog(@"user dir: %@", self.getUserDirectory);
    //NSLog(@"path %s", File::GetUserPath(D_CONFIG_IDX).c_str());
    //NSLog(@"support status: %@ %@", cpu_info.bNEON ? @"true" : @"false", cpu_info.bASIMD ? @"true" : @"false");
    File::CreateFullPath(File::GetUserPath(D_CONFIG_IDX));
    File::CreateFullPath(File::GetUserPath(D_GCUSER_IDX));
    File::CreateFullPath(File::GetUserPath(D_WIIUSER_IDX));
    File::CreateFullPath(File::GetUserPath(D_CACHE_IDX));
    File::CreateFullPath(File::GetUserPath(D_DUMPDSP_IDX));
    File::CreateFullPath(File::GetUserPath(D_DUMPTEXTURES_IDX));
    File::CreateFullPath(File::GetUserPath(D_HIRESTEXTURES_IDX));
    File::CreateFullPath(File::GetUserPath(D_SCREENSHOTS_IDX));
    File::CreateFullPath(File::GetUserPath(D_STATESAVES_IDX));
    File::CreateFullPath(File::GetUserPath(D_MAILLOGS_IDX));
    File::CreateFullPath(File::GetUserPath(D_SHADERS_IDX));
    File::CreateFullPath(File::GetUserPath(D_GCUSER_IDX) + USA_DIR DIR_SEP);
    File::CreateFullPath(File::GetUserPath(D_GCUSER_IDX) + EUR_DIR DIR_SEP);
    File::CreateFullPath(File::GetUserPath(D_GCUSER_IDX) + JAP_DIR DIR_SEP);
}

- (NSString*) getUserDirectory {
   return [NSString stringWithCString:File::GetUserPath(D_USER_IDX).c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void) setUserDirectory: (NSString*)userDir
{
    NSLog(@"Setting user directory to %@", userDir);
    std::string directory([userDir cStringUsingEncoding:NSUTF8StringEncoding]);
    UICommon::SetUserDirectory(directory);
}

- (NSString*) getLibraryDirectory {
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/Dolphin/"];
}

- (void) copyResources {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: self.getLibraryDirectory]) {
        NSLog(@"setting library directory to %@", self.getLibraryDirectory);
        NSError *err = nil;
        if (![fileManager createDirectoryAtPath:self.getLibraryDirectory withIntermediateDirectories:YES attributes:nil error:&err]) {
            NSLog(@"Error creating library directory: %@", [err localizedDescription]);
        }
    }
    if (![fileManager fileExistsAtPath: [self.getLibraryDirectory stringByAppendingString:@"GC"]]) {
        NSLog(@"Copying GC folder...");
        [self copyDirectoryOrFile:fileManager :@"GC"];
    }
    if (![fileManager fileExistsAtPath: [self.getLibraryDirectory stringByAppendingString:@"Shaders"]]) {
        NSLog(@"Copying Shaders folder...");
        [self copyDirectoryOrFile:fileManager :@"Shaders"];
    }
}

- (void) copyDirectoryOrFile:(NSFileManager*)fileMgr :(NSString *)directory {
    NSString *destination = [self.getLibraryDirectory stringByAppendingString:directory];
    NSString *source = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/"] stringByAppendingString:directory];
    NSLog(@"copyDirectory source: %@", source);
    
    NSError *err = nil;
    if(![fileMgr copyItemAtPath:source toPath:destination error:&err]) {
        NSLog(@"Error copying directory: %@", [err localizedDescription]);
    }
}

- (void) loadPreferences {
    IniFile ini;
    ini.Load("Dolphin.ini");
    // we don't need this just yet, but we should have a prefs panel later on
}

- (void) saveDefaultPreferences {
    IniFile dolphinConfig;
    dolphinConfig.Load(File::GetUserPath(D_CONFIG_IDX) + "Dolphin.ini");
    dolphinConfig.GetOrCreateSection("Core")->Set("CPUThread", "True"); // originally false
    dolphinConfig.GetOrCreateSection("Core")->Set("Fastmem", "True"); // originally false
    dolphinConfig.GetOrCreateSection("Core")->Set("GFXBackend", "OGL");
    dolphinConfig.Save(File::GetUserPath(D_CONFIG_IDX) + "Dolphin.ini");
    
    IniFile oglConfig;
    oglConfig.Load(File::GetUserPath(D_CONFIG_IDX) + "gfx_opengl.ini");
    
    IniFile::Section *oglSettings = oglConfig.GetOrCreateSection("Settings");
    oglSettings->Set("ShowFPS", "True"); // originally false
    oglSettings->Set("EFBScale", "2");
    oglSettings->Set("MSAA", "0");
    oglSettings->Set("EnablePixelLighting", "True"); // originally false
    oglSettings->Set("DisableFog", "False");
    
    IniFile::Section *oglEnhancements = oglConfig.GetOrCreateSection("Enhancements");
    oglEnhancements->Set("MaxAnisotropy", "0");
    oglEnhancements->Set("PostProcessingShader", "");
    oglEnhancements->Set("ForceFiltering", "True"); // originally false
    oglEnhancements->Set("StereoSwapEyes", "True"); // originally false, not sure why this is true in the Android version
    oglEnhancements->Set("StereoMode", "0");
    oglEnhancements->Set("StereoDepth", "20");
    oglEnhancements->Set("StereoConvergence", "20");
    
    IniFile::Section *oglHacks = oglConfig.GetOrCreateSection("Hacks");
    oglHacks->Set("EFBScaledCopy", "True");
    oglHacks->Set("EFBAccessEnable", "True"); // originally false
    oglHacks->Set("EFBEmulateFormatChanges", "True"); // originally false
    oglHacks->Set("EFBCopyEnable", "True");
    oglHacks->Set("EFBToTextureEnable", "True");
    oglHacks->Set("EFBCopyCacheEnable", "False");
    
    oglConfig.Save(File::GetUserPath(D_CONFIG_IDX) + "gfx_opengl.ini");
    
}

// oh my!
- (void) startEmulation {
    
    NSLog(@"Emulation will now commence!! Setting user dir...");
    UICommon::SetUserDirectory([[self getUserDirectory] cStringUsingEncoding:NSUTF8StringEncoding]);
    NSLog(@"Calling UICommon::Init()");
    UICommon::Init();
    
    NSString *starfieldDol = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/"] stringByAppendingString:@"/starfield.dol"];
    
    // No use running the loop when booting fails
    NSLog(@"Booting PowerPC :o");
    if ( BootManager::BootCore([starfieldDol UTF8String]))
        while (PowerPC::GetState() != PowerPC::CPU_POWERDOWN)
            // we wait...
    
    UICommon::Shutdown();
}



@end