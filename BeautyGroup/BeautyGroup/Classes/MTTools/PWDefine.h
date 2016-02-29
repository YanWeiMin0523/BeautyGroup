//
//  PWDefine.h
//  helloPlayWeeks
//  以后把所有的接口都统一放在HWDefine里
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#ifndef PWDefine_h
#define PWDefine_h

typedef NS_ENUM(NSInteger, BusinessToClassfity) {
    BusinessToClassfityTypeAll = 1,
    BusinessToClassfityTypeCoupon
};

//猜你喜欢接口
#define kYouLOve @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&type=1&page=1"
//猜你喜欢详情接口
#define kLoveDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&lat=34.61356779156581&lng=112.4141403843618"
//首页按钮
#define kShopButton @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&type=1"


#define kBusiness @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=78284130ab87a8396ec03073eac9c50a&_t_=1452495156&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402"

//新浪微博分享
#define kAppKey @"290776830"
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define kAppSecret @"571ee650b429fe48095f404b10ef969f"

//微信分享
#define kWeixinKey @"wx63bad32379646e98"
#define kWeixinAppSecret @"432df58689cb5c87d64426f061645ca5"
#define kBmobKey @"0943f77b82ebeef017937871ceb7060e"

#endif /* PWDefine_h */
