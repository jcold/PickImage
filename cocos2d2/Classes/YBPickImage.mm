//
//  YBPickImage.mm
//  cocos2d2
//
//  Created by 余广伟 on 13-1-4.
//
//

#include "YBPickImage.h"
#include "PickImage.h"
#include "TestViewController.h"
#include "AppController.h"

void
YBPickImage::startPick()
{
    NSString *tmpDir = NSTemporaryDirectory();
    NSLog(@"%@", tmpDir);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@", documentsDirectory);

    AppController* pApp = (AppController*)[[UIApplication sharedApplication] delegate];
    
    PickImage* picker = [[PickImage alloc] init];
    [picker openMenu: pApp ];
    
//    UIViewController* root_controller = [UIApplication sharedApplication].keyWindow.rootViewController;

//    TestViewController* vc = [[[TestViewController alloc] init] autorelease];
//    [root_controller presentModalViewController:vc animated:YES];
    
//    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
//
//    [[keyWindow subviews] objectAtIndex:[[keyWindow subviews] count] - 1];
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController
//     presentModalViewController:vc animated:YES];
    
//    [root_controller.view addSubview:vc.view];
}