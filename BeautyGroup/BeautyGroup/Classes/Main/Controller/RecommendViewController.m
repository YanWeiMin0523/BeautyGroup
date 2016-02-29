//
//  RecommendViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/16.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "RecommendViewController.h"
#import "LoveViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "GroupModel.h"
#import "GroupTableViewCell.h"
#import "ProgressHUD.h"
#import "PullingRefreshTableView.h"
@interface RecommendViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL canRefreshing;
@property(nonatomic, strong) NSMutableArray *recommendArray;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self showBackButton];
    self.title = @"每日推荐";
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    self.tabBarController.tabBar.hidden = YES;
    
    //网络请求
    [self getRequestModel];
    _pageCount = 1;
    
    
}

- (void)getRequestModel{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //演出剧目 typeid = 6
    [ProgressHUD show:@"拼命加载中……"];
    [httpManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kBusiness, _pageCount, @(6)] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.canRefreshing) {
                if (self.recommendArray.count > 0) {
                    [self.recommendArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GroupModel *model = [[GroupModel alloc] initGroupDictionary:dict];
                [self.recommendArray addObject:model];
                
            }
            
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        //刷新tableView数据,会执行所有tableView的代理方法
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"加载失败😢"];
        YWMLog(@"%@", error);
    }];

}

#pragma    mark ------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupTableViewCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GroupModel *model = self.recommendArray[indexPath.row];
    recommendCell.groupModel = model;
    
    recommendCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return recommendCell;
}

#pragma mark ----------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    LoveViewController *enjoyVC = [storyBoard instantiateViewControllerWithIdentifier:@"loveDetail"];
    GroupModel *model = self.recommendArray[indexPath.row];
    enjoyVC.loveDetailID = model.youLoveID;
    [self.navigationController pushViewController:enjoyVC animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recommendArray.count;
}

#pragma mark ------------ PullingTableView
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.canRefreshing = NO;
    [self performSelector:@selector(getRequestModel) withObject:nil afterDelay:1.0];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.canRefreshing = YES;
    [self performSelector:@selector(getRequestModel) withObject:nil afterDelay:1.0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

//刷新时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}

//页面
- (void)viewWillAppear:(BOOL)animated{
    [self viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark ----------- LazyLoading
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 50, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 140;
    }
    return _tableView;
}

- (NSMutableArray *)recommendArray{
    if (!_recommendArray) {
        self.recommendArray = [NSMutableArray new];
    }
    
    return _recommendArray;
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
