//
//  LoveViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "LoveViewController.h"
#import "GroupView.h"
#import "AFHTTPSessionManager.h"
@interface LoveViewController ()
{
    NSString *_phoneNum;
}
@property (strong, nonatomic) IBOutlet GroupView *loveView;

@end

@implementation LoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"美团详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //返回按钮
    [self showBackButton];
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    //详细地址（地图）
    self.loveView.addressBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loveView.addressBtn addTarget:self action:@selector(goToAddress:) forControlEvents:UIControlEventTouchUpInside];
    //打电话
    self.loveView.phoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loveView.phoneBtn addTarget:self action:@selector(goToPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    //网络请求
    [self getRequestToModel];
    
}

- (void)getRequestToModel{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [httpManger GET:[NSString stringWithFormat:@"%@&id=%@", kLoveDetail, self.loveDetailID] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success" ] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.loveView.loveDataDic = successDic;
            //获取电话号码
            _phoneNum = successDic[@"tel"];
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
    }];
}

#pragma mark -------------- button  点击事件
- (void)goToPhone:(UIButton *)btn{
    //程序外打电话
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phoneNum]]];
    
    //程序内打电话
    UIWebView *callPhone = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phoneNum]]];
    [callPhone loadRequest:request];
    [self.view addSubview:callPhone];
    
}
- (void)goToAddress:(UIButton *)btn{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
