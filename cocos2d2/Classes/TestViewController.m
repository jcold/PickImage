//
//  TestViewController.m
//  image
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    //导航栏标题
//	self.navigationItem.title = @"雨松MOMO输入框";
//
//    //导航栏按钮
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
//                                               initWithTitle: @"发送"
//                                               style: UIBarButtonItemStyleDone
//                                               target: self
//                                               action: @selector(sendInfo)] autorelease];
    
    //输入框显示区域
    _textEditor = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    //设置它的代理
    _textEditor.delegate = self;
    _textEditor.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textEditor.keyboardType = UIKeyboardTypeDefault;
    _textEditor.font = [UIFont systemFontOfSize:20];
    _textEditor.text = @"请输入内容";
    
    
    //默认软键盘是在触摸区域后才会打开
    //这里表示进入当前ViewController直接打开软键盘
    [_textEditor becomeFirstResponder];
    
    //把输入框加在视图中
    [self.view addSubview:_textEditor];
    
    //下方的图片按钮 点击后呼出菜单 打开摄像机 查找本地相册 
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"camera" ofType:@"png"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 120, image.size.width, image.size.height);
    
    [button setImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    
    //把它也加在视图当中
    [self.view addSubview:button];
    
    
}


-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                 initWithTitle:nil  
                 delegate:self
                 cancelButtonTitle:@"取消"   
                 destructiveButtonTitle:nil
                 otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];  
    
    [myActionSheet showInView:self.view];  
    [myActionSheet release];    

}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{ 
    
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex) 
    { 
        NSLog(@"取消");
    }
    
    switch (buttonIndex) 
    { 
        case 0:  //打开照相机拍照
            [self takePhoto];
            break; 
      
        case 1:  //打开本地相册
            [self LocalPhoto];
            break; 
    } 
}


//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera; 
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) 
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init]; 
        picker.delegate = self; 
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES; 
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES]; 
        [picker release];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }  
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIImage *midImage = [TestViewController imageWithImageSimple:image scaledToSize:CGSizeMake(300.0, 300.0)];

        
        NSData *data;
        if (UIImagePNGRepresentation(midImage) == nil) 
        {
            data = UIImageJPEGRepresentation(midImage, 1.0);
        }
        else 
        {
            data = UIImagePNGRepresentation(midImage);
        }
        
     
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];  
        
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];

        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        UIImageView *smallimage = [[[UIImageView alloc] initWithFrame:    
                                   CGRectMake(50, 120, 40, 40)] autorelease];    
        
        smallimage.image = image;
        //加在视图中
        [self.view addSubview:smallimage];
        
    } 
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}


//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


-(void)sendInfo
{
    NSLog(@"图片的路径是：%@", filePath);
    
    
    
    NSLog(@"您输入框中的内容是：%@", _textEditor.text);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
