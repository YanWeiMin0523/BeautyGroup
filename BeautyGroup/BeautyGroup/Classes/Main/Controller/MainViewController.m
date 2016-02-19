//
//  MainViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "RecommendViewController.h"
@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *headButton;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) NSArray *titleArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    [self addHeadButtonToLogin];
    
    //数组
    self.titleArray = [NSArray arrayWithObjects:@"我的订单", @"美团钱包", @"抵用卷", @"每日推荐", nil];
    self.imageArray = [NSArray arrayWithObjects:@"icon_order", @"icon_ele", @"icon_ac", @"list_like_heart", nil];
}


#pragma mark ----------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
        [self.navigationController pushViewController:recommendVC animated:YES];
        
    }else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

#pragma mark ------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndex = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndex];
        
    }
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

//添加tableView头部
- (void)addHeadButtonToLogin{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    headView.backgroundColor = MainColor;
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.headButton];
    [headView addSubview:self.nameLabel];
    
}

//点击上部圆形button的方法，进行登陆/注册
- (void)headAction:(UIButton *)btn{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self viewDidAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark -------- lazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60;
        
    }
    return _tableView;
}

- (UIButton *)headButton{
    if (!_headButton) {
        self.headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headButton.frame = CGRectMake(20, 20, 110, 110);
        self.headButton.layer.cornerRadius = 55;
        self.headButton.clipsToBounds = YES;
        [self.headButton addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headButton
         setImage:[UIImage imageNamed:@"icon_userreview_defaultavatar"] forState:UIControlStateNormal];
    }
    return _headButton;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, kWidth - 200, 80)];
        self.nameLabel.text = @"请点击登陆吧!";
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
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
