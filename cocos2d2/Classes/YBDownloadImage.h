//
//  DownloadImage.h
//  cocos2d2
//
//  Created by 余广伟 on 13-1-14.
//
//

#import <Foundation/Foundation.h>


@interface YBDownloadImage : NSObject
{
    NSString* filePath;
    NSString* fileName;
    NSString* m_url;
    void* m_delegate;
}

@property (nonatomic, retain) NSString* filePath;
@property (nonatomic, retain) NSString* fileName;


-(const char*) setUrl:(const char*) url andDelegate:(void*)delegate;
-(void) download;

@end
