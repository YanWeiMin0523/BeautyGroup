//
//  BusinessDetailViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/9.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "DetailView.h"
#import "AFHTTPSessionManager.h"
@interface BusinessDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;


@end

@implementation BusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"团购详情";
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    [self showBackButton];
    //导航栏小按钮
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_homepage_map"] style:UIBarButtonItemStylePlain target:nil action:@selector(GoToMap:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //right
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
 
    
    
}

#pragma mark --------- UITableViewDelegate

#pragma mark --------- UITableViewDataSource
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cell = @"";
//}

#pragma mark ----------- CustomMethod
- (void)GoToMap:(UIBarButtonItem *)barButton{
    
    
}

- (void)searchAction:(UIBarButtonItem *)barButton{
    
    
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
