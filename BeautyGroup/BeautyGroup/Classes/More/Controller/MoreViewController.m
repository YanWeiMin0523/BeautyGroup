//
//  MoreViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "MoreViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"
#import "ShareView.h"
@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIImageView *headImage;
@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) NSArray *imageArray;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //边缘适配
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    
    //tableView中的数据
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"清理缓存", @"用户反馈", @"检查更新", @"客户好评", @"邀请好友使用美团", nil];
    self.imageArray = @[@"btn_order_wait", @"btn_recommend", @"ac_details_img", @"ac_details_recommed_img", @"btn_share_selected"];
    //图片
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    self.headImage.image = [UIImage imageNamed:@"bg_login"];
    [self.view addSubview:self.headImage];
    
}

//每当页面将要出现的时候计算图片缓存
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清理缓存(%.02fM)", (float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark --------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            //清除缓存的图片
            [self clearImage];
            break;
        case 1:
            //用户反馈
            [self userEmail];
            break;
        case 2:
            //检测版本
        {
            [ProgressHUD show:@"正在检测"];
            [self performSelector:@selector(checkAPPVersion) withObject:nil afterDelay:2.0];
        }
            break;
        case 3:
        {  //评分
            NSString *str = [NSString stringWithFormat:
                             
                             @"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 4:
            //分享好友
            [self shareToFriends];
            break;
            
        default:
            break;
    }
    
}

#pragma mark ------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndex = @"cellIndex";
    UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (moreCell == nil) {
        moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndex];
    }
    moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    moreCell.textLabel.text = self.titleArray[indexPath.row];
    moreCell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    moreCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return moreCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

#pragma mark ---------------- Custom Method
- (void)clearImage{
    [ProgressHUD showSuccess:@"已为你清理"];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    //清理缓存
    [imageCache clearDisk];
    [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)userEmail{
    Class class = (NSClassFromString(@"MFMailComposeViewController"));
    if (class != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
            mailVC.mailComposeDelegate = self;
            //设置主题
            [mailVC setSubject:@"美团一次，美一次"];
            //设置收件人
            NSArray *receiveArray = [NSArray arrayWithObjects:@"1379556026@qq.com", nil];
            [mailVC setToRecipients:receiveArray];
            
            //设置发送内容
            NSString *emailStr = @"Please leave your valuable opinions!";
            [mailVC setMessageBody:emailStr isHTML:NO];
            
            //推出视图
            [self presentViewController:mailVC animated:YES completion:nil];
            
        }else{
            YWMLog(@"未配置邮箱账号");
        }
    }else{
        YWMLog(@"当前设备不支持");
    }
}
- (void)shareToFriends{
    ShareView *shareView = [[ShareView alloc] init];
    [self.view addSubview:shareView];
}

//发送邮件时调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            YWMLog(@"发送取消");
            break;
        case MFMailComposeResultFailed:
            YWMLog(@"发送邮件");
            break;
        case MFMailComposeResultSaved:
            YWMLog(@"保存邮件");
            break;
        case MFMailComposeResultSent:
            YWMLog(@"发送邮件失败或尝试保存");
            break;
            
        default:
            break;
    }
}

//版本检测
- (void)checkAPPVersion{
    [ProgressHUD showSuccess:@"当前应用为最新版本"];
}

#pragma mark ----------- lazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, kWidth, kHeight - 120) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60;
    }
    return _tableView;
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
