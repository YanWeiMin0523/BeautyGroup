//
//  GroupModel.h
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

@property(nonatomic, strong) NSString *headImage;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *love;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *youLoveID;

//自定义方法
- (instancetype)initGroupDictionary:(NSDictionary *)groupDic;

@end
