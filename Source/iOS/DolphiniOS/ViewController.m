//
//  ViewController.m
//  Tutorial1
//
//  Created by Anton Holmquist on 6/11/12.
//  Copyright (c) 2012 Anton Holmquist. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*// 1. Create an Xcode Project
    
    // 2. Create a Context
    GLView *glView = [[[GLView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)] autorelease];
    
    NSLog(@"EAGL: creating EAGLContext");
    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:eaglContext];
    
    // Create our framebuffer
    NSLog(@"EAGL: creating framebuffer");
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    // Create our renderbuffer
    NSLog(@"EAGL: creating renderbuffer");
    GLuint renderbuffer;
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)glView.layer];
    
    // Attach the renderbuffer to the framebuffer
    NSLog(@"EAGL: attaching renderbuffer to framebuffer");
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    
    // GL is now ready!
    NSLog(@"EAGL: we're done here!");*/
    
    /*
     var bridge = DolphinBridge()
     var userDir = bridge.getUserDirectory()
     
     bridge.glTest()
     
     if (countElements(userDir) == 0) {
     //bridge.glTest()
     // First time running dolphin, let's initialize everything
     /*
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
     NSLog(basePath);
    //let docDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    //bridge.setUserDirectory(docDir + "/Dolphin")
    //bridge.createUserFolders() // create our folders
    //bridge.copyResources()
    //bridge.saveDefaultPreferences()
    //bridge.startEmulation()
}
}
    */
    
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    GLView *glView = [[GLView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    
    // Create the EAGLContext with GLES3
    NSLog(@"EAGL: creating EAGLContext");
    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:eaglContext];
    
    // Create our framebuffer
    NSLog(@"EAGL: creating framebuffer");
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    // Create our renderbuffer
    NSLog(@"EAGL: creating renderbuffer");
    GLuint renderbuffer;
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)glView.layer];
    
    // Attach the renderbuffer to the framebuffer
    NSLog(@"EAGL: attaching renderbuffer to framebuffer");
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    
    // GL is now ready!
    NSLog(@"EAGL: we're done here!");
}

@end
