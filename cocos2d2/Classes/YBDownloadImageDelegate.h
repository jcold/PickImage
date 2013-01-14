//
//  YBDownloadImageDelegate.h
//  cocos2d2
//
//  Created by 余广伟 on 13-1-14.
//
//

#ifndef cocos2d2_YBDownloadImageDelegate_h
#define cocos2d2_YBDownloadImageDelegate_h

class YBDownloadImageDelegate
{
public:
    virtual void downloadImageComplete(const char* path) = 0;
};

#endif
