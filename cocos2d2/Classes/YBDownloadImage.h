//
//  DownloadImage.h
//  cocos2d2
//
//  Created by 余广伟 on 13-1-14.
//
//

#import <Foundation/Foundation.h>

struct YBDownloadImageDelegate;

@interface YBDownloadImage : NSObject
{
    NSString* filePath;
    NSString* fileName;
    NSString* m_url;
    YBDownloadImageDelegate* m_delegate;
}

@property (nonatomic, retain) NSString* filePath;
@property (nonatomic, retain) NSString* fileName;


-(const char*) setUrl:(const char*) url andDelegate:(YBDownloadImageDelegate*)delegate;
-(void) download;

@end
