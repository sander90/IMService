//
//  ChatContent+CoreDataProperties.h
//  IMService
//
//  Created by shansander on 16/4/22.
//  Copyright © 2016年 shansander. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatContent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chatid;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *fromid;
@property (nullable, nonatomic, retain) NSDate *createdata;

@end

NS_ASSUME_NONNULL_END
