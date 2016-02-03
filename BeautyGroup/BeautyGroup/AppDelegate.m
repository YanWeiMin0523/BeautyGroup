//
//  AppDelegate.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "AppDelegate.h"
#import "GroupViewController.h"
#import "HomeViewController.h"
#import "MainViewController.h"
#import "MoreViewController.h"
#import "BusinessViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "BeautyGroup.pch"
@interface AppDelegate ()<WeiboSDKDelegate, WXApiDelegate>
@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    //UITabBarController
    self.tabBarVC = [[UITabBarController alloc] init];
    //创建被管理的视图控制器
    //团购
    UIStoryboard *groupStory = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    UINavigationController *groupNav = groupStory. instantiateInitialViewController;
    groupNav.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_homepage"];
    UIImage *groupImage = [UIImage imageNamed:@"icon_tabbar_homepage_selected"];
    //选中的图片
    groupNav.tabBarItem.selectedImage = [groupImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置图片位置
    groupNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //上门服务
    UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *homeNav = homeStory. instantiateInitialViewController;
    homeNav.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_onsite"];
    UIImage *homeImage = [UIImage imageNamed:@"icon_tabbar_onsite_selected"];
    //选中的图片
    homeNav.tabBarItem.selectedImage = [homeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置图片位置
    homeNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //商家
    UIStoryboard *businessStory = [UIStoryboard storyboardWithName:@"Business" bundle:nil];
    UINavigationController *businessNav = businessStory. instantiateInitialViewController;
    businessNav.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_merchant_normal"];
    UIImage *businessImage = [UIImage imageNamed:@"icon_tabbar_merchant_selected"];
    //选中的图片
    businessNav.tabBarItem.selectedImage = [businessImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置图片位置
    businessNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //我的
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = mainStory. instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_mine"];
    UIImage *mainImage = [UIImage imageNamed:@"icon_tabbar_mine_selected"];
    //选中的图片
    mainNav.tabBarItem.selectedImage = [mainImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置图片位置
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //更多
    UIStoryboard *moreStory = [UIStoryboard storyboardWithName:@"More" bundle:nil];
    UINavigationController *moreNav = moreStory.instantiateInitialViewController;
    moreNav.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_misc"];
    UIImage *moreImage = [UIImage imageNamed:@"icon_tabbar_misc_selected"];
    //选中的图片
    moreNav.tabBarItem.selectedImage = [moreImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置图片位置
    moreNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //添加被管理的视图控制器
    self.tabBarVC.viewControllers = @[groupNav, homeNav, businessNav, mainNav, moreNav];
    //设置导航栏颜色
    self.tabBarVC.tabBar.barTintColor = [UIColor whiteColor];
    //设置根视图
    self.window.rootViewController = self.tabBarVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark ------------ 微博分享
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self];
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"恭喜您，分享成功!", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
