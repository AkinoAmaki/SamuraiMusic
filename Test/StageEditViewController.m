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
    
    //シークバー・再生ボタン等のツールビューを取りまとめるビューの初期化
    allUtilityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    allUtilityView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:allUtilityView];
    
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
    
    [allUtilityView addSubview:singleTapImageView];
    [allUtilityView addSubview:panImageView];
    [allUtilityView addSubview:longPressImageView];

    [self setDragCopyAction:singleTapImageView];
    [self setDragCopyAction:panImageView];
    [self setDragCopyAction:longPressImageView];
    
    
    //用意した音楽を再生
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Won't Go Home Without You Lyrics" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    [audio prepareToPlay];
    audio.volume = 0.2f;
    
    //再生・一時停止ボタンを設置
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    playButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - 45);
    [allUtilityView addSubview:playButton];
    [playButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start" ofType:@"png"]] forState:UIControlStateNormal];  // 画像をセットする
    // ボタンが押された時にhogeメソッドを呼び出す
    [playButton addTarget:self
                   action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    
    //再生のシークバーを設置
    timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 10)];
    timeSlider.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - 25);
    [allUtilityView addSubview:timeSlider];
    timeSlider.maximumValue = audio.duration;
    [timeSlider addTarget:self action:@selector(timeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [timeSlider addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [timeSlider addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                            target:self
                                          selector:@selector(upDateSlider:)
                                          userInfo:nil
                                           repeats:YES];
    [timer fire];
    
    //設置するアイコンの設定を初期化
    iconArray = [[NSMutableArray alloc] init];
    
    //タグナンバーを初期化
    iconTagNumber = 1;
    
    //タイムスライダーの値を変更する前の、音楽のcurrentTime
    zenkai = 0;
    
    //アニメーション中のアイコンを管理する配列
    animatingNowIconArray = [[NSMutableArray alloc] init];

}

- (void)touchUpInside{
    NSLog(@"スライダーの編集が完了しました");
}

- (void)touchUpOutside{
    NSLog(@"スライダーの編集が完了しました");
}

- (void)viewDidAppear:(BOOL)animated{
    //現在の再生時刻を表すラベル(currentTimeLabel)と、残りの再生時間を表すラベル(durationLabel)を設定
    currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,[UIScreen mainScreen].bounds.size.height - 30 - 5, 100, 30)];
    durationLabel    = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 5, [UIScreen mainScreen].bounds.size.height - 30 - 5, 100, 30)];
    currentTimeLabel.textColor = [UIColor whiteColor];
    durationLabel.textColor = [UIColor whiteColor];
    [allUtilityView addSubview:currentTimeLabel];
    [allUtilityView addSubview:durationLabel];
    
    //ラベルの内容をアップデート
    [self updateLabel];
}

//曲の再生・一時停止を行う
- (IBAction)playAudio:(id)sender{
    if(!audio.isPlaying){
        //再生していないとき
        [audio play];
        [playButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stop" ofType:@"png"]] forState:UIControlStateNormal];  // 一時停止の画像をセットする
    }else{
        [audio pause];
        audio.currentTime = timeSlider.value;
        [playButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start" ofType:@"png"]] forState:UIControlStateNormal];  // 画像をセットする
    }
    
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
    if([audio isPlaying]){
        timeSlider.value = audio.currentTime;
        zenkai = audio.currentTime;
        [self updateLabel];
        [self refleshIcon:YES];
    }
}

//ハンドでタイムスライダーの値を変更するたびに呼び出される。edit画面で貼り付けたアイコンを全て削除する。また、シークした先にアニメーションのビューがあればそれを表示させる
-(void)timeSliderChanged:(UISlider*)slider{
    //音楽の再生位置をシークタイムに合わせる
    [audio setCurrentTime:timeSlider.value];
    
    //再生時間・残り時間のラベルを更新
    [self updateLabel];
    [self refleshIcon:NO];
    zenkai = audio.currentTime;
}

- (void)refleshIcon:(BOOL)isPlaying{
    //一旦全てのアイコンを削除
    for (UIView *view in allUtilityView.subviews) {
        //タグが付いているということは、アイコン作成に成功しているということ。その他のツールビュー（再生ボタンやシークバー等）はタグが一切ついていないため、消えることはない。
        if (view.tag >= 1) {
            [view removeFromSuperview];
        }
    }
    if((int)audio.currentTime < zenkai){
        NSLog(@"xを更新");
        [animatingNowIconArray removeAllObjects];
    }
    
    if (isPlaying) {
        //再生中ならアニメーションさせる
        for (int i = 0; i < [iconArray count]; i++) {
            Icon *icon = [iconArray objectAtIndex:i];
            if (![icon isEqual:[NSNull null]] && icon.startTime <= audio.currentTime && icon.endTime >= audio.currentTime && [animatingNowIconArray indexOfObject:icon] == NSNotFound) {
                MBAnimationView *mb = [[MBAnimationView alloc] init];
                [animatingNowIconArray addObject:icon];
                switch (icon.iconType) {
                    case 1:
                        //シングルタップの場合
                    {
                        [mb setAnimationImage:@"pipo-btleffect007.png" :120 :120 :14];
                        mb.animationDuration = 1;
                    }
                        break;
                    case 2:
                        //スワイプの場合
                    {
                        [mb setAnimationImage:@"PanGesture.png" :120 :120 :14];
                        mb.animationDuration = 0.85;
                    }
                        
                        break;
                    case 3:
                        //ロングプレスの場合
                    {
                        [mb setAnimationImage:@"LongPressGesture.png" :120 :120 :14];
                        mb.animationDuration = 1;
                    }
                        break;
                    default:
                        break;
                }
                
                mb.frame = CGRectMake(icon.centerPoint.x - 60, icon.centerPoint.y - 60, 120, 120);
                [self.view addSubview:mb];
                [mb startAnimating];
            }
        }
    }else{
        //一時停止しているときは、アニメーションのビューは画像は表示させるが、実際にアニメーションはさせない
        for (int i = 0; i < [iconArray count]; i++) {
            Icon *icon = [iconArray objectAtIndex:i];
            if (![icon isEqual:[NSNull null]] && icon.startTime <= audio.currentTime && icon.endTime >= audio.currentTime) {
                switch (icon.iconType) {
                    case 1:
                        //シングルタップの場合
                    {
                        UIImageView *single = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture11 0.51.54" ofType:@"png"]]];
                        single.frame = CGRectMake(0, 0, single.image.size.width - 20, single.image.size.height - 20);
                        single.center = icon.centerPoint;
                        single.userInteractionEnabled = YES;
                        single.tag = icon.iconTagNumber;
                        [allUtilityView addSubview:single];
                        //単なるドラッグ能力とダブルタップしたら消えるジェスチャを加える。
                        [self setDragAction:single]; //単なるドラッグ能力（コピー能力を持たない）
                        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapMethod:)]; //ダブルタップに反応させる
                        [doubleTapGesture setNumberOfTapsRequired:2];
                        [single addGestureRecognizer:doubleTapGesture];
                    }
                        break;
                    case 2:
                        //スワイプの場合
                    {
                        UIImageView *pan;
                        pan = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture12 0.51.54" ofType:@"png"]]];
                        pan.frame = CGRectMake(110, [UIScreen mainScreen].bounds.size.height - pan.image.size.height - 40, pan.image.size.width - 20, pan.image.size.height - 20);
                        pan.center = icon.centerPoint;
                        pan.userInteractionEnabled = YES;
                        pan.tag = icon.iconTagNumber;
                        [allUtilityView addSubview:pan];
                        //ドラッグ能力とダブルタップしたら消えるジェスチャを加える。
                        [self setDragAction:pan]; //単なるドラッグ能力（コピー能力を持たない）
                        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapMethod:)]; //ダブルタップに反応させる
                        [doubleTapGesture setNumberOfTapsRequired:2];
                        [pan addGestureRecognizer:doubleTapGesture];
                        
                    }
                        
                        break;
                    case 3:
                        //ロングプレスの場合
                    {
                        UIImageView *longPress;
                        longPress = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture13 0.51.54" ofType:@"png"]]];
                        longPress.frame = CGRectMake(210, [UIScreen mainScreen].bounds.size.height - longPress.image.size.height - 40, longPress.image.size.width - 20, longPress.image.size.height - 20);
                        longPress.center = icon.centerPoint;
                        longPress.userInteractionEnabled = YES;
                        longPress.tag = icon.iconTagNumber;
                        [allUtilityView addSubview:longPress];
                        //ドラッグ能力とダブルタップしたら消えるジェスチャを加える。
                        [self setDragAction:longPress]; //単なるドラッグ能力（コピー能力を持たない）
                        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapMethod:)]; //ダブルタップに反応させる
                        [doubleTapGesture setNumberOfTapsRequired:2];
                        [longPress addGestureRecognizer:doubleTapGesture];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
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

    
    if([sender state] == UIGestureRecognizerStateEnded){
        BOOL isExistInExceptionArea = NO; //スワイプの終点がExceptionAreaに入っていたらYES
        for (int i = 0; i < [exceptionArea count]; i++) {
            CGRect tempRect = [[exceptionArea objectAtIndex:i] CGRectValue];
            if (CGRectIntersectsRect (tempRect, sender.view.frame)) isExistInExceptionArea = YES;
        }
        
        if (isExistInExceptionArea){
            //スワイプの終点がExceptionAreaに入っていたらスワイプ開始時点にViewを戻す
            sender.view.center = initPoint;
        }else{
            //無事スワイプが完了した場合は、iconArrayで保管されているアイコンのcenter位置を更新する
            for (int i = 0; i < [iconArray count]; i++) {
                Icon *icon = [iconArray objectAtIndex:i];
                if(![icon isEqual:[NSNull null]] && icon.iconTagNumber == sender.view.tag){
                    icon.centerPoint = sender.view.center;
                    [iconArray replaceObjectAtIndex:i withObject:icon];
                }
            }
        }
        sender.view.alpha = 1.0f;
    }
}


//イメージがドラッグされ、アイコン作成に成功した時の挙動を定義する（アイコンのコピーを元の位置に作成する等）
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
            
            //アイコンにタグナンバーを与える
            sender.view.tag = iconTagNumber++;
            
            //まず、作成に成功したアイコンの所属をallUtilityView(作成用の元アイコン)からallIconView(作成に成功したアイコン)に変更する。
            if(initPoint.x == 60){
                //シングルタップのアイコンが作成された時
                //新しいコピーを元の位置に作成する
                UIImageView *single = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture11 0.51.54" ofType:@"png"]]];
                single.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - single.image.size.height - 40, single.image.size.width - 20, single.image.size.height - 20);
                single.userInteractionEnabled = YES;
                [allUtilityView addSubview:single];
                
                //新しいコピーにドラッグ能力・コピー能力をもたせる
                [self setDragCopyAction:single];
                
                //作成に成功したアイコンをiconArrayに格納する
                Icon *i1 = [[Icon alloc] initWithData:sender.view.center iconType:1 startTime:audio.currentTime endTime:(audio.currentTime + singleTapGestureDuration) iconTagNumber:sender.view.tag];
                [iconArray addObject:i1];
            }else if (initPoint.x == 160){
                //スワイプのアイコンが作成された時
                //新しいコピーを元の位置に作成する
                UIImageView *pan;
                pan = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture12 0.51.54" ofType:@"png"]]];
                pan.frame = CGRectMake(110, [UIScreen mainScreen].bounds.size.height - pan.image.size.height - 40, pan.image.size.width - 20, pan.image.size.height - 20);
                pan.userInteractionEnabled = YES;
                [allUtilityView addSubview:pan];

                //新しいコピーにドラッグ能力・コピー能力をもたせる
                [self setDragCopyAction:pan];
                
                //作成に成功したアイコンをiconArrayに格納する
                Icon *i2 = [[Icon alloc] initWithData:sender.view.center iconType:2 startTime:audio.currentTime endTime:(audio.currentTime + panGestureDuration) iconTagNumber:sender.view.tag];
                [iconArray addObject:i2];
            }else if (initPoint.x == 260){
                //ロングプレスのアイコンが作成された時
                //新しいコピーを元の位置に作成する
                UIImageView *longPress;
                longPress = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LongPressGesture13 0.51.54" ofType:@"png"]]];
                longPress.frame = CGRectMake(210, [UIScreen mainScreen].bounds.size.height - longPress.image.size.height - 40, longPress.image.size.width - 20, longPress.image.size.height - 20);
                longPress.userInteractionEnabled = YES;
                [allUtilityView addSubview:longPress];
                
                //新しいコピーにドラッグ能力・コピー能力をもたせる
                [self setDragCopyAction:longPress];
                
                //作成に成功したアイコンをiconArrayに格納する
                Icon *i3 = [[Icon alloc] initWithData:sender.view.center iconType:3 startTime:audio.currentTime endTime:(audio.currentTime + singleTapGestureDuration) iconTagNumber:sender.view.tag];
                [iconArray addObject:i3];
            }
            
            //代わりに、単なるドラッグ能力とダブルタップしたら消えるジェスチャを加える。
            [self setDragAction:sender.view]; //単なるドラッグ能力（コピー能力を持たない）
            UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapMethod:)]; //ダブルタップに反応させる
            [doubleTapGesture setNumberOfTapsRequired:2];
            [sender.view addGestureRecognizer:doubleTapGesture];
            NSLog(@"%@",iconArray);

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
    //ビューを消去
    [sender.view removeFromSuperview];
    
    //iconArrayに登録されているアイコンも消去(removeすると配列内のビューの位置番号とtagの番号がずれてしまうので、代わりにnullを詰める)
    [iconArray replaceObjectAtIndex:sender.view.tag - 1 withObject:[NSNull null]];
}



@end
