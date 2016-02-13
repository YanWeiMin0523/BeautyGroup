//
//  GroupView.h
//  BeautyGroup
//
//  Created by scjy on 16/2/12.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupView : UIView
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property(nonatomic, strong) NSDictionary *loveDataDic;

@end
