//
//  YBNetworkSprite.cpp
//  cocos2d2
//
//  Created by 余广伟 on 13-1-14.
//
//


#include "YBNetworkSprite.h"
#include "YBDownloadImage.h"


YBNetworkSprite*
YBNetworkSprite::create(const char *pszFileName)
{
    YBNetworkSprite *pobSprite = new YBNetworkSprite();
    if (pobSprite && pobSprite->initWithFile(pszFileName))
    {
        pobSprite->autorelease();
        return pobSprite;
    }
    CC_SAFE_DELETE(pobSprite);
    return NULL;
}


YBNetworkSprite::YBNetworkSprite()
: m_url(NULL)
, m_file_path(NULL)
{
    m_is_ready = FALSE;
    
    
//    CCNotificationCenter::sharedNotificationCenter()->addObserver(this, callfuncO_selector(YBNetworkSprite::callImageReady), MSG_IMAGE_DOWNLOAD_COMPLETE, NULL);
}


YBNetworkSprite::~YBNetworkSprite()
{
    CC_SAFE_RELEASE_NULL(m_url);
    CC_SAFE_RELEASE_NULL(m_file_path);
}


void
YBNetworkSprite::setUrl(const char* url)
{
    m_url = CCString::create(url);
    m_url->retain();
    
    

    YBDownloadImage* download = [[YBDownloadImage alloc] init];
    const char* path = [download setUrl:url andDelegate:this];
    m_file_path = CCString::create(path);
    m_file_path->retain();
    [download download];
    [download autorelease];
}


CCString*
YBNetworkSprite::getUrl()
{
    return m_url;
}


bool
YBNetworkSprite::isReady()
{
    return m_is_ready;
}



void
YBNetworkSprite::downloadImageComplete(const char* path)
{
    if (m_file_path->isEqual(CCString::create(path)))
    {
        CCLOG("Got Image: %s", path);
        initWithFile(path);
    }
}






