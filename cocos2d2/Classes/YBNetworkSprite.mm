//
//  YBNetworkSprite.cpp
//  cocos2d2
//
//  Created by 余广伟 on 13-1-14.
//
//


#include "YBNetworkSprite.h"
#include "YBDownloadImage.h"


YBNetworkSprite::YBNetworkSprite()
: m_url(NULL)
, m_file_path(NULL)
{
    m_is_ready = FALSE;
    
    
//    CCNotificationCenter::sharedNotificationCenter()->addObserver(this, callfuncO_selector(YBNetworkSprite::callImageReady), MSG_IMAGE_DOWNLOAD_COMPLETE, NULL);
}


YBNetworkSprite::~YBNetworkSprite()
{
    removeListener();
    CC_SAFE_RELEASE_NULL(m_url);
    CC_SAFE_RELEASE_NULL(m_file_path);
}


void
YBNetworkSprite::setUrl(const char* url)
{
    m_url = CCString::create(url);
    m_url->retain();
    
    

    YBDownloadImage* download = [[YBDownloadImage alloc] init];
    const char* path = [download setUrl:url andDelegate:(void*)this];
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
YBNetworkSprite::callImageReady(CCObject* obj)
{
    CCLOG("Got message");
    CCString* path = (CCString*)obj;
    if (m_file_path->isEqual(path))
    {
        removeListener();
        CCLOG("Got Image: %s", path->getCString());
        CCSprite* sp = CCSprite::create(path->getCString());
        setTexture(sp->getTexture());
    }
}


void
YBNetworkSprite::downloadImageComplete(const char* path)
{
    CCLOG("Got message");
    if (m_file_path->isEqual(CCString::create(path)))
    {
        CCLOG("Got Image: %s", path);
        CCSprite* sp = CCSprite::create(path);
        setTexture(sp->getTexture());
    }
}


void
YBNetworkSprite::removeListener()
{
//    CCNotificationCenter::sharedNotificationCenter()->removeObserver(this, MSG_IMAGE_DOWNLOAD_COMPLETE);
}




