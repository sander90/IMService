//
//  SDDatabase.h
//  IMService
//
//  Created by shansander on 16/4/25.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SDDatabase : NSObject

+ (SDDatabase *)databaseWithPath:(NSString *)path;

- (int)execSQL:(NSString * )sql;
@end
