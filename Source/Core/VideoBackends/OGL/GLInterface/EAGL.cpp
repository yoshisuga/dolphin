// Copyright 2014 Dolphin Emulator Project
// Licensed under GPLv2
// Refer to the license.txt file included.

#include "VideoBackends/OGL/GLInterface/EAGL.h"

#include "VideoCommon/RenderBase.h"
#include "VideoCommon/VertexShaderManager.h"
#include "VideoCommon/VideoConfig.h"

void cInterfaceEAGL::Swap()
{
    EAGLContext *oldContext = [EAGLContext currentContext];
    
    if (oldContext != eaglContext)
        [EAGLContext setCurrentContext:eaglContext];
    
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    
    [eaglContext presentRenderbuffer:GL_RENDERBUFFER];
    
    if (oldContext != eaglContext)
        [EAGLContext setCurrentContext:oldContext];
}

// Create rendering window.
// Call browser: Core.cpp:EmuThread() > main.cpp:Video_Initialize()
bool cInterfaceEAGL::Create(void *window_handle)
{
	/*cocoaWin = reinterpret_cast<NSView*>(window_handle);
	NSSize size = [cocoaWin frame].size;

	// Enable high-resolution display support.
	[cocoaWin setWantsBestResolutionOpenGLSurface:YES];

	NSWindow *window = [cocoaWin window];

	float scale = [window backingScaleFactor];
	size.width *= scale;
	size.height *= scale;

	// Control window size and picture scaling
	s_backbuffer_width = size.width;
	s_backbuffer_height = size.height;

	NSOpenGLPixelFormatAttribute attr[] = { NSOpenGLPFADoubleBuffer, NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core, NSOpenGLPFAAccelerated, 0 };
	NSOpenGLPixelFormat *fmt = [[NSOpenGLPixelFormat alloc]
		initWithAttributes: attr];
	if (fmt == nil)
	{
		ERROR_LOG(VIDEO, "failed to create pixel format");
		return false;
	}

	cocoaCtx = [[NSOpenGLContext alloc] initWithFormat: fmt shareContext: nil];
	[fmt release];
	if (cocoaCtx == nil)
	{
		ERROR_LOG(VIDEO, "failed to create context");
		return false;
	}

	if (cocoaWin == nil)
	{
		ERROR_LOG(VIDEO, "failed to create window");
		return false;
	}

	[window makeFirstResponder:cocoaWin];
	[cocoaCtx setView: cocoaWin];
	[window makeKeyAndOrderFront: nil];

	return true;*/
	
    // Get our UIView
    currentView = reinterpret_cast<UIView*>(window_handle);
    
    // Create CoreAnimation Layer
    CAEAGLLayer *eaglLayer = (CAEAGLLayer*) currentView.layer;
    eaglLayer.opaque = YES;
    
    // Create the EAGLContext with GLES3
    eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    // Create our renderbuffer
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    // Create our framebuffer
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    // Attach the renderbuffer to the framebuffer
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    
    // Set to GLES3
    s_opengl_mode = GLInterfaceMode::MODE_OPENGLES3;
    
    // GL is now ready!
}

bool cInterfaceEAGL::MakeCurrent()
{
    [EAGLContext setCurrentContext:eaglContext];
	return true;
}

bool cInterfaceEAGL::ClearCurrent()
{
    [EAGLContext setCurrentContext: nil];
	return true;
}

// Close backend
void cInterfaceEAGL::Shutdown()
{
    glDeleteRenderbuffers(1, &renderbuffer);
    renderbuffer = 0;
    glDeleteFramebuffers(1, &framebuffer);
    framebuffer = 0;
    [eaglContext release];
    eaglContext = nil;
}

void cInterfaceEAGL::Update()
{
	/*NSWindow *window = [cocoaWin window];
	NSSize size = [cocoaWin frame].size;

	float scale = [window backingScaleFactor];
	size.width *= scale;
	size.height *= scale;

	if (s_backbuffer_width == size.width &&
	    s_backbuffer_height == size.height)
		return;

	s_backbuffer_width = size.width;
	s_backbuffer_height = size.height;

	[cocoaCtx update];*/
    
    // We shouldn't need this...???
}

void cInterfaceEAGL::SwapInterval(int interval)
{
	//[cocoaCtx setValues:(GLint *)&interval forParameter:NSOpenGLCPSwapInterval];
    
    // VBlank sync is enforced by the hardware.
}

void cInterfaceEAGL::presentRenderbuffer()
{
    [eaglContext presentRenderbuffer: GL_RENDERBUFFER];
}

