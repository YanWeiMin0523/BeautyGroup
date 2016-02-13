//
//  GroupTableViewCell.m
//  BeautyGroup
//
//  Created by scjy on 16/2/12.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "GroupTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GroupTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation GroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//setter
- (void)setGroupModel:(GroupModel *)groupModel{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:groupModel.headImage] placeholderImage:nil];
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 20.0;
    self.titleLable.text = groupModel.title;
    self.loveLabel.text = [NSString stringWithFormat:@"%@", groupModel.love];
    self.priceLabel.text = groupModel.price;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
