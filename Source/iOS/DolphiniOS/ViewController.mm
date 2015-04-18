
#import "ViewController.h"
#import "GLView.h"
#import "DolphinBridge.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create our GLView
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    GLView *glView = [[GLView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    self.view = glView;
    
    DolphinBridge *bridge = [DolphinBridge alloc];
    NSString *userDir = [bridge getUserDirectory];
    
    // redirect console to ~/Documents/dolphin-console.log.
    // because we have to copy  the bundle directly to /Applications, we have to attach
    // Xcode's debugger manually. when doing so, it doesn't attach the console for some
    // reason, forcing us to have to redirect the console into a file and tail it over ssh.
    [bridge redirectConsole];
    NSLog(@"NEW INSTANCE ---");
    NSLog(@"Waiting for 15s...");
    
    // let's have a change to actually attach the debugger
    [NSThread sleepForTimeInterval:15];
    
    if (userDir.length == 0)
    {
        // let's setup everything
        NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        [bridge setUserDirectory:[docDir stringByAppendingString:@"/Dolphin"]];
        [bridge createUserFolders];
        [bridge copyResources];
        [bridge saveDefaultPreferences];
    }
    
    // start emulation!
    [bridge startEmulation];
    
}

@end
