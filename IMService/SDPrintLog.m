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

    printf("Test By XHF");
}

+(void)printLog:(NSString *)content WithTag:(NSString * )tag
{
    printf("[%s]  ",tag.UTF8String);
    printf("%s\n",content.UTF8String);
}

@end
