//
//  StageEditViewController.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/16.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "StageEditViewController.h"

@implementation StageEditViewController
@synthesize stages;
@synthesize stageNumber;
@synthesize iconArray;
@synthesize musicPath;
@synthesize newHumen;
@synthesize exceptionAreaArray;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Icon *icon = [[Icon alloc] init];
    icon.delegate = self;
    
    // ラベルを設定
    CGRect rect = CGRectMake(0, 0, 320, 50);
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.center = CGPointMake(160, 160);
    label.font = [UIFont fontWithName:@"Arial" size:48];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    // 背景色を設定
    self.view.backgroundColor = [UIColor whiteColor];

    
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
    
    kyokumei = [[stages objectAtIndex:stageNumber] objectAtIndex:1];
    kakutyoushi =  [[stages objectAtIndex:stageNumber] objectAtIndex:2];
    //用意した音楽を再生
    [self setAudio:kyokumei kakutyoushi:kakutyoushi volume:0.2f];
    
    //再生・一時停止ボタンを設置
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    playButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - 45);
    [allUtilityView addSubview:playButton];
    [playButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start" ofType:@"png"]] forState:UIControlStateNormal];  // 画像をセットする
    // ボタンが押された時に指定したメソッドを呼び出す
    [playButton addTarget:self
                   action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *okuri = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    okuri.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height-100);
    [allUtilityView addSubview:okuri];
    [okuri setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start" ofType:@"png"]] forState:UIControlStateNormal];  // 画像をセットする
    // ボタンが押された時に指定したメソッドを呼び出す
    [okuri addTarget:self
              action:@selector(komaokuri) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *modoshi = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    modoshi.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height-150);
    [allUtilityView addSubview:modoshi];
    [modoshi setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start" ofType:@"png"]] forState:UIControlStateNormal];  // 画像をセットする
    // ボタンが押された時に指定したメソッドを呼び出す
    [modoshi addTarget:self
              action:@selector(komamodoshi) forControlEvents:UIControlEventTouchUpInside];
    
    
    //再生のシークバーを設置
    timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 10)];
    timeSlider.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - 25);
    [allUtilityView addSubview:timeSlider];
    timeSlider.maximumValue = audio.duration;
    [timeSlider setThumbImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bar" ofType:@"png"]] forState:UIControlStateNormal];
    [timeSlider addTarget:self action:@selector(timeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [timeSlider addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [timeSlider addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                            target:self
                                          selector:@selector(upDateSlider:)
                                          userInfo:nil
                                           repeats:YES];
    [timer fire];
    
    //アイコンの位置を保存するボタンを設置
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    saveButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.height - 45);
    [allUtilityView addSubview:saveButton];
    [saveButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"saveButton" ofType:@"png"]] forState:UIControlStateNormal];  // 画像をセットする
    // ボタンが押された時にsaveIconメソッドを呼び出す
    [saveButton addTarget:self
                   action:@selector(saveIcon:) forControlEvents:UIControlEventTouchUpInside];
    
    if(newHumen){
        ExceptionArea *exception = [[ExceptionArea alloc] initWithData:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width, 60) startTime:0 endTime:3600 iconTagNumber:0];
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        [dataArray addObject:exception];
        
        NSData *data2 = [Icon serialize:dataArray];
        NSMutableArray *tmp = [stages objectAtIndex:stageNumber];
        [tmp replaceObjectAtIndex:4 withObject:data2];
        [stages replaceObjectAtIndex:stageNumber withObject:tmp];
        [[NSUserDefaults standardUserDefaults] setObject:stages forKey:@"stageArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:@"stageArray"];
        stages = [[NSMutableArray alloc] initWithArray:arr];
    }
    
    //過去に保存したアイコンの配列を読み込む
    NSData *data = [[stages objectAtIndex:stageNumber] objectAtIndex:3];
    NSData *exceptionAreaData = [[stages objectAtIndex:stageNumber] objectAtIndex:4];
    iconArray = [Icon deserialize:data];
    exceptionAreaArray = [Icon deserialize:exceptionAreaData];
    
    //タグナンバーを初期化(既に発番済みのタグナンバーはiconArrayの要素数と一致するため、その次の番号から発番）
    iconTagNumber = [iconArray count] + 1;
    
    //タイムスライダーの値を変更する前の、音楽のcurrentTime
    zenkai = 0;
    
    //アニメーション中のアイコンを管理する配列
    animatingNowIconArray = [[NSMutableArray alloc] init];
    
    singleTapAnimationDuration = 1;
    panAnimationDuration = 0.85;
    longPressAnimationDuration = 1;
}

- (void)touchUpInside{
    NSLog(@"スライダーの編集が完了しました");
}

- (void)touchUpOutside{
    NSLog(@"スライダーの編集が完了しました");
}

- (void)viewDidAppear:(BOOL)animated{
    //現在の再生時刻を表すラベル(currentTimeLabel)と、残りの再生時間を表すラベル(durationLabel)を設定
    currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,[UIScreen mainScreen].bounds.size.height - 30 - 2, 100, 30)];
    durationLabel    = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 5, [UIScreen mainScreen].bounds.size.height - 30 - 2, 100, 30)];
    currentTimeLabel.textColor = [UIColor whiteColor];
    durationLabel.textColor = [UIColor whiteColor];
    currentTimeLabel.font = [UIFont systemFontOfSize:10];
    durationLabel.font = [UIFont systemFontOfSize:10];
    [allUtilityView addSubview:currentTimeLabel];
    [allUtilityView addSubview:durationLabel];
    
    //ラベルの内容をアップデート
    [self updateLabel];
}

- (void)setAudio:(NSString *)musicName kakutyoushi:(NSString *)extension volume:(float)volume{
    //再生対象の音楽ファイルのパスを指定する
        //Documentsファイルを指定
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *DocumentsDirPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"music"];
        //再生曲名及び拡張子を指定
            //現状、拡張子は全てm4aに強制変換しているので、m4aに変更する
            extension = @"m4a";
        NSString *kyokumeiAndKakutyoushi = [musicName stringByAppendingPathExtension:extension];
        //上の２つを結合
        NSString *path = [DocumentsDirPath stringByAppendingPathComponent:kyokumeiAndKakutyoushi];
        //musicPathに指定する
        musicPath = path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
        NSURL *url = [NSURL fileURLWithPath:musicPath];
        NSError *error = nil;
        
        audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        //    [audio prepareToPlay];
        audio.volume = volume;
        
        // エラーが起きたとき
        if ( error != nil )
        {
            NSLog(@"Error %@", [error localizedDescription]);
        }

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"再生する曲が見つかりませんでした。この譜面を削除してください。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
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

- (IBAction)saveIcon:(id)sender{
    humenNameAlertView = [[UIAlertView alloc] initWithTitle:@"譜面の保存" message:@"保存する譜面名を入力してください" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"譜面を保存する", nil];
    humenNameAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    humenNameAlertView.frame = CGRectMake(0, 50, 300, 200);
    humenNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
    humenNameTextField = [humenNameAlertView textFieldAtIndex:0];
    humenNameTextField.placeholder = @"譜面名を入力";
    humenNameTextField.text = [NSString stringWithFormat:@"%@",[[stages objectAtIndex:stageNumber] objectAtIndex:0]];
    humenNameTextField.delegate = self;
    humenNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [humenNameTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [humenNameTextField reloadInputViews];
    [humenNameAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //譜面名が入力された際に飛んでくるメソッド。譜面名と譜面本体を保存する。
    switch (buttonIndex) {
        case 0:
            //保存処理をキャンセルした時。なにもしない。
            break;
        case 1:
            //実際に保存を行ったとき
        {
            //独自クラス(Iconクラス)はそのままNSUserDefaultに保存するために、NSData型に変換する
            //NSData型への変換は仕様上Iconクラスでしかできないので、とりあえず適用にIconクラスのメソッド適用
            NSData *data = [Icon serialize:iconArray];
            NSData *exceptionAreaData = [Icon serialize:exceptionAreaArray];
            
            //譜面名、曲名、曲の拡張子、譜面をひとつの配列にまとめる
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:humenNameTextField.text, kyokumei, kakutyoushi, data, exceptionAreaData, nil];

            //編集前の譜面と入れ替える
            [stages replaceObjectAtIndex:stageNumber withObject:tempArray];
            NSLog(@"replace");
            [[NSUserDefaults standardUserDefaults] setObject:stages forKey:@"stageArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"完成");
            
            //プロパティリストに譜面名・譜面画像・譜面画像名を保存（譜面画像・譜面画像名は現在未使用のためnilを入れてある）
            NSString *dirPath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"propertyList"] stringByAppendingPathComponent:@"musicName.plist"];
            NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:dirPath];
            [array replaceObjectAtIndex:stageNumber withObject:[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@(%@)",humenNameTextField.text,kyokumei], @"title", nil,@"image_name",nil,@"image",nil]];
            [array writeToFile:dirPath atomically:YES];
            
            //ビューを閉じる
            //新規譜面ならNewHumenCreateビューを通しているので一つ多くビューを閉じる。
            if ([stages count] == (stageNumber + 1)) {
                [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            }else{
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            }
        }
        default:
            break;
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

//音楽のコマ送りを実装
-(void)komaokuri{
    [self upDateSlider:nil];
    [audio play];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(playAudio:)
                                   userInfo:nil
                                    repeats:NO];
}

//音楽のコマ戻しを実装
-(void)komamodoshi{
    audio.currentTime -= 0.2;
    [self upDateSlider:nil];
    [audio play];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(playAudio:)
                                   userInfo:nil
                                    repeats:NO];
}

//タイムスライダーの表示をアップデートする
-(void)upDateSlider:(NSTimer*)timer{
//    if([audio isPlaying]){
        timeSlider.value = audio.currentTime;
        zenkai = audio.currentTime;
        [self updateLabel];
        [self refleshIcon:YES];
//    }
    NSLog(@"count:%d",[self.view.subviews count]);
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
        [animatingNowIconArray removeAllObjects];
    }
    
    if (isPlaying) {
        //再生中ならアニメーションさせる
        for (int i = 0; i < [iconArray count]; i++) {
            Icon *icon = [iconArray objectAtIndex:i];
            if (![icon isEqual:[NSNull null]] && icon.startTime <= audio.currentTime && icon.endTime >= audio.currentTime && [animatingNowIconArray indexOfObject:icon] == NSNotFound) {
                
                MBAnimationView *mb = [[MBAnimationView alloc] init];
                mb.userInteractionEnabled = YES;
                mb.tag = icon.iconTagNumber;
                [animatingNowIconArray addObject:icon];
                switch (icon.iconType) {
                    case 1:
                        //シングルタップの場合
                    {
                        NSLog(@"kita");
                        [mb setAnimationImage:@"pipo-btleffect007.png" :120 :120 :14];
                        mb.animationDuration = singleTapAnimationDuration;
                        [self createTapGestureRecognizers:mb];
                    }
                        break;
                    case 2:
                        //スワイプの場合
                    {
                        NSLog(@"kita");
                        [mb setAnimationImage:@"PanGesture.png" :120 :120 :14];
                        mb.animationDuration = panAnimationDuration;
                        [self createPanGestureRecognizers:mb];
                    }
                        
                        break;
                    case 3:
                        //ロングプレスの場合
                    {
                        NSLog(@"kita");
                        [mb setAnimationImage:@"LongPressGesture.png" :120 :120 :14];
                        mb.animationDuration = longPressAnimationDuration;
                        [self createLongPressGestureRecognizers:mb];
                    }
                        break;
                    default:
                        break;
                }
                
                mb.frame = CGRectMake(icon.centerPoint.x - 60, icon.centerPoint.y - 60, 120, 120);
                int x = [self.view.subviews count];
                [self.view addSubview:mb];
                int y = [self.view.subviews count];
                if (x +1 == y) {
                    NSLog(@"挿入OK");
                }else{
                    NSLog(@"挿入ミス");
                }
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
        initPoint = sender.view.center;
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
        
        int exceptionNum = 0; //sender.view.tag番目の例外エリアは、動かしているアイコンそのもののエリアであるため、例外判定から外す。そのために、exceptionNum = sender.view.tagとなる時のみ例外判定を行わない。
        for (ExceptionArea *ex in exceptionAreaArray){
            if (sender.view.tag != exceptionNum++) {
                if(![ex isEqual:[NSNull null]] && audio.currentTime >= ex.startTime && audio.currentTime <= ex.endTime && CGRectIntersectsRect (ex.exceptionArea, sender.view.frame)){
                    isExistInExceptionArea = YES;
                }
            }
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
            
            
            //移動したアイコンの領域に他のアイコンが入らないよう、例外エリアの設定を更新する
            ExceptionArea *ex = [exceptionAreaArray objectAtIndex:sender.view.tag];
            ex.exceptionArea = sender.view.frame;
            [exceptionAreaArray replaceObjectAtIndex:sender.view.tag withObject:ex];
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
        
        //既にアイコンが3つ表示されていたら、アイコンを追加できないようにする
        BOOL alreadyExist3Icon = NO;
        int  num = 0;
        for (int i = 0; i < [iconArray count] ; i++) {
            //既にアイコンが3つ表示されているかをチェック
            Icon *ic = iconArray[i];
            if(![iconArray[i] isKindOfClass:[NSNull class]]){
                if(audio.currentTime >= ic.startTime && audio.currentTime <= ic.endTime) num++;
            }
        }
        if (num == 3) alreadyExist3Icon = YES;
        
        //既にアイコンが999個生成されていたら、アイコンを追加できないようにする
        BOOL alreadyExist999Icon = NO;
        int  num2 = 0;
        for (int i = 0; i < [iconArray count] ; i++) {
            //既にアイコンが3つ表示されているかをチェック
            if(![iconArray[i] isKindOfClass:[NSNull class]]) num2++;
        }
        if (num2 == 999) alreadyExist999Icon = YES;
        
        
        
        for (ExceptionArea *ex in exceptionAreaArray){
            if((![ex isEqual:[NSNull null]] && audio.currentTime >= ex.startTime && audio.currentTime <= ex.endTime && CGRectIntersectsRect (ex.exceptionArea, sender.view.frame)) || alreadyExist3Icon || alreadyExist999Icon){
                isExistInExceptionArea = YES;
            }
        }
        
        
        
        if (isExistInExceptionArea){
            sender.view.center = initPoint; //スワイプの終点がExceptionAreaに入っていたらスワイプ開始時点にViewを戻す
            if (alreadyExist3Icon) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"オーバー" message:@"一度に置けるアイコンの数は３つまでです。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            if (alreadyExist999Icon) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"オーバー" message:@"合計で置けるアイコンの数は999個までです。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }

        }else{
            //アイコン作成に成功した時、アイコンを指定の位置に置き、そのコピーを元の位置に作成し、アイコンからはコピー能力を消し、代わりにダブルタップしたら消えるようにする。
            
            //アイコンにタグナンバーを与える
            sender.view.tag = iconTagNumber++;
            NSLog(@"sender.view.tag in panActionWithCopy:%d", sender.view.tag);
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
                
                //作成したアイコンの領域に他のアイコンが入らないよう、例外エリアに設定する
                [self setExceptionArea:sender.view.frame startTime:audio.currentTime endTime:audio.currentTime + singleTapAnimationDuration iconTagNumber:sender.view.tag];
                
                
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
                
                //作成したアイコンの領域に他のアイコンが入らないよう、例外エリアに設定する
                [self setExceptionArea:sender.view.frame startTime:audio.currentTime endTime:audio.currentTime + panAnimationDuration iconTagNumber:sender.view.tag];
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
                
                //作成したアイコンの領域に他のアイコンが入らないよう、例外エリアに設定する
                [self setExceptionArea:sender.view.frame startTime:audio.currentTime endTime:audio.currentTime + longPressAnimationDuration iconTagNumber:sender.view.tag];
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

-(void)setExceptionArea:(CGRect)rect startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime iconTagNumber:(int)tag{
    ExceptionArea *exception = [[ExceptionArea alloc] initWithData:rect startTime:startTime endTime:endTime iconTagNumber:tag];
    [exceptionAreaArray addObject:exception];
}

- (void)doubleTapMethod : (UITapGestureRecognizer *)sender {
    //ビューを消去
    [sender.view removeFromSuperview];
    
    //iconArrayに登録されているアイコンを消去(removeすると配列内のビューの位置番号とtagの番号がずれてしまうので、代わりにnullを詰める)
    [iconArray replaceObjectAtIndex:sender.view.tag - 1 withObject:[NSNull null]];
    //exceotionAreaArrayに登録されている配列要素も消去（exceotionAreaArrayの0番目には、常に画面下端から60pxの例外領域が登録されているため、iconArrayとは要素が1つずつずれた配列になることに注意！）
    [exceptionAreaArray replaceObjectAtIndex:sender.view.tag withObject:[NSNull null]];
}

- (void)createTapGestureRecognizers:(UIView *)targetView {
    UITapGestureRecognizer *singleFingerSingleTap = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handleSingleTap:)];
    [targetView addGestureRecognizer:singleFingerSingleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGPoint point = [sender locationOfTouch:0 inView:window];
    NSLog(@"Tap Point: %@", NSStringFromCGPoint(point));
    Icon *i = [iconArray objectAtIndex:sender.view.tag - 1];
    CGPoint p = [self accuracyOfTapGesture:CGPointMake(point.x, point.y) MBAnimation:(MBAnimationView *)sender.view gestureStartTime:(i.startTime + singleTapAnimationDuration)];
    if(p.x == 0 && p.y == 0){
        NSLog(@"失敗");
        [sender.view removeFromSuperview];
    }else{
        NSLog(@"成功");
        MBAnimationView *mb = [[MBAnimationView alloc] init];
        [mb setAnimationImage:@"tap.png" :160 :120 :9];
        mb.frame = CGRectMake(p.x, p.y, 120, 120);
        mb.animationDuration = 0.5;
        [self.view addSubview:mb];
        [mb startAnimating];
    }
}

- (void)createPanGestureRecognizers:(UIView *)targetView {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(handlePanGesture:)];
    [targetView addGestureRecognizer:panGestureRecognizer];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateBegan){
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        CGPoint point = [sender locationOfTouch:0 inView:window];
        Icon *i = [iconArray objectAtIndex:sender.view.tag - 1];
        CGPoint p = [self accuracyOfPanGesture:CGPointMake(point.x, point.y) MBAnimation:(MBAnimationView *)sender.view gestureStartTime:(i.startTime + panAnimationDuration)];
        if(p.x == 0 && p.y == 0){
            NSLog(@"失敗");
            [sender.view removeFromSuperview];
        }else{
            NSLog(@"成功");
            MBAnimationView *mb = [[MBAnimationView alloc] init];
            [mb setAnimationImage:@"pipo-btleffect078.png" :120 :120 :14];
            mb.frame = CGRectMake(p.x, p.y, 120, 120);
            mb.animationDuration = 0.5;
            [self.view addSubview:mb];
            [mb startAnimating];
        }
    }
}

- (void)createLongPressGestureRecognizers:(UIView *)targetView {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPress.allowableMovement = 10.0; //ロングプレス中に動いても許容されるピクセル数を指定
    longPress.minimumPressDuration = 0.4; //ジェスチャ認識のために押し続ける秒数を指定
    [targetView addGestureRecognizer:longPress];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGPoint point = [sender locationOfTouch:0 inView:window];
    Icon *i = [iconArray objectAtIndex:sender.view.tag - 1];
    if ([sender state] == UIGestureRecognizerStateBegan){
        CGPoint p = [self accuracyOfLongPressGesture:CGPointMake(point.x, point.y) MBAnimation:(MBAnimationView *)sender.view gestureStartTime:(i.startTime + panAnimationDuration)];
        if(p.x == 0 && p.y == 0){
            NSLog(@"失敗");
        }else{
            NSLog(@"成功");
            MBAnimationView *mb = [[MBAnimationView alloc] init];
            [mb setAnimationImage:@"long.png" :160 :120 :24];
            mb.frame = CGRectMake(p.x, p.y, 120, 120);
            mb.animationDuration = 1.0;
            [self.view addSubview:mb];
            [mb startAnimating];
        }
        [sender.view removeFromSuperview];
    }
}

//シングルタップ開始のタイミングと座標が一致しているかを判定するメソッド。一致していれば対象のアニメーションのorigin.xとorigin.yを返す。一致していなければCGPointZeroを返す。
-(CGPoint)accuracyOfTapGesture:(CGPoint)point MBAnimation:(MBAnimationView *)mbAnimation gestureStartTime:(NSTimeInterval)gestureStartTime{
    //アニメーションをストップする
    [mbAnimation stopAnimating];
    
    CGPoint cg = CGPointZero;
    float  thresholdOfTimeInterval = 0.5; //タップしたタイミングの曖昧さの閾値を設定
    //設定した閾値から、タップ成功範囲とタイミングを設定
    if (CGRectContainsPoint(mbAnimation.frame, point)) {
        cg = CGPointMake(mbAnimation.frame.origin.x, mbAnimation.frame.origin.y);
    }else{
        NSLog(@"タップした座標が合っていない");
        NSLog(@"x:%f y:%f",mbAnimation.frame.origin.x,mbAnimation.frame.origin.y);
        return cg;
    }
    
    if ((audio.currentTime - gestureStartTime) >= thresholdOfTimeInterval * -1 && (audio.currentTime - gestureStartTime) <= thresholdOfTimeInterval) {
        NSLog(@"最高得点時からの差:%lf",(audio.currentTime - gestureStartTime));
    }else{
        NSLog(@"タイミング合っていない");
        NSLog(@"最高得点時からの差:%lf",(audio.currentTime - gestureStartTime));
        cg = CGPointZero;
    }
    return cg;
}

//スワイプ開始のタイミングと座標が一致しているかを判定するメソッド。一致していれば対象のアニメーションのorigin.xとorigin.yを返す。一致していなければCGPointZeroを返す。
- (CGPoint)accuracyOfPanGesture:(CGPoint)point MBAnimation:(MBAnimationView *)mbAnimation gestureStartTime:(NSTimeInterval)gestureStartTime{
    //アニメーションをストップする
    [mbAnimation stopAnimating];
    
    CGPoint cg = CGPointZero;
    float  thresholdOfTimeInterval = 0.5; //タップしたタイミングの曖昧さの閾値を設定
    //設定した閾値から、タップ成功範囲とタイミングを設定
    if (CGRectContainsPoint(mbAnimation.frame, point)) {
        cg = CGPointMake(mbAnimation.frame.origin.x, mbAnimation.frame.origin.y);
    }else{
        NSLog(@"タップした座標が合っていない");
        NSLog(@"x:%f y:%f",mbAnimation.frame.origin.x,mbAnimation.frame.origin.y);
        return cg;
    }
    
    if ((audio.currentTime - gestureStartTime) >= thresholdOfTimeInterval * -1 && (audio.currentTime - gestureStartTime) <= thresholdOfTimeInterval) {
        NSLog(@"最高得点時からの差:%lf",(audio.currentTime - gestureStartTime));
    }else{
        NSLog(@"タイミング合っていない");
        NSLog(@"最高得点時からの差:%lf",(audio.currentTime - gestureStartTime));
        cg = CGPointZero;
    }
    return cg;
}


//ロングプレス開始のタイミングと座標が一致しているかを判定するメソッド。一致していれば対象のアニメーションのorigin.xとorigin.yを返す。一致していなければCGPointZeroを返す。
-(CGPoint)accuracyOfLongPressGesture:(CGPoint)point MBAnimation:(MBAnimationView *)mbAnimation gestureStartTime:(NSTimeInterval)gestureStartTime{
    //アニメーションをストップする
    [mbAnimation stopAnimating];
    
    CGPoint cg = CGPointZero;
    float  thresholdOfTimeInterval = 0.5; //タップしたタイミングの曖昧さの閾値を設定
    //設定した閾値から、タップ成功範囲とタイミングを設定
    if (CGRectContainsPoint(mbAnimation.frame, point)) {
        cg = CGPointMake(mbAnimation.frame.origin.x, mbAnimation.frame.origin.y);
    }else{
        NSLog(@"タップした座標が合っていない");
        NSLog(@"x:%f y:%f",mbAnimation.frame.origin.x,mbAnimation.frame.origin.y);
        return cg;
    }
    
    if ((audio.currentTime - gestureStartTime) >= thresholdOfTimeInterval * -1 && (audio.currentTime - gestureStartTime) <= thresholdOfTimeInterval) {
        NSLog(@"最高得点時からの差:%lf",(audio.currentTime - gestureStartTime));
    }else{
        NSLog(@"タイミング合っていない");
        NSLog(@"最高得点時からの差:%lf",(audio.currentTime - gestureStartTime));
        cg = CGPointZero;
    }
    
    return cg;
}


@end
