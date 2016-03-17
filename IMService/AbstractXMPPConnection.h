//
//  AbstractXMPPConnection.h
//  IMService
//
//  Created by shansander on 16/3/14.
//  Copyright © 2016年 shansander. All rights reserved.
//
/*
                    _ooOoo_
                   o8888888o
                   88" . "88
                   (| -_- |)
                   O\  =  /O
                ____/`---'\____
              .'  \\|     |//  `.
             /  \\|||  :  |||//  \
            /  _||||| -:- |||||-  \
            |   | \\\  -  /// |   |
            | \_|  ''\---/''  |   |
            \  .-\__  `-`  ___/-. /
          ___`. .'  /--.--\  `. . __
       ."" '<  `.___\_<|>_/___.'  >'"".
      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
      \  \ `-.   \_ __\ /__ _/   .-` /  /
 ======`-.____`-.___\_____/___.-`____.-'======
                    `=---='
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
          佛祖保佑       永无BUG
 */

#import <Foundation/Foundation.h>

@interface AbstractXMPPConnection : NSObject

@property (nonatomic, strong,readonly) NSString * username;
@property (nonatomic, strong,readonly) NSString * userpassword;
@property (nonatomic, strong,readonly) NSString * hostName;

- (id)initWithName:(NSString *)userName andPassword:(NSString * )password andServiceName:(NSString *)serviceName;
@end
