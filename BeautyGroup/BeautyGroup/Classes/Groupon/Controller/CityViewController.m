//
//  CityViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/29.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "CityViewController.h"

@interface CityViewController ()

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButton];
    self.title = @"切换城市";
    self.navigationController.navigationBar.barTintColor = MainColor;
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏字体颜色和字体
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor], UITextAttributeFont:[UIFont systemFontOfSize:20.0]};
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)leftBarBtnAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
