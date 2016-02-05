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
        self.headImage = groupDic[@""];
        self.title = groupDic[@""];
        self.love = groupDic[@""];
        self.price = groupDic[@""];
    }
    
    
    return self;
}



@end
