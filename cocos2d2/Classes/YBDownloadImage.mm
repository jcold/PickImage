//
//  DownloadImage.m
//  cocos2d2
//
//  Created by 余广伟 on 13-1-14.
//
//

#import "YBDownloadImage.h"
#include "cocos2d.h"
#include "IosExtensions.h"
#include "ASIHTTPRequest.h"

USING_NS_CC;




@implementation YBDownloadImage

//@synthesize filePath;
//@synthesize fileName;



-(const char*) setUrl:(const char*) str_url andDelegate:(YBDownloadImageDelegate*)delegate
{
    m_delegate = delegate;
    
    
    NSString* url2 = [NSString stringWithUTF8String:str_url];
    m_url = url2;
    [m_url retain];
    
    fileName = [url2 md5];
    [fileName retain];
    
    NSArray*paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString* cachesDirectory =[paths objectAtIndex:0];
    NSString* dir = [cachesDirectory stringByAppendingPathComponent:@"ImageCache"];
    
    // 创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dir])
    {
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    filePath = [dir stringByAppendingPathComponent:fileName];
    [filePath retain];
    NSLog(@"FilePath: %@ %d", filePath, [filePath retainCount]);
    
    return [filePath UTF8String];
}


-(void)download
{
    
    // 如果存在直接返回
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        [self postMessage];
        NSLog(@"Image existed");
        return;
    }
    
    
    
    NSURL *url = [NSURL URLWithString:m_url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:filePath];
    
    [request setCompletionBlock:^{
        NSLog(@"Loaded %@", filePath);
        
        UIImage* image = [UIImage imageWithContentsOfFile:filePath];
        if (nil == image)
        {
            [fileManager removeItemAtPath:filePath error:nil];
            NSLog(@"Image error");
        }
        else
        {
            [self postMessage];
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"Load error");
    }];
    
    
    [request startSynchronous];
}


-(void) postMessage
{
    if (m_delegate)
    {
        m_delegate->downloadImageComplete([filePath UTF8String]);
    }
    else
    {
        NSLog(@"Invalied delegate");
    }
}


-(void) dealloc
{
    NSLog(@"YBDownloadImage dealloc");
    [m_url release];
    [fileName release];
    [filePath release];
    [super dealloc];
}

@end
