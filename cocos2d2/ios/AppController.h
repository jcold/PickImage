//
//  cocos2d2AppController.h
//  cocos2d2
//
//  Created by 广伟 余 on 12-9-12.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

@class RootViewController;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIApplicationDelegate> {
    UIWindow *window;
    RootViewController    *viewController;
}

- (RootViewController*)getRootViewController;

@end

