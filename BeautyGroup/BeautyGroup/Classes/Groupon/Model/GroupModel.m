//
//  GroupModel.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

- (instancetype)initGroupDictionary:(NSDictionary *)groupDic{
    self = [super init];
    if (self) {
        self.headImage = groupDic[@"image"];
        self.title = groupDic[@"title"];
        self.love = groupDic[@"address"];
        self.price = groupDic[@"price"];
        self.youLoveID = groupDic[@"id"];
    }
    
    
    return self;
}



@end
