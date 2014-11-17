//
//  StageEditViewController.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/16.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "StageEditViewController.h"

@implementation StageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //シングルタップ・スワイプ・ロングプレスの設定元画像を設置する
    singleTapImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture11 0.51.54" ofType:@"png"]]];
    panImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture12 0.51.54" ofType:@"png"]]];
    longPressImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture13 0.51.54" ofType:@"png"]]];
    
    singleTapImageView.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - singleTapImageView.image.size.height - 40, singleTapImageView.image.size.width - 20, singleTapImageView.image.size.height - 20);
    panImageView.frame = CGRectMake(110, [UIScreen mainScreen].bounds.size.height - panImageView.image.size.height - 40, panImageView.image.size.width - 20, panImageView.image.size.height - 20);
    longPressImageView.frame = CGRectMake(210, [UIScreen mainScreen].bounds.size.height - longPressImageView.image.size.height - 40, longPressImageView.image.size.width - 20, longPressImageView.image.size.height - 20);
    
    singleTapImageView.userInteractionEnabled = YES;
    panImageView.userInteractionEnabled = YES;
    longPressImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:singleTapImageView];
    [self.view addSubview:panImageView];
    [self.view addSubview:longPressImageView];

    [self setDragCopyAction:singleTapImageView];
    [self setDragCopyAction:panImageView];
    [self setDragCopyAction:longPressImageView];
    
    
    //用意した音楽を再生
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Won't Go Home Without You Lyrics" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    [audio play];
    audio.volume = 0.2f;
    
    //再生のシークバーを設置
    timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 10)];
    timeSlider.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - 25);
    [self.view addSubview:timeSlider];
    timeSlider.maximumValue = audio.duration;
    [timeSlider addTarget:self action:@selector(timeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                            target:self
                                          selector:@selector(upDateSlider:)
                                          userInfo:nil
                                           repeats:YES];
    [timer fire];
}

- (void)viewDidAppear:(BOOL)animated{
    //現在の再生時刻を表すラベル(currentTimeLabel)と、残りの再生時間を表すラベル(durationLabel)を設定
    currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,[UIScreen mainScreen].bounds.size.height - 30 - 5, 100, 30)];
    durationLabel    = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 5, [UIScreen mainScreen].bounds.size.height - 30 - 5, 100, 30)];
    [self.view addSubview:currentTimeLabel];
    [self.view addSubview:durationLabel];
    
    //ラベルの内容をアップデート
    [self updateLabel];
}

//ラベルの内容をアップデートする
-(void)updateLabel{
    int current = audio.currentTime;//currentTimeはfloatなのでintに直さないと計算できないみたいだった
    int duration = audio.duration;
    int minute = current/60;//現在時間÷６０で「分」の部分。
    int sec = current%60;//現在時間÷６０の剰余算で「秒」の部分。
    int lastMinute = (current-duration)/60;
    //↑残り時間は「現在時間ー曲の長さ」で計算。「曲の長さー現在時間」でもいいけどこの計算方式だと
    //「－」が出力されるのでいい感じ
    int lastSec = abs((current-duration)%60);
    //これも上と同じ。ここはマイナス出したくないので「曲の長さー現在時間」の方がいいんだが折角なので絶対値で出してる。
    
    currentTimeLabel.text=[NSString stringWithFormat:@"%2d:%02d",minute,sec];//上で定義したものをラベルに書く。二桁で。
    durationLabel.text=[NSString stringWithFormat:@"%2d:%02d",lastMinute,lastSec];
    
    [currentTimeLabel sizeToFit];
    [durationLabel sizeToFit];

}

//タイムスライダーの表示をアップデートする
-(void)upDateSlider:(NSTimer*)timer{
    timeSlider.value=audio.currentTime;
    [self updateLabel];
}

//タイムスライダーの値が変更されるたびに呼び出される
-(void)timeSliderChanged:(UISlider*)slider{
    [audio setCurrentTime:timeSlider.value];
    [self updateLabel];
}


//イメージのドラッグ機能(ドラッグ後のコピー機能なし)を追加する
- (void)setDragAction:(UIView *)view{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [view addGestureRecognizer:pan];
}

//イメージのドラッグ機能(ドラッグ後のコピー機能あり)を追加する
- (void)setDragCopyAction:(UIView *)view{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panActionWithCopy:)];
    [view addGestureRecognizer:pan];
}

//単なるドラッグ機能
- (void)panAction : (UIPanGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateBegan){
        sender.view.alpha = 0.4f;
    }
    
    if([sender state] == UIGestureRecognizerStateEnded){
        BOOL isExistInExceptionArea = NO; //スワイプの終点がExceptionAreaに入っていたらYES
        for (int i = 0; i < [exceptionArea count]; i++) {
            CGRect tempRect = [[exceptionArea objectAtIndex:i] CGRectValue];
            if (CGRectIntersectsRect (tempRect, sender.view.frame)) isExistInExceptionArea = YES;
        }
        
        if (isExistInExceptionArea) sender.view.center = initPoint; //スワイプの終点がExceptionAreaに入っていたらスワイプ開始時点にViewを戻す
        sender.view.alpha = 1.0f;
    }
    // ドラッグで移動した距離を取得する
    CGPoint p = [sender translationInView:sender.view];
    
    // 移動した距離だけ、UIImageViewのcenterポジションを移動させる。但し、画面外にははみ出ない。
    CGPoint movedPoint = CGPointMake(sender.view.center.x + p.x, sender.view.center.y + p.y);
    CGPoint movedTopLeft     = CGPointMake(movedPoint.x - (sender.view.bounds.size.width / 2), movedPoint.y - (sender.view.bounds.size.height / 2) );
    CGPoint movedTopRight    = CGPointMake(movedPoint.x + (sender.view.bounds.size.width / 2), movedPoint.y - (sender.view.bounds.size.height / 2) );
    CGPoint movedBottomLeft  = CGPointMake(movedPoint.x - (sender.view.bounds.size.width / 2), movedPoint.y + (sender.view.bounds.size.height / 2) );
    CGPoint movedBottomRight = CGPointMake(movedPoint.x + (sender.view.bounds.size.width / 2), movedPoint.y + (sender.view.bounds.size.height / 2) );
    
    if(movedTopLeft.x >= 0 && movedTopLeft.y >= 0 && movedTopRight.x <= [UIScreen mainScreen].bounds.size.width && movedTopRight.y >= 0 &&movedBottomLeft.x >= 0 && movedBottomLeft.y <= [UIScreen mainScreen].bounds.size.height && movedBottomRight.x  <= [UIScreen mainScreen].bounds.size.width && movedBottomRight.y <= [UIScreen mainScreen].bounds.size.height){
        sender.view.center = movedPoint;
    }
    
    // ドラッグで移動した距離を初期化する
    // これを行わないと、[sender translationInView:]が返す距離は、ドラッグが始まってからの蓄積値となるため、
    // 今回のようなドラッグに合わせてImageを動かしたい場合には、蓄積値をゼロにする
    [sender setTranslation:CGPointZero inView:sender.view];
}


//イメージがドラッグされ、アイコン作成に成功した時、そのコピーを元の位置に作成する
- (void)panActionWithCopy : (UIPanGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateBegan){
        sender.view.alpha = 0.4f;
        initPoint = sender.view.center;
    }
    
    if([sender state] == UIGestureRecognizerStateEnded){
        sender.view.alpha = 1.0f;
        BOOL isExistInExceptionArea = NO; //スワイプの終点がExceptionAreaに入っていたらYES
        for (int i = 0; i < [exceptionArea count]; i++) {
            CGRect tempRect = [[exceptionArea objectAtIndex:i] CGRectValue];
            if (CGRectIntersectsRect (tempRect, sender.view.frame)) isExistInExceptionArea = YES;
        }
        
        if (isExistInExceptionArea){
            sender.view.center = initPoint; //スワイプの終点がExceptionAreaに入っていたらスワイプ開始時点にViewを戻す
        }else{
            //アイコン作成に成功した時、アイコンを指定の位置に置き、そのコピーを元の位置に作成し、アイコンからはコピー能力を消し、代わりにダブルタップしたら消えるようにする。
            if(initPoint.x == 60){
                NSLog(@"copy");
                //シングルタップのアイコンが作成された時
                //新しいコピーを元の位置に作成する
                UIImageView *single = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture11 0.51.54" ofType:@"png"]]];
                single.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - single.image.size.height - 40, single.image.size.width - 20, single.image.size.height - 20);
                single.userInteractionEnabled = YES;
                [self.view addSubview:single];
                
                //新しいコピーにドラッグ能力・コピー能力をもたせる
                [self setDragCopyAction:single];
            }else if (initPoint.x == 160){
                //スワイプのアイコンが作成された時
                //新しいコピーを元の位置に作成する
                UIImageView *pan;
                pan = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture12 0.51.54" ofType:@"png"]]];
                pan.frame = CGRectMake(110, [UIScreen mainScreen].bounds.size.height - pan.image.size.height - 40, pan.image.size.width - 20, pan.image.size.height - 20);
                pan.userInteractionEnabled = YES;
                [self.view addSubview:pan];

                //新しいコピーにドラッグ能力・コピー能力をもたせる
                [self setDragCopyAction:pan];
            }else if (initPoint.x == 260){
                //ロングプレスのアイコンが作成された時
                //新しいコピーを元の位置に作成する
                UIImageView *longPress;
                longPress = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture13 0.51.54" ofType:@"png"]]];
                longPress.frame = CGRectMake(210, [UIScreen mainScreen].bounds.size.height - longPress.image.size.height - 40, longPress.image.size.width - 20, longPress.image.size.height - 20);
                longPress.userInteractionEnabled = YES;
                [self.view addSubview:longPress];
                
                //新しいコピーにドラッグ能力・コピー能力をもたせる
                [self setDragCopyAction:longPress];
            }
            
            //代わりに、単なるドラッグ能力とダブルタップしたら消えるジェスチャを加える。
            [self setDragAction:sender.view]; //単なるドラッグ能力（コピー能力を持たない）
            UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapMethod:)]; //ダブルタップに反応させる
            [doubleTapGesture setNumberOfTapsRequired:2];
            [sender.view addGestureRecognizer:doubleTapGesture];
        }
    }
    // ドラッグで移動した距離を取得する
    CGPoint p = [sender translationInView:sender.view];
    
    // 移動した距離だけ、UIImageViewのcenterポジションを移動させる。但し、画面外にははみ出ない。
    CGPoint movedPoint = CGPointMake(sender.view.center.x + p.x, sender.view.center.y + p.y);
    CGPoint movedTopLeft     = CGPointMake(movedPoint.x - (sender.view.bounds.size.width / 2), movedPoint.y - (sender.view.bounds.size.height / 2) );
    CGPoint movedTopRight    = CGPointMake(movedPoint.x + (sender.view.bounds.size.width / 2), movedPoint.y - (sender.view.bounds.size.height / 2) );
    CGPoint movedBottomLeft  = CGPointMake(movedPoint.x - (sender.view.bounds.size.width / 2), movedPoint.y + (sender.view.bounds.size.height / 2) );
    CGPoint movedBottomRight = CGPointMake(movedPoint.x + (sender.view.bounds.size.width / 2), movedPoint.y + (sender.view.bounds.size.height / 2) );
    
    if(movedTopLeft.x >= 0 && movedTopLeft.y >= 0 && movedTopRight.x <= [UIScreen mainScreen].bounds.size.width && movedTopRight.y >= 0 &&movedBottomLeft.x >= 0 && movedBottomLeft.y <= [UIScreen mainScreen].bounds.size.height && movedBottomRight.x  <= [UIScreen mainScreen].bounds.size.width && movedBottomRight.y <= [UIScreen mainScreen].bounds.size.height){
        sender.view.center = movedPoint;
    }
    
    // ドラッグで移動した距離を初期化する
    // これを行わないと、[sender translationInView:]が返す距離は、ドラッグが始まってからの蓄積値となるため、
    // 今回のようなドラッグに合わせてImageを動かしたい場合には、蓄積値をゼロにする
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)setExceptionArea:(CGRect)rect{
    [exceptionArea addObject:[NSValue valueWithCGRect:rect]];
}

- (void)doubleTapMethod : (UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
}



@end
