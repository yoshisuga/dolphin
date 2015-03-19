//
//  ViewController.swift
//  DolphiniOS
//
//  Created by mac on 2015-03-17.
//  Copyright (c) 2015 OatmealDome. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var runButton: UIButton!
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func run(sender: AnyObject) {
        runButton.hidden = true;
        
        /*let window = UIApplication.sharedApplication().keyWindow?;
        NSLog(window!.description)
        let view = window?.rootViewController?.view;
        NSLog(view!.description)*/
        /*
        NSString *userDir = [NSString stringWithCString:File::GetUserPath(D_USER_IDX).c_str() encoding:[NSString        defaultCStringEncoding]];
        if (userDir.length == 0) {

        }
        */

        var bridge = DolphinBridge()
        var userDir = bridge.getUserDirectory()
        
        if (countElements(userDir) == 0) {
            // First time running dolphin, let's initialize everything
            /*
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
            NSLog(basePath);
            */
            let docDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            NSLog(docDir)
            bridge.setUserDirectory(docDir + "/Dolphin")
            bridge.createUserFolders() // create our folders
            bridge.copyResources()
            bridge.saveDefaultPreferences()
            bridge.startEmulation()
        }
    }
    


}

