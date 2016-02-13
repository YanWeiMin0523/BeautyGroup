//
//  GroupView.m
//  BeautyGroup
//
//  Created by scjy on 16/2/12.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "GroupView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GroupView ()
{
    CGFloat _previonsImageBottom; //保存上一次图片底部的高度
    CGFloat _lastLabelBottom;  //最后一个label底部的高度
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;


@end

@implementation GroupView

//首先设置滚动的frame
- (void)awakeFromNib{
    self.scrollView.contentSize = CGSizeMake(kWidth, kHeight * 8);
}

//sett方法
- (void)setLoveDataDic:(NSDictionary *)loveDataDic{
    //图片
    NSArray *urls = loveDataDic[@"urls"];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
    //标题
    self.titleLabel.text = loveDataDic[@"title"];
    //地址和电话
    self.bankLabel.text = loveDataDic[@"address"];
    self.phoneLabel.text = loveDataDic[@"tel"];
    //简介
    self.priceLabel.text = loveDataDic[@"pricedesc"];
    //喜欢
    self.loveLabel.text = [NSString stringWithFormat:@"%@人喜欢", loveDataDic[@"fav"]];
    //时间
    NSString *newTime = [HWTools getDateFromString:@"new_start_time"];
    NSString *endTime = [HWTools getDateFromString:@"new_end_time"];
    self.timeLabel.text = [NSString stringWithFormat:@"正在进行%@-%@", newTime, endTime];
    //详情
    [self drawContentWithArray:loveDataDic[@"content"]];
    
    
}

- (void)drawContentWithArray:(NSArray *)array{
    for (NSDictionary *dic in array) {
        //获取文本
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] bigestSize:CGSizeMake(kWidth, 1000) Font:15.0];
        CGFloat y;
        if (_previonsImageBottom > 500) {
            //当第一个活动详情显示，label先从保留的图片底部的坐标开始
            y = 520 + _previonsImageBottom - 520;
        }else{
            //当第二个开始时，要加上上面控件的高度
            y = 520 + _previonsImageBottom;
        }
        //如果标题存在,标题高度应该是上次图片的高度的底部高度
        NSString *title = dic[@"title"];
        if (title !=nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.scrollView addSubview:titleLabel];
            y += 30;   //下边显示详细信息的时候，高度坐标再加30即标题的高度
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, y, kWidth- 10, height)];
        label.text = dic[@"description"];
        label.font = [UIFont systemFontOfSize:15.0];
        label.numberOfLines = 0;
        [self.scrollView addSubview:label];
        //保留最后一个label的高度
        _lastLabelBottom = label.bottom + 10 + 64;
        
        NSArray *urlArray = dic[@"urls"];
        //当某一段落没有图片的时候，上次图片的高度用上次label的高度+10
        if (urlArray == nil) {
            _previonsImageBottom = label.bottom + 10;
        }else{
            CGFloat lastImageBootm = 0.0;
            for (NSDictionary *urlDic in urlArray) {
                CGFloat imageY;
                if (urlArray.count > 1) {
                    //图片不止一张
                    if (lastImageBootm == 0.0) {
                        if (title != nil) {
                            //有title的加上title的label高度
                            imageY = _previonsImageBottom + label.height + 30 + 5;
                        }else{
                            imageY = _previonsImageBottom + label.height + 5;
                        }
                    }else{
                        imageY = lastImageBootm + 10;
                    }
                }else{
                    //图片单张的情况
                    imageY = label.bottom;
                }
                CGFloat width = [urlDic[@"width"] integerValue];
                CGFloat imageHeight = [urlDic[@"height"] integerValue];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, imageY, kWidth - 10, (kWidth - 10) / width * imageHeight)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                //每一次都保留图片底部的高度
                _previonsImageBottom = imageView.bottom + 5;
                [self.scrollView addSubview:imageView];
                if (urlArray.count > 1) {
                    lastImageBootm = imageView.bottom;
                }
                
            }
        }
    }
    if (_lastLabelBottom > _previonsImageBottom) {
        self.scrollView.contentSize = CGSizeMake(kWidth, _lastLabelBottom + 30);
    }
    //重新设置scrollView的可滚动高度
    self.scrollView.contentSize = CGSizeMake(kWidth, _previonsImageBottom + 30);
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
