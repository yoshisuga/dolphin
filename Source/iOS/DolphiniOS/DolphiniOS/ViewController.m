//
//  ViewController.m
//  Tutorial1
//
//  Created by Anton Holmquist on 6/11/12.
//  Copyright (c) 2012 Anton Holmquist. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. Create an Xcode Project
    
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
    NSLog(@"EAGL: we're done here!");
    
}

@end
