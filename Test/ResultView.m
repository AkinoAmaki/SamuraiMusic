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


@end
