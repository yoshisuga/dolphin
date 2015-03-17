// Copyright 2014 Dolphin Emulator Project
// Licensed under GPLv2
// Refer to the license.txt file included.

#include "VideoBackends/OGL/GLInterfaceBase.h"

#if defined(ANDROID) && !TARGET_OS_IPHONE
#include "VideoBackends/OGL/GLInterface/EGLAndroid.h"
#elif defined(__APPLE__) && !TARGET_OS_IPHONE
#include "VideoBackends/OGL/GLInterface/AGL.h"
#elif TARGET_OS_IPHONE
#include "VideoBackends/OGL/GLInterface/EAGL.h"
#elif defined(_WIN32)
#include "VideoBackends/OGL/GLInterface/WGL.h"
#elif HAVE_X11
#if defined(USE_EGL) && USE_EGL
#include "VideoBackends/OGL/GLInterface/EGLX11.h"
#else
#include "VideoBackends/OGL/GLInterface/GLX.h"
#endif
#else
#error Platform doesnt have a GLInterface
#endif

cInterfaceBase* HostGL_CreateGLInterface()
{
	#if defined(ANDROID) && !TARGET_OS_IPHONE
		return new cInterfaceEGLAndroid;
	#elif defined(__APPLE__) && !TARGET_OS_IPHONE
		return new cInterfaceAGL;
    #elif TARGET_OS_IPHONE
        return new cInterfaceEAGL;
	#elif defined(_WIN32)
		return new cInterfaceWGL;
	#elif defined(HAVE_X11) && HAVE_X11
	#if defined(USE_EGL) && USE_EGL
		return new cInterfaceEGLX11;
	#else
		return new cInterfaceGLX;
	#endif
	#else
		return nullptr;
	#endif
}
