//
//  YBNetworkSprite.h
//  cocos2d2
//
//  Created by 余广伟 on 13-1-14.
//
//


#ifndef __cocos2d2__YBNetworkSprite__
#define __cocos2d2__YBNetworkSprite__

#include "cocos2d.h"
//#include "cocos-ext.h"
#include "YBDownloadImage.mm"
#include "YBDownloadImageDelegate.mm"



USING_NS_CC;
//USING_NS_CC_EXT;

class YBNetworkSprite
: public CCSprite
, public YBDownloadImageDelegate
{
public:
    YBNetworkSprite();
    virtual ~YBNetworkSprite();
    
    CC_SYNTHESIZE_READONLY(CCString*, m_file_path, FilePath);
    
    virtual void downloadImageComplete(const char* path);
    
    CCString* getUrl();
    void setUrl(const char* url);

    bool isReady();
    void callImageReady(CCObject* obj);
private:
    CCString* m_url;
    bool m_is_ready;
    
    void removeListener();
};

#endif /* defined(__cocos2d2__YBNetworkSprite__) */