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
#import "LoveViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPSessionManager.h"
#import "CityViewController.h"
@interface GroupViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArray;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //边缘适配
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
    //在scrollView添加多个按钮
    [self configTableViewToHeadView];
    
 
    
}

//网络请求 猜你喜欢
- (void)getRequest{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [httpManager GET:kYouLOve parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            
            for (NSDictionary *dic in acDataArray) {
                GroupModel *model = [[GroupModel alloc] initGroupDictionary:dic];
                [self.listArray addObject:model];
            }
        }else{
            
        }
        [self.tableView tableHeaderView];
        //刷新tableView数据,会执行所有tableView的代理方法
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
    }];
    
}


#pragma mark ------------ ConstomMethod
//选择城市
- (void)selectCityAction:(UIBarButtonItem *)barButton{
    CityViewController *cityVC = [[CityViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:cityVC];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
    
}
- (void)searchAction:(UIBarButtonItem *)bar{
    
}


#pragma mark ------- UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GroupModel *model = self.listArray[indexPath.row];
    groupCell.groupModel = model;
    
    //点击单元格颜色不变
    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return groupCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

#pragma mark ---------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

//分区头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
//自定义分区头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth / 4, 25)];
    if (section == 0) {
        headerImage.image = [UIImage imageNamed:@"todaySpecialHeaderTitleImage"];
        [view addSubview:headerImage];
    }
    return view;
}

//单元格选中方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    LoveViewController *loveVC = [storyBoard instantiateViewControllerWithIdentifier:@"loveDetail"];
    GroupModel *model = self.listArray[indexPath.row];
    loveVC.loveDetailID = model.youLoveID;
    [self.navigationController pushViewController:loveVC animated:YES];
    
}


//自定义方法显示tableview的区头
- (void)configTableViewToHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    self.tableView.tableHeaderView = headView;
    //存放小标题
    NSArray *listArray1 = @[@"美食", @"电影", @"外卖", @"KTV"];
    NSArray *listArray2 = @[@"酒店", @"周边游", @"优惠买单", @"下午茶"];
    //添加按钮
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kWidth / 4 * i + 20, 10, kWidth / 8, kWidth / 8);
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(kWidth / 4 * i + 20, kWidth / 8 + 20, kWidth / 8, 30);
        
        titleLabel.text = listArray1[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = 1+i;
        NSString *imageStr = [NSString stringWithFormat:@"icon_homepage_%02d", i + 1];
        [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:button];
        [headView addSubview:titleLabel];

    }
    //第二行按钮
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kWidth / 4 * i + 20, 50 + kWidth / 8, kWidth / 8, kWidth / 8);
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(kWidth / 4 * i + 20, kWidth / 4 + 50, kWidth / 8 + 30, 30);
        
        titleLabel.text = listArray2[i];
        button.tag = 5+i;
        NSString *imageStr = [NSString stringWithFormat:@"icon_homepage_%02d", i + 5];
        [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:button];
        [headView addSubview:titleLabel];
        
    }
    

    
}

//button点击方法
- (void)buttonTouchAction:(UIButton *)btn{
    ShopSpreeViewController *shopVC = [[ShopSpreeViewController alloc] init];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

//当堆栈再次调用以前的页面时调用这方法
- (void)viewWillAppear:(BOOL)animated{
    [self viewDidAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark ----------- lazyLoading
- (NSMutableArray *)listArray{
    if (!_listArray) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
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
