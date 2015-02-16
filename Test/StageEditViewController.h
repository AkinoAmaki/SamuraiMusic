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
#import "ExceptionArea.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface StageEditViewController : ViewController<UITextFieldDelegate,UIAlertViewDelegate, IconDelegate,NSCoding>{
    StageEditView *stageEditView; //UIView
    AVAudioPlayer *audio;         //再生する音楽
    UIView *allUtilityView;       //全てのアイコン・ツールを載せるビュー
    UIButton *playButton;         //再生ボタン
    UIButton *saveButton;         //セーブボタン
    UIImageView *singleTapImageView;    //シングルタップアイコンのイメージビュー
    UIImageView *panImageView;          //スワイプアイコンのイメージビュー
    UIImageView *longPressImageView;    //ロングプレスアイコンのイメージビュー
    UILabel *currentTimeLabel;          //音楽の現在までの再生時間を表示するラベル
    UILabel *durationLabel;             //音楽の残り時間を表示するラベル
    UISlider *timeSlider;               //音楽のタイムスライダー
    NSTimer *timer;                     //0.1秒ごとにスライダー・ラベル等を更新するためのタイマー
    CGPoint initPoint;                  //アイコン作成に失敗したときに元の座標に戻すため、元の座標を格納しておくための変数
    NSMutableArray *animatingNowIconArray;  //現在アニメーションされているアイコンを格納する配列
    int zenkai;        //音楽再生時は0.1秒前、一時停止時はハンドでタイムスライダーを動かす直前の、音楽の再生時間
    int iconTagNumber; //アイコン毎にユニークなタグ番号
    float singleTapAnimationDuration;   //シングルタップのアニメーション時間
    float panAnimationDuration;         //スワイプのアニメーション時間
    float longPressAnimationDuration;   //ロングプレスのアニメーション時間
    UIAlertView *humenNameAlertView;    //譜面を保存する際に使用するアラートビュー
    UITextField *humenNameTextField;    //譜面を保存する際に使用するテキストフィールド
    NSString *kyokumei;                 //再生する曲の曲名
    NSString *kakutyoushi;              //再生する曲の拡張子
    Icon *tempIcon;
    
    MBAnimationView *mbAnimation1;      //表示するアイコンのアニメーション
    MBAnimationView *mbAnimation2;
    MBAnimationView *mbAnimation3;
}
@property (nonatomic, retain) NSMutableArray *iconArray;              //作成したアイコンを格納する配列
@property (nonatomic, retain) NSMutableArray *exceptionAreaArray;     //例外エリアを格納する配列
@property int stageNumber; //何番目のステージを選んだかを格納する変数。一番目は0。(常に一番最後の番号は新規作成)
@property int mountOfStages; //ステージの総数
@property (nonatomic, retain)NSMutableArray *stages;  //全ての譜面名、曲名、曲の拡張子、譜面本体を収めた配列を格納
@property NSString *musicPath;
@property BOOL newHumen; //新しく作成した譜面か否かを格納する
-(void)setExceptionArea:(CGRect)rect startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime iconTagNumber:(int)tag;

@end
