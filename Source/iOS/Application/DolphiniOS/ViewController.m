//
//  ViewController.m
//  DolphiniOS
//
//  Created by mac on 2016-01-02.
//  Copyright © 2016 Dolphin Emulator Project. All rights reserved.
//

#import "MainiOS.h"

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	
	dispatch_queue_t queue = dispatch_queue_create("dolphinQueue", NULL);
	
	dispatch_async(queue, ^{
		[MainiOS SetUserDirectory:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
		[MainiOS SaveDefaultPreferences];
		[MainiOS StartEmulationWithFile:[[NSBundle mainBundle] pathForResource:@"starfield" ofType:@"dol"]];
	});
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
