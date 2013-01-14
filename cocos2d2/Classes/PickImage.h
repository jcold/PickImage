//
//  PickImage.h
//  cocos2d2
//
//  Created by 余广伟 on 13-1-4.
//
//

#import <Foundation/Foundation.h>
#import "AppController.h"
#import "MBProgressHUD.h"

@interface PickImage : NSObject <UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate>
{
    //下拉菜单
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
    
    AppController* m_vc;
    
    MBProgressHUD *HUD;
}



-(void)openMenu: (AppController*)vc;



@end
