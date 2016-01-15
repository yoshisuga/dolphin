// Copyright 2016 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#include <dlfcn.h>

#include <UIKit/UIKit.h>

#include "Common/GL/GLInterface/EAGL.h"

#define GL_FRAMEBUFFER 0x8D40
#define GL_RENDERBUFFER 0x8D41
#define GL_COLOR_ATTACHMENT0 0x8CE0

typedef void (*PFNGLGENFRAMEBUFFERSPROC) (GLsizei n, GLuint *framebuffers);
typedef void (*PFNGLDELETEFRAMEBUFFERSPROC) (GLsizei n, const GLuint *framebuffers);
typedef void (*PFNGLBINDFRAMEBUFFERPROC) (GLenum target, GLuint framebuffer);
typedef void (*PFNGLGENRENDERBUFFERSPROC) (GLsizei n, GLuint *renderbuffers);
typedef void (*PFNGLDELETERENDERBUFFERSPROC) (GLsizei n, const GLuint *renderbuffers);
typedef void (*PFNGLBINDRENDERBUFFERPROC) (GLenum target, GLuint renderbuffer);
typedef void (*PFNGLFRAMEBUFFERRENDERBUFFERPROC) (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer);

static PFNGLGENFRAMEBUFFERSPROC glGenFramebuffers = nullptr;
static PFNGLDELETEFRAMEBUFFERSPROC glDeleteFramebuffers = nullptr;
static PFNGLBINDFRAMEBUFFERPROC glBindFramebuffer = nullptr;
static PFNGLGENRENDERBUFFERSPROC glGenRenderbuffers = nullptr;
static PFNGLDELETERENDERBUFFERSPROC glDeleteRenderbuffers = nullptr;
static PFNGLBINDRENDERBUFFERPROC glBindRenderbuffer = nullptr;
static PFNGLFRAMEBUFFERRENDERBUFFERPROC glFramebufferRenderbuffer = nullptr;

void cInterfaceEAGL::Swap()
{
	glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
	[eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

void* cInterfaceEAGL::GetFuncAddress(const std::string& name)
{
	return dlsym(RTLD_DEFAULT, name.c_str());
}

bool cInterfaceEAGL::Create(void *window_handle, bool core)
{
	@autoreleasepool {
		// Get our CAEAGLLayer instance
		CAEAGLLayer* eaglLayer = (__bridge CAEAGLLayer*) window_handle;
		
		// Create an EAGLContext for OpenGLES 3
		eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
		MakeCurrent();
		
		// Load all our needed functions.
		glGenFramebuffers = (PFNGLGENRENDERBUFFERSPROC) GetFuncAddress("glGenFramebuffers");
		glDeleteFramebuffers = (PFNGLDELETEFRAMEBUFFERSPROC) GetFuncAddress("glDeleteFramebuffers");
		glBindFramebuffer = (PFNGLBINDFRAMEBUFFERPROC) GetFuncAddress("glBindFramebuffer");
		glGenRenderbuffers = (PFNGLGENRENDERBUFFERSPROC) GetFuncAddress("glGenRenderbuffers");
		glDeleteRenderbuffers = (PFNGLDELETERENDERBUFFERSPROC) GetFuncAddress("glDeleteRenderbuffers");
		glBindRenderbuffer = (PFNGLBINDRENDERBUFFERPROC) GetFuncAddress("glBindRenderbuffer");
		glFramebufferRenderbuffer = (PFNGLFRAMEBUFFERRENDERBUFFERPROC) GetFuncAddress("glFramebufferRenderbuffer");
		
		// Create our framebuffer and renderbuffer
		glGenFramebuffers(1, &framebuffer);
		glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
		
		glGenRenderbuffers(1, &renderbuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
		[eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
		
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
		
		return true;
	}
}

bool cInterfaceEAGL::MakeCurrent()
{
	[EAGLContext setCurrentContext:eaglContext];
	return true;
}

bool cInterfaceEAGL::ClearCurrent()
{
	[EAGLContext setCurrentContext:nil];
	return true;
}

// Close backend
void cInterfaceEAGL::Shutdown()
{
	eaglContext = nil;
}

void cInterfaceEAGL::Update()
{
	// This shouldn't be needed...?
}

void cInterfaceEAGL::SwapInterval(int interval)
{
	// This shouldn't be needed...?
}
