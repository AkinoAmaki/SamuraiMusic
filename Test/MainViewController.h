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


@interface MainViewController : UIViewController{
    MainView *mainView;
    float animationDuration; //目標物の表示されるアニメーションの時間
    NSArray *tapMusicArray;  //タップする目標物のタイミング・座標を全て格納する
    NSDate *musicStartTime;  //ゲームスタート時点の時刻
    TapGesture *tapGesture;
    PanGesture *panGesture;
    LongPressGesture *longPressGesture;
    
    MBAnimationView *mbAnimation1;
    MBAnimationView *mbAnimation2;
    MBAnimationView *mbAnimation3;
}

- (IBAction)StageStart:(id)sender;

- (void)createTapGestureRecognizers:(UIView *)targetView;
- (void)createPanGestureRecognizers:(UIView *)targetView;
- (void)createLongPressGestureRecognizers:(UIView *)targetView;

@end
