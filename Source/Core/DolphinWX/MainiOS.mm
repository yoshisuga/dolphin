// Copyright 2016 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#include <cinttypes>
#include <cstdio>
#include <cstdlib>
#include <memory>
#include <UIKit/UIKit.h>

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
#include "Core/PowerPC/JitInterface.h"
#include "Core/PowerPC/PowerPC.h"
#include "Core/PowerPC/Profiler.h"

#include "DiscIO/Volume.h"
#include "DiscIO/VolumeCreator.h"

#include "DolphinWX/MainiOS.h"

#include "UICommon/UICommon.h"

#include "VideoCommon/OnScreenDisplay.h"
#include "VideoCommon/RenderBase.h"
#include "VideoCommon/VideoBackendBase.h"

bool Host_UIHasFocus()
{
	return true;
}

bool Host_RendererHasFocus()
{
	return true;
}

bool Host_RendererIsFullscreen()
{
	return false;
}

// Should return a instance of UIView.
void* Host_GetRenderHandle()
{
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	return [[window rootViewController] view];
}

void Host_ConnectWiimote(int wm_idx, bool connect) {}

void Host_Message(int Id) {}

void Host_NotifyMapLoaded() {}

void Host_RefreshDSPDebuggerWindow() {}

void Host_RequestRenderWindowSize(int width, int height) {}

void Host_RequestFullscreen(bool enable_fullscreen) {}

void Host_SetStartupDebuggingParameters() {}

void Host_SetWiiMoteConnectionState(int _State) {}

void Host_UpdateDisasmDialog() {}

void Host_UpdateMainFrame() {}

void Host_UpdateTitle(const std::string& title){}

void Host_ShowVideoConfig(void* parent, const std::string& backend_name,
						  const std::string& config_name) {}

static bool MsgAlert(const char* caption, const char* text, bool yes_no, int /*Style*/)
{
	// TODO: Check if ARC is enabled
	
	// This needs to be called on the UI thread
	dispatch_async(dispatch_get_main_queue(), ^{
		// TODO: This shows some garbage text, while the NSLog statement below shows the correct text. Fix this.
		NSString* message = [NSString stringWithFormat:@"Caption: %s\n\nText: %s", caption, text];
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
	});
	
	NSLog(@"Alert!\nCaption: %s\nText: %s\nyes_no: %i", caption, text, yes_no);
	
	return false;
}

// The following are called from the iOS application.

@implementation MainiOS

+ (void) StartEmulationWithFile:(NSString*) file userDirectory:(NSString*) userDirectory
{
	RegisterMsgAlertHandler(&MsgAlert);
	
	UICommon::SetUserDirectory(std::string([userDirectory UTF8String]));
	UICommon::Init();
	
	// No use running the loop when booting fails
	if (BootManager::BootCore([file UTF8String]))
	{
		PowerPC::Start();
		while (PowerPC::GetState() != PowerPC::CPU_POWERDOWN) {
			// Wait.
		}
	}
	
	Core::Shutdown();
	UICommon::Shutdown();
}

@end
