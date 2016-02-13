//
//  ShopSpreeViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ShopSpreeViewController.h"
#import "PullingRefreshTableView.h"
#import "GroupModel.h"
#import "AFHTTPSessionManager.h"
#import "GroupTableViewCell.h"
#import "LoveViewController.h"
@interface ShopSpreeViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>

{
    NSInteger _pageCount;
}
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *adArray;

@end

@implementation ShopSpreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"周边游";
    self.tabBarController.tabBar.hidden = YES;
    [self showBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];

   //网络请求
    [self getRequestToShop];
}

#pragma mark ----------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GroupModel *model = self.adArray[indexPath.row];
    shopCell.groupModel = model;
    
    shopCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return shopCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.adArray.count;
}

//单元格选中方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    LoveViewController *enjoyVC = [storyBoard instantiateViewControllerWithIdentifier:@"loveDetail"];
    GroupModel *model = self.adArray[indexPath.row];
    enjoyVC.loveDetailID = model.youLoveID;
    [self.navigationController pushViewController:enjoyVC animated:YES];
    
}


- (void)getRequestToShop{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [httpManger GET:[NSString stringWithFormat:@"%@&page=%ld", kShopButton, _pageCount] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *array = successDic[@"acData"];
            if (self.refreshing) {
                //下拉刷新的时候需要移除数组中的元素
                if (self.adArray.count > 0) {
                    [self.adArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in array) {
                GroupModel *model = [[GroupModel alloc] initGroupDictionary:dict];
                [self.adArray addObject:model];
                
            }
            
            //完成加载
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            //刷新tableView数据,会执行所有tableView的代理方法
            [self.tableView reloadData];
        }else{
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
    }];
    
    
    
    
}

#pragma mark ------------ PullingTableView
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(getRequestToShop) withObject:nil afterDelay:1.0];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(getRequestToShop) withObject:nil afterDelay:1.0];
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


#pragma mark -------------- LazyLoading
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 140;
        
    }
    return _tableView;
}

- (NSMutableArray *)adArray{
    if (!_adArray) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
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
