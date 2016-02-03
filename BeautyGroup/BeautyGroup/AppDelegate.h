//
//  AppDelegate.h
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *wntoken;
    NSString *wbCurrentUserID;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) UITabBarController *tabBarVC;
@property(nonatomic, copy) NSString *wbtoken;
@property(nonatomic, copy) NSString *wbCurrentUserID;
@property(nonatomic, copy) NSString *wbRefreshToken;

@end

