//
//  MainiOS.cpp
//  
//
//  Created by mac on 2015-03-17.
//
//

#include "Core/Host.h"

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

void* Host_GetRenderHandle()
{
    UIView *window = [[UIApplication sharedApplication] keyWindow];
    return window.rootViewController.view;
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

void Host_UpdateTitle(const std::string& title) {}

void Host_ShowVideoConfig(void* parent, const std::string& backend_name,
                          const std::string& config_name) {}

