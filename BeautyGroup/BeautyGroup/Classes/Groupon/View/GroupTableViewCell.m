//
//  GroupTableViewCell.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "GroupTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GroupTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation GroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//setter方法赋值
- (void)setGroupModel:(GroupModel *)groupModel{
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
