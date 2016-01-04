// Copyright 2016 Dolphin Emulator Project
// Licensed under GPLv2
// Refer to the license.txt file included.

#pragma once

#include <OpenGLES/EAGLDrawable.h>
#include <OpenGLES/gltypes.h>

#include "Common/GL/GLInterfaceBase.h"

class cInterfaceEAGL : public cInterfaceBase
{
private:
	EAGLContext* eaglContext;
	GLuint framebuffer;
	GLuint renderbuffer;
public:
	void Swap();
	void SetMode(u32 mode) { s_opengl_mode = mode; }
	void* GetFuncAddress(const std::string& name);
	bool Create(void *window_handle, bool core = true);
	bool MakeCurrent();
	bool ClearCurrent();
	void Shutdown();
	void Update();
	void SwapInterval(int interval);
};
