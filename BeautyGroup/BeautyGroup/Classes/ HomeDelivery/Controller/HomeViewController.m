//
//  HomeViewController.m
//  BeautyGroup
//
//  Created by scjy on 16/2/2.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addButtonToView];
    
}


- (void)addButtonToView{
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, kWidth / 4 * i + 80, kWidth / 2 - 5, kHeight / 8);
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(addButtonToImage:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1 + i;
        [self.view addSubview:button];
    }
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5 + kWidth / 2, kWidth / 4 * i + 80, kWidth / 2 - 10, kHeight / 8);
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(BusinessButtonToImage:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
        [self.view addSubview:button];
    }
    
}

//button点击方法
- (void)addButtonToImage:(UIButton *)btn{
    
    
    
    
}

- (void)BusinessButtonToImage:(UIButton *)btn{
    
    
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
