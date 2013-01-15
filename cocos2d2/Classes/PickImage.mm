//
//  PickImage.m
//  cocos2d2
//
//  Created by 余广伟 on 13-1-4.
//
//

#import "PickImage.h"
#include "EAGLView.h"
#include "CCDirector.h"
#import "ASIFormDataRequest.h"

@implementation PickImage



-(void)setUploadUrl: (const char*) url
{
    m_upload_url = [NSString stringWithCString:url encoding:NSUTF8StringEncoding];
}


-(void)openMenu: (AppController*)vc
{
    m_vc = vc;
    
//    UIViewController* vc = [[[UIViewController alloc] init] autorelease];
    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView* topView = [[keyWindow subviews] objectAtIndex:[[keyWindow subviews] count] - 1];
//    vc.view = topView;
    
//    m_vc = vc;
//    [m_vc retain];
    
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [myActionSheet showInView: keyWindow.subviews[0]];
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
        
        [[m_vc getRootViewController] presentModalViewController:picker animated:YES];
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
    picker.allowsEditing = YES;
    
//    UIViewController* root_controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    
//    [[UIApplication sharedApplication].keyWindow addSubview:picker.view];
    [[m_vc getRootViewController] presentModalViewController:picker animated:YES];
    
//      [[[CCDirector sharedDirector] openGLView] addSubview:picker.view];
    
    [picker autorelease];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        UIImage *midImage = [PickImage imageWithImageSimple:image scaledToSize:CGSizeMake(300.0, 300.0)];
        
        
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
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSArray*paths =NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);NSString* cachesDirectory =[paths objectAtIndex:0];
        
        
        NSString *filePath = [cachesDirectory stringByAppendingPathComponent:@"image.png"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil]
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
//        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        
        [self uploadFile];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}


//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height - height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
    
    
    
    /*
    
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
     */
    
}


-(void) uploadFile
{
    // @"http://ybp.h.yiibox.com/test/upload"
    NSURL *url = [NSURL URLWithString:m_upload_url];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:@"Copsey" forKey:@"last_name"];
    
//    [request timeOutSeconds: 30];
    
    [ASIHTTPRequest setDefaultTimeOutSeconds:30];
    
    
//    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString* filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];

//    NSString *tmpDir = NSTemporaryDirectory();
//    NSString *filePath2 = [tmpDir stringByAppendingPathComponent:@"image.png"];


    
    [request setFile:filePath forKey:@"avatar"];
    
    [request setCompletionBlock:^{
        [HUD hide:YES];
        
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSLog(responseString);
        
        // Use when fetching binary data
//        NSData *responseData = [request responseData];
    }];
    [request setFailedBlock:^{
        [HUD hide:YES];

        
        NSError *error = [request error];
        NSLog([error description]);
    }];
    
    
    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];

    RootViewController* vc = [m_vc getRootViewController];
    
    HUD = [[MBProgressHUD alloc] initWithView: keyWindow.subviews[0]];
	[keyWindow addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Uploading";
	
    [HUD show:YES];
//	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    [request startAsynchronous];
    
    [filePath release];
    
}



@end
