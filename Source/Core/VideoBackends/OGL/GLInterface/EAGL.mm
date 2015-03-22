// Copyright 2014 Dolphin Emulator Project
// Licensed under GPLv2
// Refer to the license.txt file included.

#include "VideoBackends/OGL/GLInterface/EAGL.h"

#include "VideoCommon/RenderBase.h"
#include "VideoCommon/VertexShaderManager.h"
#include "VideoCommon/VideoConfig.h"

void cInterfaceEAGL::Swap()
{
    /*EAGLContext *oldContext = [EAGLContext currentContext];
    
    if (oldContext != eaglContext)
        [EAGLContext setCurrentContext:eaglContext];
    
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);*/
    
    [eaglContext presentRenderbuffer:GL_RENDERBUFFER];
    
    //if (oldContext != eaglContext)
     //   [EAGLContext setCurrentContext:oldContext];
}

void* cInterfaceEAGL::GetFuncAddress(const std::string& name)
{
    //return (void*)eglGetProcAddress(name.c_str());
    
    NSLog(@"cInterfaceEAGL: GetFuncAddress for %s", name.c_str());
    void *handle = dlopen("/System/Library/Frameworks/OpenGLES.framework/OpenGLES", RTLD_LAZY);
    if (!handle)
    {
        NSLog(@"cInterfaceEAGL: dlerror, %s", dlerror());
    }
    void *symbol = dlsym(handle, name.c_str());
    if (!symbol)
    {
        NSLog(@"cInterfaceEAGL: dlerror, %s", dlerror());
    }
    //dlclose(handle);
    return symbol;
    
    /*CFStringRef frameworkPath = CFSTR("/System/Library/Frameworks/OpenGLES.framework");
    CFURLRef bundleURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                              frameworkPath,
                                              kCFURLPOSIXPathStyle, true);
    CFRelease(frameworkPath);
    
    CFBundleRef bundle = CFBundleCreate(kCFAllocatorDefault, bundleURL);
    void *res;
    
    CFStringRef procname = CFStringCreateWithCString(kCFAllocatorDefault, name.c_str(),
                                                     kCFStringEncodingASCII);
    res = CFBundleGetFunctionPointerForName(bundle, procname);
    CFRelease(procname);
    return res;*/
    
    /*static const struct mach_header* image = NULL;
    NSSymbol symbol;
    char* symbolName;
    if (NULL == image)
    {
        image = NSAddImage("/System/Library/Frameworks/OpenGL.framework/Versions/Current/OpenGL", NSADDIMAGE_OPTION_RETURN_ON_ERROR);
    }
    /* prepend a '_' for the Unix C symbol mangling convention
    symbolName = malloc(strlen((const char*)name) + 2);
    strcpy(symbolName+1, (const char*)name);
    symbolName[0] = '_';
    symbol = NULL;
    /* if (NSIsSymbolNameDefined(symbolName))
     symbol = NSLookupAndBindSymbol(symbolName);
    symbol = image ? NSLookupSymbolInImage(image, symbolName, NSLOOKUPSYMBOLINIMAGE_OPTION_BIND | NSLOOKUPSYMBOLINIMAGE_OPTION_RETURN_ON_ERROR) : NULL;
    free(symbolName);
    return symbol ? NSAddressOfSymbol(symbol) : NULL;*/
}

// Create rendering window.
// Call browser: Core.cpp:EmuThread() > main.cpp:Video_Initialize()
bool cInterfaceEAGL::Create(void *window_handle)
{
    // Get our UIView
    PanicAlert("EAGL: reinterpreting cast");
    currentView = reinterpret_cast<UIView*>(window_handle);
    
    // Create CoreAnimation Layer
    PanicAlert("EAGL: getting layer");
    CAEAGLLayer *eaglLayer = (CAEAGLLayer*) [currentView layer];
    eaglLayer.opaque = YES;
    
    // Create the EAGLContext with GLES3
    PanicAlert("EAGL: creating EAGLContext");
    eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    // Create our renderbuffer
    /*PanicAlert("EAGL: creating renderbuffer");
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    // Create our framebuffer
    PanicAlert("EAGL: creating framebuffer");
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    // Attach the renderbuffer to the framebuffer
    PanicAlert("EAGL: attaching renderbuffer to framebuffer");
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);*/
    
    // Set to GLES3
    PanicAlert("EAGL: setting s_opengl_mode");
    s_opengl_mode = GLInterfaceMode::MODE_OPENGLES3;
    
    // GL is now ready!
    PanicAlert("EAGL: we're done here!");
    return true;
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
    /*glDeleteRenderbuffers(1, &renderbuffer);
    renderbuffer = 0;
    glDeleteFramebuffers(1, &framebuffer);
    framebuffer = 0;*/
    [eaglContext release];
    eaglContext = nullptr;
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

