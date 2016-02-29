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
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate ()<WeiboSDKDelegate, WXApiDelegate, CLLocationManagerDelegate>
{
    //定位
    CLLocationManager *_locationManager;
    //地理编码
    CLGeocoder *_geocoder;
}
@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //初始化定位对象
    _locationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
    //判断定位设备是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        YWMLog(@"定位服务未打开");
    }
    //用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位频率，每隔多少米定位一次
        CLLocationDistance distance = 10.0;
        _locationManager.distanceFilter = distance;
        //启动定位
        [_locationManager startUpdatingLocation];
    }
    
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
    groupNav.title = @"团购";
 
    
    //上门服务
    UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *homeNav = homeStory. instantiateInitialViewController;
    homeNav.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_onsite"];
    UIImage *homeImage = [UIImage imageNamed:@"icon_tabbar_onsite_selected"];
    //选中的图片
    homeNav.tabBarItem.selectedImage = [homeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.title = @"上门";
    
    
    //商家
    UIStoryboard *businessStory = [UIStoryboard storyboardWithName:@"Business" bundle:nil];
    UINavigationController *businessNav = businessStory. instantiateInitialViewController;
    businessNav.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_merchant_normal"];
    UIImage *businessImage = [UIImage imageNamed:@"icon_tabbar_merchant_selected"];
    //选中的图片
    businessNav.tabBarItem.selectedImage = [businessImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    businessNav.title = @"商家";
    
    
    //我的
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = mainStory. instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_mine"];
    UIImage *mainImage = [UIImage imageNamed:@"icon_tabbar_mine_selected"];
    //选中的图片
    mainNav.tabBarItem.selectedImage = [mainImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainNav.title = @"我的";
    
    //更多
    UIStoryboard *moreStory = [UIStoryboard storyboardWithName:@"More" bundle:nil];
    UINavigationController *moreNav = moreStory.instantiateInitialViewController;
    moreNav.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_misc"];
    UIImage *moreImage = [UIImage imageNamed:@"icon_tabbar_misc_selected"];
    //选中的图片
    moreNav.tabBarItem.selectedImage = [moreImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    moreNav.title = @"更多";
    //改变UITabBarItem字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MainColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
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


//定位方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //取出第一个位置
    CLLocation *location = [locations firstObject];
    //获取坐标
    CLLocationCoordinate2D coordinate = location.coordinate;
    YWMLog(@"经度：%f，纬度：%f，海拔：%f，航向：%f，行走速度：%f", coordinate.latitude, coordinate.longitude, location.altitude, location.course, location.speed);
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        YWMLog(@"%@", placeMark.addressDictionary);
        
    }];
    //如果不需要实时定位，使用完即关闭定位服务
    [_locationManager stopUpdatingLocation];
    
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
