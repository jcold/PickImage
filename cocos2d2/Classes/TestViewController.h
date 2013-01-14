//
//  TestViewController.h
//  image
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    //输入框
    UITextView *_textEditor;
    
    //下拉菜单
    UIActionSheet *myActionSheet;
    
    
    //图片2进制路径
    NSString* filePath;
}
@end
