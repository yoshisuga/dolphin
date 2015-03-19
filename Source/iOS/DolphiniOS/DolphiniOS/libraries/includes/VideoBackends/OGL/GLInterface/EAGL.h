// Copyright 2014 Dolphin Emulator Project
// Licensed under GPLv2
// Refer to the license.txt file included.

#pragma once

#ifdef __APPLE__
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <UIKit/UIKit.h>
#endif

#include "VideoBackends/OGL/GLInterfaceBase.h"

class cInterfaceEAGL : public cInterfaceBase
{
private:
    GLuint renderbuffer;
    GLuint framebuffer;
    UIView *currentView;
	EAGLContext *eaglContext;
public:
	void Swap();
	bool Create(void *window_handle);
	bool MakeCurrent();
	bool ClearCurrent();
	void Shutdown();
	void Update();
	void SwapInterval(int interval);
    void presentRenderbuffer();

};
