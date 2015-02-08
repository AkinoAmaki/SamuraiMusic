//
//  ResultView.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/12/26.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "ResultView.h"

@implementation ResultView
@synthesize score;
@synthesize maxScore;
@synthesize perfectNumber;
@synthesize greatNumber;
@synthesize goodNumber;
@synthesize badNumber;

- (id)initWithData:(int)s maxScore:(int)m perfectNum:(int)p greatNum:(int)gr goodNum:(int)go missNum:(int)b{
    self = [super init];
    if (self) {
        self.score = s;
        self.maxScore = m;
        self.perfectNumber = p;
        self.greatNumber = gr;
        self.goodNumber = go;
        self.badNumber = b;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    hantei = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 400, 400)];
    hantei.center = CGPointMake(100, 100);
    [self.view addSubview:hantei];
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 90, 100, 50)];
    [self.view addSubview:scoreLabel];
    
    pggb = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 200, 240)];
    perfect = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * -2,   0, 60, 60)];
    great   = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * -2,  60, 60, 60)];
    good    = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * -2, 120, 60, 60)];
    bad     = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * -2, 180, 60, 60)];
    perfect.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"kari" ofType:@"png"]];
    great.image   = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"kari" ofType:@"png"]];
    good.image    = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"kari" ofType:@"png"]];
    bad.image     = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"kari" ofType:@"png"]];
    [pggb addSubview:perfect];
    [pggb addSubview:  great];
    [pggb addSubview:   good];
    [pggb addSubview:    bad];
    perfectNum = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * -2 + 100,   0, 60, 60)];
    greatNum   = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * -2 + 100,  60, 60, 60)];
    goodNum    = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * -2 + 100, 120, 60, 60)];
    badNum     = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * -2 + 100, 180, 60, 60)];
    perfectNum.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    greatNum.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    goodNum.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    badNum.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    perfectNum.text = [NSString stringWithFormat:@"%03d",perfectNumber];
    greatNum.text   = [NSString stringWithFormat:@"%03d",  greatNumber];
    goodNum.text    = [NSString stringWithFormat:@"%03d",   goodNumber];
    badNum.text     = [NSString stringWithFormat:@"%03d",    badNumber];
    [pggb addSubview:perfectNum];
    [pggb addSubview:  greatNum];
    [pggb addSubview:   goodNum];
    [pggb addSubview:    badNum];
    [self.view addSubview:pggb];
    [self levelHantei];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //アイコン型広告の実装
    // NADIconViewクラスの生成
    iconView1 = [[NADIconView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 255, 75, 75)];
    iconView2 = [[NADIconView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 180, 75, 75)];
    iconView3 = [[NADIconView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 105 , 75, 75)];
    iconView4 = [[NADIconView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 75, [UIScreen mainScreen].bounds.size.height - 255, 75, 75)];
    iconView5 = [[NADIconView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 75, [UIScreen mainScreen].bounds.size.height - 180, 75, 75)];
    iconView6 = [[NADIconView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 75, [UIScreen mainScreen].bounds.size.height - 105, 75, 75)];
    // NADIconViewの配置
    [self.view addSubview:iconView1];
    [self.view addSubview:iconView2];
    [self.view addSubview:iconView3];
    [self.view addSubview:iconView4];
    [self.view addSubview:iconView5];
    [self.view addSubview:iconView6];
    // NADIconLoaderクラスの生成
    iconLoader = [[NADIconLoader alloc] init];
    // ログ出力の指定
    [iconLoader setIsOutputLog:YES];
    // NADIconLoaderへNADIconViewを追加
    [iconLoader addIconView:iconView1];
    [iconLoader addIconView:iconView2];
    [iconLoader addIconView:iconView3];
    [iconLoader addIconView:iconView4];
    [iconLoader addIconView:iconView5];
    [iconLoader addIconView:iconView6];
    // APIキーとSPOTIDを設定
    [iconLoader setNendID:@"2349edefe7c2742dfb9f434de23bc3c7ca55ad22"
                   spotID:@"101281"];
    // デリゲートオブジェクトの設定
    [iconLoader setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // アニメーションをする処理
                         //タッチしたアイコンのタッチ精度：左から右に順に飛んでくる
                         perfect.frame = CGRectMake(0,   0, 60, 60);
                         great.frame   = CGRectMake(0,  60, 60, 60);
                         good.frame    = CGRectMake(0, 120, 60, 60);
                         bad.frame     = CGRectMake(0, 180, 60, 60);
                         
                         perfectNum.frame = CGRectMake(100,   0, 60, 60);
                         greatNum.frame   = CGRectMake(100,  60, 60, 60);
                         goodNum.frame    = CGRectMake(100, 120, 60, 60);
                         badNum.frame     = CGRectMake(100, 180, 60, 60);
                     } completion:^(BOOL finished) {
                         // アニメーションが終わった後実行する処理
                         //点数スコア：ランダムから確定
                         [UILabel randomInt:scoreLabel ketasuu:7 keizokuJikan:1.2 lastScore:score];
                         [UIView animateWithDuration:0.4f
                                               delay:1.2f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              // アニメーションをする処理
                                              hantei.alpha = 1.0f;
                                              hantei.transform = CGAffineTransformMakeScale(0.25, 0.25);
                                          } completion:^(BOOL finished) {
                                              // アニメーションが終わった後実行する処理
                                              NSLog(@"Animation End.");
                                              
                                              //「曲選択画面に戻る」ボタンを設置
                                              AAButton *returnToStageSelectButton = [[AAButton alloc] initWithImageAndText:nil imagePath:nil textString:@"曲選択画面に戻る" tag:1 CGRect:CGRectMake(50, 100, 100, 50)];
                                              [returnToStageSelectButton sizeToFit];
                                              returnToStageSelectButton.titleLabel.textColor = [UIColor blackColor];
                                              [self.view addSubview:returnToStageSelectButton];
                                              [returnToStageSelectButton addTarget:self action:@selector(returnToStageSelect:)
                                                     forControlEvents:UIControlEventTouchUpInside];
                                              
                                              
                                              //「メイン画面に戻る」ボタンを設置
                                              AAButton *returnToMainViewButton = [[AAButton alloc] initWithImageAndText:nil imagePath:nil textString:@"メイン画面に戻る" tag:1 CGRect:CGRectMake(50, 150, 100, 50)];
                                              [returnToMainViewButton sizeToFit];
                                              returnToMainViewButton.titleLabel.textColor = [UIColor blackColor];
                                              [self.view addSubview:returnToMainViewButton];
                                              [returnToMainViewButton addTarget:self action:@selector(returnToMainView:)
                                                     forControlEvents:UIControlEventTouchUpInside];
                                              
                                              //「メイン画面に戻る」ボタンを設置
                                              AAButton *leaderBoard = [[AAButton alloc] initWithImageAndText:nil imagePath:nil textString:@"スコアボードを確認する" tag:1 CGRect:CGRectMake(50, 200, 100, 50)];
                                              [leaderBoard sizeToFit];
                                              leaderBoard.titleLabel.textColor = [UIColor blackColor];
                                              [self.view addSubview:leaderBoard];
                                              [leaderBoard addTarget:self action:@selector(showRanking)
                                                               forControlEvents:UIControlEventTouchUpInside];
                                              
                                              // 広告のロード
                                              [iconLoader load];
                                          }];

                     }];
    
    
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore* gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:@"Akino.Test.RealWorld0001"];
        gkScore.value = self.score;
        [GKScore reportScores:@[gkScore] withCompletionHandler:^(NSError *error) {
            if (error) {
                // エラーの場合
                NSLog(@"スコアが送信できませんでした。");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"送信失敗" message:@"スコアが送信できませんでした。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
                [alert show];
            }else{
                NSLog(@"スコア送信完了");
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    //画面が隠れたら、アイコン型広告の定期ロードを中断
    [iconLoader pause];
}

- (void)viewWillAppear:(BOOL)animated{
    //画面が表示されたら、アイコン型広告の定期ロードを再開
    [iconLoader resume];
}

- (void)returnToStageSelect:(id)sender{
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
    // 通知する
    [[NSNotificationCenter defaultCenter] postNotificationName:@"returnToStageSelect"
                                                        object:self
                                                      userInfo:nil];
}

- (void)returnToMainView:(id)sender{
    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)levelHantei{
    float f = (float)self.score / (float)self.maxScore;
    if(f >= 0.99){
        hantei.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"levelSSS" ofType:@"png"]];
    }else if (f >= 0.95){
        hantei.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"levelSS" ofType:@"png"]];
    }else if (f >= 0.90){
        hantei.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"levelS" ofType:@"png"]];
    }else if (f >= 0.85){
        hantei.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"levelA" ofType:@"png"]];
    }else if (f >= 0.80){
        hantei.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"levelB" ofType:@"png"]];
    }else if (f >= 0.70){
        hantei.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"levelC" ofType:@"png"]];
    }else{
        hantei.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"levelD" ofType:@"png"]];
    }
    
    hantei.alpha = 0.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * ランキングボタンタップ時の処理
 * リーダーボードを表示
 */
- (void)showRanking{
    GKGameCenterViewController *gcView = [GKGameCenterViewController new];
    if (gcView != nil)
    {
        gcView.gameCenterDelegate = self;
        gcView.viewState = GKGameCenterViewControllerStateLeaderboards;
        [self presentViewController:gcView animated:YES completion:nil];
    }
}

/**
 * リーダーボードで完了タップ時の処理
 * 前の画面に戻る
 */
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//アイコン型広告がロード完了した際に呼ばれるメソッド
-(void)nadIconLoaderDidFinishLoad:(NADIconLoader *)iconLoader{
    NSLog(@"アイコン型広告のロードが完了しました");
}

//アイコン型広告がクリックされた際に呼ばれるメソッド
-(void)nadIconLoaderDidClickAd:(NADIconLoader *)iconLoader
                   nadIconView:(NADIconView *)nadIconView{
    NSLog(@"アイコン型広告がクリックされました");
}

//アイコン型広告が受信できた際に呼ばれるメソッド
-(void)nadIconLoaderDidReceiveAd:(NADIconLoader *)iconLoader
                     nadIconView:(NADIconView *)nadIconView{
    NSLog(@"アイコン型広告を受信しました");
}

//広告受信時にエラーが出た場合の対応
-(void)nadIconLoaderDidFailToReceiveAd:(NADIconLoader *)nadIconLoader
                           nadIconView:(NADIconView *)nadIconView
{
    NSLog(@"広告受信時にエラーが発生しました。");
    // エラーごとに分岐する
    NSError* error = nadIconLoader.error;
    NSString* domain = error.domain;
    int errorCode = error.code;
    // isOutputLog = NOでも、domain を利用してアプリ側で任意出力が可能
    NSLog(@"log %d", nadIconLoader.isOutputLog);
    NSLog(@"%@",[NSString stringWithFormat: @"code=%d, message=%@",
                 errorCode, domain]);
}

@end
