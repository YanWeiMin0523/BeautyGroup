//
//  GroupViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupTableViewCell.h"
#import "GroupModel.h"
#import "ShopSpreeViewController.h"
#import "MoneyViewController.h"
#import "LoveViewController.h"
#import "BeautyGroup.pch"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface GroupViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;


@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor magentaColor];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //导航栏小按钮
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //right
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    //请求网络
    [self getRequest];
    
    [self configTableViewToHeadView];
 
    
}

#pragma mark ------------ ConstomMethod
//选择城市
- (void)selectCityAction:(UIBarButtonItem *)barButton{
    
    
}
- (void)searchAction:(UIBarButtonItem *)bar{
    
}

//网络请求
- (void)getRequest{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    httpManager GET:<#(nonnull NSString *)#> parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        YWMLog(@"%@", )
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        YWMLog(@"%@", error);
//    }
//    
    
}
//自定义方法显示tableview的区头
- (void)configTableViewToHeadView{
    UIView *tableViewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 343)];
    self.tableView.tableHeaderView = tableViewHead;
    
    
    
    
    
    
    
}

#pragma mark ------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    //点击单元格颜色不变
    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return groupCell;
}

#pragma mark ---------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

//单元格选中方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark ----------- lazyLoading


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
