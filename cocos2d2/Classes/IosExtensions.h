//
//  IosExtensions.h
//  cocos2d2
//
//  Created by 余广伟 on 13-1-14.
//
//

//#import <Foundation/Foundation.h>

@interface NSString (MyExtensions)
- (NSString *) md5;
@end

@interface NSData (MyExtensions)
- (NSString*)md5;
@end