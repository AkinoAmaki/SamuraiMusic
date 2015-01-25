//
//  MainViewController.h
//  Test
//
//  Created by 秋乃雨弓 on 2014/11/15.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "ViewController.h"
#import "MainView.h"
#import "TapGesture.h"
#import "PanGesture.h"
#import "LongPressGesture.h"
#import "MBAnimationView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "DamageValueLabel.h"
#import "ResultView.h"


typedef enum {
    Perfect,
    Great,
    Good,
    Miss
} KekkaType;


@interface MainViewController : UIViewController{
    AppDelegate *app;
    MainView *mainView;
    float animationDuration; //目標物の表示されるアニメーションの時間
    NSArray *tapMusicArray;  //タップする目標物のタイミング・座標を全て格納する
    NSDate *musicStartTime;  //ゲームスタート時点の時刻
    AVAudioPlayer *audio;    //再生する曲
    TapGesture *tapGesture;
    PanGesture *panGesture;
    LongPressGesture *longPressGesture;
    
    MBAnimationView *mbAnimation1;
    MBAnimationView *mbAnimation2;
    MBAnimationView *mbAnimation3;
    
    int score; //スコアを格納する
    UILabel *scoreLabel; //スコアのラベル
    int combo; //コンボ回数を格納する
    
    int perfectNum; //Perfectを決めた回数を格納
    int greatNum;   //Greatを決めた回数を格納
    int goodNum;    //Goodを決めた回数を格納
    int missNum;    //Missを決めた回数を格納
    
    float perfectKeisuu; //タップタイミングがPerfectのときにかける係数
    float greatKeisuu; //タップタイミングがGreatのときにかける係数
    float goodKeisuu; //タップタイミングがGoodのときにかける係数
}

@property int stageNumber; //何番目のステージを選んだかを格納する変数。一番目は0。
@property (nonatomic, retain)NSMutableArray *stages;  //全ての譜面名、曲名、曲の拡張子、譜面本体を収めた配列を格納

- (void)createTapGestureRecognizers:(UIView *)targetView;
- (void)createPanGestureRecognizers:(UIView *)targetView;
- (void)createLongPressGestureRecognizers:(UIView *)targetView;

@end
