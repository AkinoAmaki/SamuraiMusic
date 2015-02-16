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

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:syokiStages forKey:@"stageArray"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    singleTapGestureDuration = 1;
    panGestureDuration = 1;
    longPressGestureDuration = 1.4;
    
    //TODO: デバッグ終わり次第元に戻すGameCenterのログイン確認
//    [self authenticateLocalPlayer];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    //インタースティシャル広告のデリゲートの設定
    [NADInterstitial sharedInstance].delegate = self;
    
//    [self backScreenTest];
}

- (void)backScreenTest{
    dim = [[Create3DDimension alloc] init];
    [dim createGround:self.view groundImage:[UIImage imageNamed:@"Ground"] rightWallImage:[UIImage imageNamed:@"left"] leftWallImage:[UIImage imageNamed:@"right"] roadHeight:self.view.center.y + 150 roadRadian:0.35 * M_PI wallRadian:0.33 * M_PI moveSpeed:60 okuyuki:200];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * GameCenterにログインしているか確認処理
 * ログインしていなければログイン画面を表示
 */
- (void)authenticateLocalPlayer
{
    //gamecenterのプレイヤーを取得
    
    GKLocalPlayer* player = [GKLocalPlayer localPlayer];
    player.authenticateHandler = ^(UIViewController* ui, NSError* error )
    {
        if( nil != ui )
        {
            [self presentViewController:ui animated:YES completion:nil];
        }
        
    };
}

- (void) didFinishLoadInterstitialAdWithStatus:(NADInterstitialStatusCode)status
{
    switch ( status )
    {
        case SUCCESS:
            NSLog(@"広告のロードに成功しました。");
            //TODO: デバッグ終わり次第元に戻す　[[NADInterstitial sharedInstance] showAd];
            break;
        case INVALID_RESPONSE_TYPE:
            NSLog(@"不正な広告タイプです。");
            break;
        case FAILED_AD_REQUEST:
            NSLog(@"抽選リクエストに失敗しました。");
            break;
        case FAILED_AD_DOWNLOAD:
            NSLog(@"広告のロードに失敗しました。");
            break;
    }
}
- (void) didClickWithType:(NADInterstitialClickType)type
{
    switch ( type )
    {
        case DOWNLOAD:
            NSLog(@"ダウンロードボタンがクリックされました。");
            break;
        case CLOSE:
            NSLog(@"閉じるボタンあるいは広告範囲外の領域がクリックされました。");
            break;
    }
}

@end
