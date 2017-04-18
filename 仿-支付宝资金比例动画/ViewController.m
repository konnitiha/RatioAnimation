//
//  ViewController.m
//  仿-支付宝资金比例动画
//
//  Created by FuYunLei on 2017/4/18.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import "ViewController.h"
#import "FYLRatioView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    //    FYLRatioView *view = [[FYLRatioView alloc] initWithNumbers:@[@1.11,@2.22,@3.33,@4.44,@5.55] andTitles:@[@"一",@"二二",@"三三三",@"四四四四",@"五五五五五"]];
    FYLRatioView *view = [[FYLRatioView alloc] initWithNumbers:@[@1536,@34567,@1500,@20000] andTitles:@[@"余额",@"余额宝",@"定期",@"基金"]];
    view.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 100);
    [self.view addSubview:view];
}

@end
