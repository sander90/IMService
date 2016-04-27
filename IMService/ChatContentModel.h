//
//  ChatContentModel.h
//  IMService
//
//  Created by shansander on 16/4/27.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ChatContentModel : NSObject

@property (nonatomic, strong) NSString * chatID;

@property (nonatomic, strong) NSString * friendname;

@property (nonatomic, strong) NSString * chatContent;

@property (nonatomic, assign) NSTimeInterval time;

- (id)initWithContent:(NSDictionary * )content;

@end
