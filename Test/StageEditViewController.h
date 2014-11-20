//
//  StageEditViewController.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/16.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "ViewController.h"
#import "StageEditView.h"
#import "UIView+Origin.h"
#import "Icon.h"
#import "MBAnimationView.h"
#import "TapGesture.h"
#import "PanGesture.h"
#import "LongPressGesture.h"
#import <AVFoundation/AVFoundation.h>


@interface StageEditViewController : ViewController{
    StageEditView *stageEditView;
    AVAudioPlayer *audio;
    UIView *allUtilityView;
    UIButton *playButton;
    UIImageView *singleTapImageView;
    UIImageView *panImageView;
    UIImageView *longPressImageView;
    UILabel *currentTimeLabel;
    UILabel *durationLabel;
    UISlider *timeSlider;
    NSTimer *timer;
    CGPoint initPoint;
    NSMutableArray *iconArray;
    NSMutableArray *animatingNowIconArray;
    NSMutableArray *exceptionArea;
    int zenkai;
    int iconTagNumber; //アイコン毎にユニークなタグ番号
    float singleTapAnimationDuration;
    float panAnimationDuration;
    float longPressAnimationDuration;
}

@end
