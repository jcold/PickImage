#include "HelloWorldScene.h"
#include "SimpleAudioEngine.h"
#include "YBPickImage.h"
#include "YBNetworkSprite.h"

using namespace cocos2d;
using namespace CocosDenshion;

CCScene* HelloWorld::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    HelloWorld *layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }
    



    

    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.

    // add a "close" icon to exit the progress. it's an autorelease object
    CCMenuItemImage *pCloseItem = CCMenuItemImage::create(
                                        "CloseNormal.png",
                                        "CloseSelected.png",
                                        this,
                                        menu_selector(HelloWorld::menuCloseCallback) );
    pCloseItem->setPosition( ccp(CCDirector::sharedDirector()->getWinSize().width - 20, 20) );

    // create menu, it's an autorelease object
    CCMenu* pMenu = CCMenu::create(pCloseItem, NULL);
    pMenu->setPosition( CCPointZero );
    this->addChild(pMenu, 1);
    
    
//    CCLOG(CCFileUtils::sharedFileUtils()->getWriteablePath().c_str());
//    CCLOG(CCFileUtils::sharedFileUtils()->fullPathFromRelativePath("camera.png"));
    
    char path_buffer[200] = {0};
    sprintf(path_buffer, "%simage.png", CCFileUtils::sharedFileUtils()->getWriteablePath().c_str());
    CCLOG(path_buffer);
    
  
    
//    YBNetworkSprite* sp_w = YBNetworkSprite::create();
//    sp_w->setUrl("http://himg2.huanqiu.com/attachment2010/2013/0114/thumb_100_80_20130114073715973.jpgs");
    
    
    

    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label
    CCLabelTTF* pLabel = CCLabelTTF::create("Hello World", "Thonburi", 34);

    // ask director the window size
    CCSize size = CCDirector::sharedDirector()->getWinSize();

    // position the label on the center of the screen
    pLabel->setPosition( ccp(size.width / 2, size.height - 20) );

    // add the label as a child to this layer
    this->addChild(pLabel, 1);

    // add "HelloWorld" splash screen"
//    YBNetworkSprite* pSprite = YBNetworkSprite::create("HelloWorld.png");
    YBNetworkSprite* pSprite = (YBNetworkSprite*)YBNetworkSprite::create("HelloWorld.png");
//    YBNetworkSprite* pSprite = new YBNetworkSprite();
    pSprite->initWithFile("HelloWorld.png");
    pSprite->setUrl("http://himg2.huanqiu.com/attachment2010/2013/0114/thumb_100_80_20130114073715973.jpg");


    // position the sprite on the center of the screen
    pSprite->setPosition( ccp(size.width/2, size.height/2) );

    // add the sprite as a child to this layer
    this->addChild(pSprite, 0);
    
    
    
//    CCSprite* sp = CCSprite::create( path_buffer );
//    sp->setPosition(pSprite->getPosition());
//    sp->setScale(0.5f);
//    addChild(sp);
    
    return true;
}

void HelloWorld::menuCloseCallback(CCObject* pSender)
{
//    CCDirector::sharedDirector()->end();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
//    exit(0);
#endif
    
    
    

    YBPickImage::pickImageAndUpload("http://ybp.h.yiibox.com/test/upload");
    
    
    
    
}
