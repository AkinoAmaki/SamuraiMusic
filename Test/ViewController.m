//
//  ViewController.m
//  Test
//
//  Created by 秋乃雨弓 on 2014/11/14.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"ViewController");
}

- (void)backScreenTest{
    UIImageView *leftMask  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, [UIScreen mainScreen].bounds.size.height)];
    UIImageView *rightMask = [[UIImageView alloc] initWithFrame:CGRectMake(220, 0, [UIScreen mainScreen].bounds.size.width - 220, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:leftMask];
    [self.view addSubview:rightMask];
    leftMask.layer.masksToBounds = YES;
    rightMask.layer.masksToBounds = YES;
    
    UIImageView *left  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallLeft"]];
    UIImageView *right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallRight"]];
    [leftMask addSubview:left];
    [rightMask addSubview:right];
    left.frame = CGRectMake(600 - left.bounds.size.width, -200, left.bounds.size.width, left.bounds.size.height);
    right.frame = CGRectMake(-500, -200, right.bounds.size.width, right.bounds.size.height);
    
    //    UIImageView *blackBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blackBack"]];
    //    blackBack.frame = CGRectMake(100, 0, 120, [UIScreen mainScreen].bounds.size.height);
    //    [self.view addSubview:blackBack];
    
    [UIView animateWithDuration:5.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                     animations:^{
                         // アニメーションをする処理
                         left.frame = CGRectMake(left.bounds.size.width * -1, 45, left.bounds.size.width, left.bounds.size.height);
                         right.frame = CGRectMake(100, 45, right.bounds.size.width, right.bounds.size.height);
                         // アニメーションをする処理
                         left.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         right.transform = CGAffineTransformMakeScale(1.3, 1.3);
                     } completion:^(BOOL finished) {
                         // アニメーションが終わった後実行する処理
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
