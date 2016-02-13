//
//  BusinessViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "BusinessViewController.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "GroupTableViewCell.h"
#import "GroupModel.h"
#import "VOSegmentedControl.h"
#import "ProgressHUD.h"
#import "LoveViewController.h"
@interface BusinessViewController ()<UITableViewDelegate, UITableViewDataSource, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;  //请求的页码
}
@property(nonatomic, assign) BOOL canRefreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) VOSegmentedControl *VOsegemented;
@property(nonatomic, strong) NSMutableArray *allArray;
@property(nonatomic, strong) NSMutableArray *couponArray;
@property(nonatomic, strong) NSMutableArray *dataAllArray;

@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.VOsegemented];

    _pageCount = 1;
    //全部商品的网络请求
    [self businessToAll];
    //选择网络请求
    [self chooseRequest];
    
}

- (void)chooseRequest{
    if (self.canRefreshing) {
        if (self.dataAllArray.count > 0) {
            [self.dataAllArray removeAllObjects];
        }
    }
    //判断请求的数据
    switch (self.businessToType) {
        case BusinessToClassfityTypeAll:
            [self businessToAll];
            self.dataAllArray = self.allArray;
            break;
            case BusinessToClassfityTypeCoupon:
            [self businessToCoupon];
            self.dataAllArray = self.couponArray;
            break;
        default:
            break;
    }
}

#pragma mark ----------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupTableViewCell *businessCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GroupModel *model = self.dataAllArray[indexPath.row];
    businessCell.groupModel = model;
    businessCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return businessCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAllArray.count;;
}

//单元格选中方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    LoveViewController *enjoyVC = [storyBoard instantiateViewControllerWithIdentifier:@"loveDetail"];
    GroupModel *model = self.dataAllArray[indexPath.row];
    enjoyVC.loveDetailID = model.youLoveID;
    [self.navigationController pushViewController:enjoyVC animated:YES];
    
}

#pragma mark -------- lazyLoading 
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 100, kWidth, kHeight - 140) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 140;
    }
    return _tableView;
}

- (NSMutableArray *)allArray{
    if (!_allArray) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}
- (NSMutableArray *)couponArray{
    if (!_couponArray) {
        self.couponArray = [NSMutableArray new];
    }
    return _couponArray;
}
- (NSMutableArray *)dataAllArray{
    if (!_dataAllArray) {
        self.dataAllArray = [NSMutableArray new];
    }
    return _dataAllArray;
}
- (VOSegmentedControl *)VOsegemented{
    if (!_VOsegemented) {
        self.VOsegemented = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"全部商品"}, @{VOSegmentText:@"优惠商品"}]];
        self.VOsegemented.contentStyle = VOContentStyleImageAlone;
        self.VOsegemented.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.VOsegemented.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.VOsegemented.selectedBackgroundColor = self.VOsegemented.backgroundColor;
        self.VOsegemented.allowNoSelection = NO;
        self.VOsegemented.frame = CGRectMake(50, 70, kWidth - 100, 30);
        self.VOsegemented.indicatorThickness = 2;
        self.VOsegemented.selectedSegmentIndex = self.businessToType - 1;
        //返回点击按钮
        [self.VOsegemented setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"hit --> %@", @(index));
        }];
        [self.VOsegemented addTarget:self action:@selector(segementCtrlValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _VOsegemented;
}

#pragma mark ------------- PullingTableViewDelegate
//tableView开始刷新的时候调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.canRefreshing = YES;
    //下拉延生
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}

- (void)segementCtrlValueChange:(VOSegmentedControl *)segement{
    self.businessToType = segement.selectedSegmentIndex + 1;
    //调用网络请求
    [self chooseRequest];
    
}
//下拉时停顿一秒收回
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.canRefreshing = NO;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}
//手指开始拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
    
}

//手指结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
    
}

//下拉加载数据
- (void)businessToAll{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"正在加载……"];
    [httpManger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kBusiness, _pageCount, @(23)] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [ProgressHUD showSuccess:@"加载完成喽"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.canRefreshing) {
                if (self.allArray.count > 0) {
                    [self.allArray removeAllObjects];
                }
           
            }
            for (NSDictionary *dict in acDataArray) {
                GroupModel *model = [[GroupModel alloc] initGroupDictionary:dict];
                [self.allArray addObject:model];
                
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
//优惠商品
- (void)businessToCoupon{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"正在加载……"];
    [httpManger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kBusiness, _pageCount, @(21)] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [ProgressHUD showSuccess:@"加载完成喽"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.canRefreshing) {
                if (self.couponArray.count > 0) {
                    [self.couponArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in acDataArray) {
                GroupModel *model = [[GroupModel alloc] initGroupDictionary:dict];
                [self.couponArray addObject:model];
                
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

- (void)viewWillAppear:(BOOL)animated{
    [self viewDidAppear:YES];
    [ProgressHUD dismiss];
    self.tabBarController.tabBar.hidden = NO;
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
