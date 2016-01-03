// Copyright 2016 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#include "Common/GL/GLInterface/EAGL.h"

void cInterfaceEAGL::Swap()
{
	// [eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

// Create rendering window.
// Call browser: Core.cpp:EmuThread() > main.cpp:Video_Initialize()
bool cInterfaceEAGL::Create(void *window_handle, bool core)
{
	/*
	
	// Get our UIView
	PanicAlert("EAGL: reinterpreting cast");
	currentView = reinterpret_cast<UIView*>(window_handle);
	
	// Get the CAEAGLLayer instance
	PanicAlert("EAGL: getting layer");
	CAEAGLLayer *eaglLayer = (CAEAGLLayer*) [currentView layer];
	eaglLayer.opaque = YES;
	
	// Create a EAGLContext for OpenGLES 3
	PanicAlert("EAGL: creating EAGLContext");
	eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
	 
	// TODO: Setup framebuffer.
	
	// TODO: Setup renderbuffer.
	
	*/
	return true;
}

bool cInterfaceEAGL::MakeCurrent()
{
	// [EAGLContext setCurrentContext:eaglContext];
	return true;
}

bool cInterfaceEAGL::ClearCurrent()
{
	// [EAGLContext setCurrentContext:nil];
	return true;
}

// Close backend
void cInterfaceEAGL::Shutdown()
{
	// TODO: Check if ARC is enabled, if so we don't need to explicitly call release
	
	// [eaglContext release];
	// eaglContext = nil;
}

void cInterfaceEAGL::Update()
{
	// This shouldn't be needed...?
}

void cInterfaceEAGL::SwapInterval(int interval)
{
	// This shouldn't be needed...?
}
