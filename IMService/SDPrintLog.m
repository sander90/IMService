//
//  SDPrintLog.m
//  IMService
//
//  Created by shansander on 16/3/17.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "SDPrintLog.h"

@implementation SDPrintLog

+ (void)printLog:(NSString * )content
{
    printf("##############\n");
    printf("##");
    printf("%s",content.UTF8String);
    printf("##\n");
    printf("##############\n\n");

}

@end
