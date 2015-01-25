//
//  MainViewController.m
//  Test
//
//  Created by 秋乃雨弓 on 2014/11/15.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController
@synthesize stages;
@synthesize stageNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    animationDuration = 1.0f;
    // Do any additional setup after loading the view, typically from a nib.
    //Appdelegateを初期化
    app = [[UIApplication sharedApplication] delegate];
    
    score = 0; //スコアを初期化
    combo = 0; //コンボ回数の初期化
    perfectKeisuu = 1.0; //タップタイミングがPerfectのときにかける係数を初期化
    greatKeisuu   = 0.8; //タップタイミングがGreatのときにかける係数を初期化
    goodKeisuu    = 0.5; //タップタイミングがGoodのときにかける係数を初期化
    
    perfectNum = 0;
    greatNum   = 0;
    goodNum    = 0;
    missNum    = 0;
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, 150, 30)];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.font = app.font;
    [self.view addSubview:scoreLabel];
    scoreLabel.text = [NSString stringWithFormat:@"%07d",score];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn setTitle:@"押してね" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    // ボタンがタッチアップされた時にhogeメソッドを呼び出す
    [btn addTarget:self action:@selector(hoge:)
  forControlEvents:UIControlEventTouchUpInside];
    
    [self startMusic];
    
    //プレイが終わったら結果画面に移る
    //    //!!!: デバッグ用に10秒にしているが、本番時には再生時間の秒数に変更する。
    //    [NSTimer scheduledTimerWithTimeInterval:10
    //                                     target:self
    //                                   selector:@selector(modalResultView)
    //                                   userInfo:nil
    //                                    repeats:NO
    //     ];
}


//self.viewをMainViewに変更する
- (void)loadView
{
    [super loadView];
    mainView = [[MainView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    mainView.backgroundColor = [UIColor blackColor];
    self.view = mainView;
}


- (void)viewDidAppear:(BOOL)animated{


}

//音楽が選ばれ、ゲームスタートする際のメソッド
-(void)hoge:(UIButton*)button{
    // ここに何かの処理を記述する
    // （引数の button には呼び出し元のUIButtonオブジェクトが引き渡されてきます）
//    [button removeFromSuperview];
    [self modalResultView];
}

- (void)setAudio:(NSString *)musicName kakutyoushi:(NSString *)extension volume:(float)volume{
    //再生対象の音楽ファイルのパスを指定する
    //Documentsファイルを指定
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocumentsDirPath = [paths objectAtIndex:0];
    //再生曲名及び拡張子を指定
    //現状、拡張子は全てm4aに強制変換しているので、m4aに変更する
    extension = @"m4a";
    NSString *kyokumeiAndKakutyoushi = [musicName stringByAppendingPathExtension:extension];
    //上の２つを結合
    NSString *path = [DocumentsDirPath stringByAppendingPathComponent:kyokumeiAndKakutyoushi];
    //musicPathに指定する
    NSString *musicPath = path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
        NSURL *url = [NSURL fileURLWithPath:musicPath];
        NSError *error = nil;
        
        audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//            [audio prepareToPlay];
        audio.volume = volume;
        
        // エラーが起きたとき
        if ( error != nil )
        {
            NSLog(@"Error %@", [error localizedDescription]);
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"再生する曲が見つかりませんでした。この譜面を削除してください。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
    }
}

//音楽の再生と決められた時間毎にアニメーションとタップ判定を生み出すメソッド
- (void)startMusic{
    //各々のジェスチャーのレコグナイザを登録
    [self createTapGestureRecognizers:mainView];
    [self createPanGestureRecognizers:mainView];
    [self createLongPressGestureRecognizers:mainView];
    
    //タップするアイコンをget
    NSData *data = [[stages objectAtIndex:stageNumber] objectAtIndex:3];
    tapMusicArray = [[NSArray alloc] initWithArray:[Icon deserialize:data]];
    
    for (int i = 0;  i < [tapMusicArray count]; i++) {
        //シングルタップ・スワイプ・ロングプレスのいずれかを判定し、タップ画像を表示するタイマーを設定する
        Icon *icon = [Icon new];
        
        //tapMusicArrayの要素がNSNullの場合は、アイコン登録処理をスキップする
        if(![tapMusicArray[i] isKindOfClass:[NSNull class]]){
            icon = tapMusicArray[i];
            switch (icon.iconType) {
                case 1:
                {
                    tapGesture = [TapGesture new];
                    tapGesture.x = icon.centerPoint.x;
                    tapGesture.y = icon.centerPoint.y;
                    tapGesture.startTime = icon.startTime;
                    // 指定時間経過後に呼び出すメソッドに渡すデータをセット
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithFloat:tapGesture.x], @"x", [NSNumber numberWithFloat:tapGesture.y], @"y", [NSNumber numberWithInt:i], @"gestureNumber", @"TapGesture", @"gestureType", nil];
                    // タイマーを生成
                    [NSTimer scheduledTimerWithTimeInterval:tapGesture.startTime - animationDuration
                                                     target:self
                                                   selector:@selector(doTimer:)
                                                   userInfo:userInfo
                                                    repeats:NO
                     ];
                }
                    break;
                case 2:
                {
                    panGesture = [PanGesture new];
                    panGesture.x = icon.centerPoint.x;
                    panGesture.y = icon.centerPoint.y;
                    panGesture.startTime = icon.startTime;
                    // 指定時間経過後に呼び出すメソッドに渡すデータをセット
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithFloat:panGesture.x], @"x", [NSNumber numberWithFloat:panGesture.y], @"y", [NSNumber numberWithInt:i], @"gestureNumber", @"PanGesture", @"gestureType", nil];
                    // タイマーを生成
                    [NSTimer scheduledTimerWithTimeInterval:panGesture.startTime - animationDuration
                                                     target:self
                                                   selector:@selector(doTimer:)
                                                   userInfo:userInfo
                                                    repeats:NO
                     ];
                    
                }
                    break;
                case 3:
                {
                    longPressGesture = [LongPressGesture new];
                    longPressGesture.x = icon.centerPoint.x;
                    longPressGesture.y = icon.centerPoint.y;
                    longPressGesture.startTime = icon.startTime;
                    // 指定時間経過後に呼び出すメソッドに渡すデータをセット
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithFloat:longPressGesture.x], @"x", [NSNumber numberWithFloat:longPressGesture.y], @"y", [NSNumber numberWithInt:i], @"gestureNumber", @"LongPressGesture", @"gestureType", nil];
                    // タイマーを生成
                    [NSTimer scheduledTimerWithTimeInterval:longPressGesture.startTime - animationDuration
                                                     target:self
                                                   selector:@selector(doTimer:)
                                                   userInfo:userInfo
                                                    repeats:NO
                     ];
                    
                }
                    break;
                default:
                    break;
            }

        }
        //        if ([[tapMusicArray objectAtIndex:i] isKindOfClass:[TapGesture class]]) {
//            tapGesture = [tapMusicArray objectAtIndex:i];
//            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      [NSNumber numberWithFloat:tapGesture.x], @"x", [NSNumber numberWithFloat:tapGesture.y], @"y", [NSNumber numberWithInt:i], @"gestureNumber", @"TapGesture", @"gestureType", nil];
//            NSLog(@"x:%f",tapGesture.x);
//            // タイマーを生成
//            [NSTimer scheduledTimerWithTimeInterval:tapGesture.startTime - animationDuration
//                                             target:self
//                                           selector:@selector(doTimer:)
//                                           userInfo:userInfo
//                                            repeats:NO
//             ];
//        }else if ([[tapMusicArray objectAtIndex:i] isKindOfClass:[PanGesture class]]){
//            panGesture = [tapMusicArray objectAtIndex:i];
//            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      [NSNumber numberWithFloat:panGesture.x], @"x", [NSNumber numberWithFloat:panGesture.y], @"y", [NSNumber numberWithInt:i], @"gestureNumber", @"PanGesture", @"gestureType", nil];
//            // タイマーを生成
//            [NSTimer scheduledTimerWithTimeInterval:panGesture.startTime - animationDuration
//                                             target:self
//                                           selector:@selector(doTimer:)
//                                           userInfo:userInfo
//                                            repeats:NO
//             ];
//
//        }else if ([[tapMusicArray objectAtIndex:i] isKindOfClass:[LongPressGesture class]]){
//            longPressGesture = [tapMusicArray objectAtIndex:i];
//            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      [NSNumber numberWithFloat:longPressGesture.x], @"x", [NSNumber numberWithFloat:longPressGesture.y], @"y", [NSNumber numberWithInt:i], @"gestureNumber", @"LongPressGesture", @"gestureType", nil];
//            // タイマーを生成
//            [NSTimer scheduledTimerWithTimeInterval:longPressGesture.startTime - animationDuration
//                                             target:self
//                                           selector:@selector(doTimer:)
//                                           userInfo:userInfo
//                                            repeats:NO
//             ];
//        }
    }
    
    //現在時刻を保存
    musicStartTime = [NSDate date];
    
    //音楽再生開始
    [self setAudio:[[stages objectAtIndex:stageNumber] objectAtIndex:1] kakutyoushi:[[stages objectAtIndex:stageNumber] objectAtIndex:2] volume:0.2f];
    [audio play];

    NSLog(@"プレイ開始");
}

- (void)doTimer:(NSTimer *)timer{
    //timerのuserInfoからX座標とY座標とジェスチャの番号とジェスチャタイプを取得する
    float userInfoX = [[(NSDictionary *)timer.userInfo objectForKey:@"x"] floatValue];
    float userInfoY = [[(NSDictionary *)timer.userInfo objectForKey:@"y"] floatValue];
    int gestureNumber = [[(NSDictionary *)timer.userInfo objectForKey:@"gestureNumber"] intValue];
    NSString *gestureType = [(NSDictionary *)timer.userInfo objectForKey:@"gestureType"];
    // アニメーション終了後にアニメーションをnilにするため、1,2,3番のいずれのアニメーションを使用したかを格納する変数を作成
    NSDictionary *userInfo;

    if ([gestureType isEqualToString:@"TapGesture"]) {
        if (mbAnimation1 == nil) {
            mbAnimation1 = [[MBAnimationView alloc] init];
            [mbAnimation1 setAnimationImage:@"pipo-btleffect007.png" :120 :120 :14];
            mbAnimation1.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
            mbAnimation1.animationDuration = 1;
            mbAnimation1.tag = gestureNumber + 1;
            [self.view addSubview:mbAnimation1];
            [mbAnimation1 startAnimating];
            // タイマーを生成。アニメーションが終了次第データをmbAnimationをnilに置き換える
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:1], @"Number", nil];
        }else if (mbAnimation2 == nil){
            mbAnimation2 = [[MBAnimationView alloc] init];
            [mbAnimation2 setAnimationImage:@"pipo-btleffect007.png" :120 :120 :14];
            mbAnimation2.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
            mbAnimation2.animationDuration = 1;
            mbAnimation2.tag = gestureNumber + 1;
            [self.view addSubview:mbAnimation2];
            [mbAnimation2 startAnimating];
            // タイマーを生成。アニメーションが終了次第データをmbAnimationをnilに置き換える
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:2], @"Number", nil];
        }else if (mbAnimation3 == nil){
            mbAnimation3 = [[MBAnimationView alloc] init];
            [mbAnimation3 setAnimationImage:@"pipo-btleffect007.png" :120 :120 :14];
            mbAnimation3.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
            mbAnimation3.animationDuration = 1;
            mbAnimation3.tag = gestureNumber + 1;
            [self.view addSubview:mbAnimation3];
            [mbAnimation3 startAnimating];
            // タイマーを生成。アニメーションが終了次第データをmbAnimationをnilに置き換える
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:3], @"Number", nil];
        }
    }else if ([gestureType isEqualToString:@"PanGesture"]){
        if (mbAnimation1 == nil) {
            mbAnimation1 = [[MBAnimationView alloc] init];
            [mbAnimation1 setAnimationImage:@"PanGesture.png" :120 :120 :20];
            mbAnimation1.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
            mbAnimation1.animationDuration = 1;
            mbAnimation1.tag = gestureNumber + 1;
            [self.view addSubview:mbAnimation1];
            [mbAnimation1 startAnimating];
            // タイマーを生成。アニメーションが終了次第データをmbAnimationをnilに置き換える
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:1], @"Number", nil];
        }else if (mbAnimation2 == nil){
            mbAnimation2 = [[MBAnimationView alloc] init];
            [mbAnimation2 setAnimationImage:@"PanGesture.png" :120 :120 :20];
            mbAnimation2.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
            mbAnimation2.animationDuration = 1;
            mbAnimation2.tag = gestureNumber + 1;
            [self.view addSubview:mbAnimation2];
            [mbAnimation2 startAnimating];
            // タイマーを生成。アニメーションが終了次第データをmbAnimationをnilに置き換える
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:2], @"Number", nil];
        }else if (mbAnimation3 == nil){
            mbAnimation3 = [[MBAnimationView alloc] init];
            [mbAnimation3 setAnimationImage:@"PanGesture.png" :120 :120 :20];
            mbAnimation3.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
            mbAnimation3.animationDuration = 1;
            mbAnimation3.tag = gestureNumber + 1;
            [self.view addSubview:mbAnimation3];
            [mbAnimation3 startAnimating];
            // タイマーを生成。アニメーションが終了次第データをmbAnimationをnilに置き換える
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:3], @"Number", nil];
        }
    }else if ([gestureType isEqualToString:@"LongPressGesture"]){
        if (mbAnimation1 == nil) {
            mbAnimation1 = [[MBAnimationView alloc] init];
            [mbAnimation1 setAnimationImage:@"LongPressGesture.png" :120 :120 :14];
            mbAnimation1.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
            mbAnimation1.animationDuration = 0.85;
            mbAnimation1.tag = gestureNumber + 1;
            [self.view addSubview:mbAnimation1];
            [mbAnimation1 startAnimating];
            // タイマーを生成。アニメーションが終了次第データをmbAnimationをnilに置き換える
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:1], @"Number", nil];
        }else if (mbAnimation2 == nil){
            mbAnimation2 = [[MBAnimationView alloc] init];
            [mbAnimation2 setAnimationImage:@"LongPressGesture.png" :120 :120 :14];
            mbAnimation2.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
            mbAnimation2.animationDuration = 1;
            mbAnimation2.tag = gestureNumber + 1;
            [self.view addSubview:mbAnimation2];
            [mbAnimation2 startAnimating];
            // タイマーを生成。アニメーションが終了次第データをmbAnimationをnilに置き換える
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:2], @"Number", nil];
        }else if (mbAnimation3 == nil){
            mbAnimation3 = [[MBAnimationView alloc] init];
            [mbAnimation3 setAnimationImage:@"LongPressGesture.png" :120 :120 :14];
            mbAnimation3.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
            mbAnimation3.animationDuration = 1;
            mbAnimation3.tag = gestureNumber + 1;
            [self.view addSubview:mbAnimation3];
            [mbAnimation3 startAnimating];
            // タイマーを生成。アニメーションが終了次第データをmbAnimationをnilに置き換える
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:3], @"Number", nil];
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:animationDuration - 0.1
                                     target:self
                                   selector:@selector(mbAnimationToNil:)
                                   userInfo:userInfo
                                    repeats:NO
     ];
}

- (void)mbAnimationToNil:(NSTimer *)timer{
    int i = [[(NSDictionary *)timer.userInfo objectForKey:@"Number"] intValue];
    switch (i) {
        case 1:
            if ([mbAnimation1 isAnimating]) {
                [self popUpHanteiKekka:mbAnimation1 Kekka:Miss];
            }
            mbAnimation1 = nil;
            break;
        case 2:
            if ([mbAnimation2 isAnimating]) {
                [self popUpHanteiKekka:mbAnimation2 Kekka:Miss];
            }
            mbAnimation2 = nil;
            break;
        case 3:
            if ([mbAnimation3 isAnimating]) {
                [self popUpHanteiKekka:mbAnimation3 Kekka:Miss];
            }
            mbAnimation3 = nil;
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createTapGestureRecognizers:(UIView *)targetView {
    UITapGestureRecognizer *singleFingerSingleTap = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handleSingleTap:)];
    [targetView addGestureRecognizer:singleFingerSingleTap];
}

- (void)handleSingleTap:(id)sender {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGPoint point = [sender locationOfTouch:0 inView:window];
    NSLog(@"Tap Point: %@", NSStringFromCGPoint(point));
    CGPoint p = [self accuracyOfTapGesture:CGPointMake(point.x, point.y)];
    if(p.x == 0 && p.y == 0){
        NSLog(@"失敗");
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

- (void)createPanGestureRecognizers:(UIView *)targetView {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePanGesture:)];
    [targetView addGestureRecognizer:panGestureRecognizer];
}

- (void)handlePanGesture:(id)sender {
    if ([sender state] == UIGestureRecognizerStateBegan){
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        CGPoint point = [sender locationOfTouch:0 inView:window];
        CGPoint p = [self accuracyOfPanGesture:CGPointMake(point.x, point.y)];
        if(p.x == 0 && p.y == 0){
            NSLog(@"失敗");
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

- (void)handleLongPressGesture:(id)sender {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGPoint point = [sender locationOfTouch:0 inView:window];
//    NSLog(@"Tap Point: %@", NSStringFromCGPoint(point));
    if ([sender state] == UIGestureRecognizerStateBegan){
        CGPoint p = [self accuracyOfLongPressGesture:CGPointMake(point.x, point.y)];
        if(p.x == 0 && p.y == 0){
            NSLog(@"失敗");
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

//シングルタップ開始のタイミングと座標が一致しているかを判定するメソッド。一致していれば対象のアニメーションのorigin.xとorigin.yを返す。一致していなければCGPointZeroを返す。
-(CGPoint)accuracyOfTapGesture:(CGPoint)point{
    CGPoint cg = CGPointZero;
    
    NSDate *now = [NSDate date]; //現在時刻を取得
    NSTimeInterval interval = [now timeIntervalSinceDate:musicStartTime]; //現在時刻とスタート時点の時刻を比較
    float gestureStartTime;
    
    //設定した閾値から、タップ成功範囲とタイミングを設定
    Icon *icon = [Icon new];
    if (CGRectContainsPoint(mbAnimation1.frame, point)) {
        [mbAnimation1 stopAnimating];
        icon = tapMusicArray[mbAnimation1.tag - 1];
        if (icon.iconType == 1) {
            cg = CGPointMake(mbAnimation1.frame.origin.x, mbAnimation1.frame.origin.y);
            gestureStartTime = icon.startTime;
            [self judgeTouchTiming:mbAnimation1 cg:cg interval:interval gestureStartTime:gestureStartTime];
        }
    }else if (CGRectContainsPoint(mbAnimation2.frame, point)){
        [mbAnimation2 stopAnimating];
        icon = tapMusicArray[mbAnimation2.tag - 1];
        if (icon.iconType == 1) {
            cg = CGPointMake(mbAnimation2.frame.origin.x, mbAnimation2.frame.origin.y);
            gestureStartTime = icon.startTime;
            [self judgeTouchTiming:mbAnimation2 cg:cg interval:interval gestureStartTime:gestureStartTime];
        }
    }else if (CGRectContainsPoint(mbAnimation3.frame, point)){
        icon = tapMusicArray[mbAnimation3.tag - 1];
        [mbAnimation3 stopAnimating];
        if (icon.iconType == 1) {
            cg = CGPointMake(mbAnimation3.frame.origin.x, mbAnimation3.frame.origin.y);
            gestureStartTime = icon.startTime;
            [self judgeTouchTiming:mbAnimation3 cg:cg interval:interval gestureStartTime:gestureStartTime];
        }
    }else{
        NSLog(@"タップした座標が合っていない");
        NSLog(@"x:%f y:%f",mbAnimation1.frame.origin.x,mbAnimation1.frame.origin.y);
        return cg;
    }
    
    return cg;
}

//スワイプ開始のタイミングと座標が一致しているかを判定するメソッド。一致していれば対象のアニメーションのorigin.xとorigin.yを返す。一致していなければCGPointZeroを返す。
- (CGPoint)accuracyOfPanGesture:(CGPoint)point{
    CGPoint cg = CGPointZero;
    NSDate *now = [NSDate date]; //現在時刻を取得
    NSTimeInterval interval = [now timeIntervalSinceDate:musicStartTime]; //現在時刻とスタート時点の時刻を比較
    PanGesture *p;
    
    NSLog(@"pointX:%f pointY:%f",point.x, point.y);
    NSLog(@"originX:%f originY:%f sizeX:%f sizeY:%f",mbAnimation1.frame.origin.x,mbAnimation1.frame.origin.y,mbAnimation1.frame.size.width,mbAnimation1.frame.size.height);
    float gestureStartTime = p.startTime;
    
    //設定した閾値から、タップ成功範囲とタイミングを設定
    if (CGRectContainsPoint(mbAnimation1.frame, point)) {
        [mbAnimation1 stopAnimating];
        p = [tapMusicArray objectAtIndex:(mbAnimation1.tag - 1)]; //判定対象のLongPressGestureを取得
        if([p isKindOfClass:[PanGesture class]]){
            cg = CGPointMake(mbAnimation1.frame.origin.x, mbAnimation1.frame.origin.y);
            [self judgeTouchTiming:mbAnimation1 cg:cg interval:interval gestureStartTime:gestureStartTime];
        }
    }else if (CGRectContainsPoint(mbAnimation2.frame, point)){
        [mbAnimation2 stopAnimating];
        p = [tapMusicArray objectAtIndex:(mbAnimation2.tag - 1)]; //判定対象のLongPressGestureを取得
        if([p isKindOfClass:[PanGesture class]]){
            cg = CGPointMake(mbAnimation2.frame.origin.x, mbAnimation2.frame.origin.y);
            [self judgeTouchTiming:mbAnimation2 cg:cg interval:interval gestureStartTime:gestureStartTime];
        }
    }else if (CGRectContainsPoint(mbAnimation3.frame, point)){
        [mbAnimation3 stopAnimating];
        p = [tapMusicArray objectAtIndex:(mbAnimation3.tag - 1)]; //判定対象のLongPressGestureを取得
        if([p isKindOfClass:[PanGesture class]]){
            cg = CGPointMake(mbAnimation3.frame.origin.x, mbAnimation3.frame.origin.y);
            [self judgeTouchTiming:mbAnimation1 cg:cg interval:interval gestureStartTime:gestureStartTime];
        }
    }else{
        NSLog(@"タップした座標が合っていない");
        NSLog(@"x:%f y:%f",mbAnimation1.frame.origin.x,mbAnimation1.frame.origin.y);
        return cg;
    }
    
//    if ((interval - gestureStartTime) >= thresholdOfTimeInterval_Perfect * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval_Perfect) {
//        NSLog(@"Perfect!:%lf",(interval - gestureStartTime));
//        combo++;
//        [self caliculateScore:1];
//    }else if ((interval - gestureStartTime) >= thresholdOfTimeInterval_Great * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval_Great) {
//        NSLog(@"Great!  :%lf",(interval - gestureStartTime));
//        combo++;
//        [self caliculateScore:2];
//    }else if ((interval - gestureStartTime) >= thresholdOfTimeInterval_Good * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval_Good) {
//        NSLog(@"Good!   :%lf",(interval - gestureStartTime));
//        combo++;
//        [self caliculateScore:3];
//    }else{
//        NSLog(@"Miss!   :%lf",(interval - gestureStartTime));
//        combo = 0;
//        cg = CGPointZero;
//    }

    
    return cg;
    
}


//ロングプレス開始のタイミングと座標が一致しているかを判定するメソッド。一致していれば対象のアニメーションのorigin.xとorigin.yを返す。一致していなければCGPointZeroを返す。
-(CGPoint)accuracyOfLongPressGesture:(CGPoint)point{
    CGPoint cg = CGPointZero;
    NSDate *now = [NSDate date]; //現在時刻を取得
    NSTimeInterval interval = [now timeIntervalSinceDate:musicStartTime]; //現在時刻とスタート時点の時刻を比較
    LongPressGesture *l;
    float gestureStartTime = l.startTime;
    //設定した閾値から、タップ成功範囲とタイミングを設定
    if (CGRectContainsPoint(mbAnimation1.frame, point)) {
        [mbAnimation1 stopAnimating];
        l = [tapMusicArray objectAtIndex:(mbAnimation1.tag - 1)]; //判定対象のLongPressGestureを取得
        if([l isKindOfClass:[LongPressGesture class]]){
           cg = CGPointMake(mbAnimation1.frame.origin.x, mbAnimation1.frame.origin.y);
           [self judgeTouchTiming:mbAnimation1 cg:cg interval:interval gestureStartTime:gestureStartTime];
        }
    }else if (CGRectContainsPoint(mbAnimation2.frame, point)){
        [mbAnimation2 stopAnimating];
        l = [tapMusicArray objectAtIndex:(mbAnimation2.tag - 1)]; //判定対象のLongPressGestureを取得
        if([l isKindOfClass:[LongPressGesture class]]){
            cg = CGPointMake(mbAnimation2.frame.origin.x, mbAnimation2.frame.origin.y);
            [self judgeTouchTiming:mbAnimation2 cg:cg interval:interval gestureStartTime:gestureStartTime];
        }
    }else if (CGRectContainsPoint(mbAnimation3.frame, point)){
        [mbAnimation3 stopAnimating];
        l = [tapMusicArray objectAtIndex:(mbAnimation3.tag - 1)]; //判定対象のLongPressGestureを取得
        if([l isKindOfClass:[LongPressGesture class]]){
            cg = CGPointMake(mbAnimation3.frame.origin.x, mbAnimation3.frame.origin.y);
            [self judgeTouchTiming:mbAnimation3 cg:cg interval:interval gestureStartTime:gestureStartTime];
        }
    }else{
        NSLog(@"タップした座標が合っていない");
        NSLog(@"x:%f y:%f",mbAnimation1.frame.origin.x,mbAnimation1.frame.origin.y);
        return cg;
    }
    
    
    
//    if ((interval - gestureStartTime) >= thresholdOfTimeInterval_Perfect * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval_Perfect) {
//        NSLog(@"Perfect!:%lf",(interval - gestureStartTime));
//        combo++;
//        [self caliculateScore:1];
//    }else if ((interval - gestureStartTime) >= thresholdOfTimeInterval_Great * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval_Great) {
//        NSLog(@"Great!  :%lf",(interval - gestureStartTime));
//        combo++;
//        [self caliculateScore:2];
//    }else if ((interval - gestureStartTime) >= thresholdOfTimeInterval_Good * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval_Good) {
//        NSLog(@"Good!   :%lf",(interval - gestureStartTime));
//        combo++;
//        [self caliculateScore:3];
//    }else{
//        NSLog(@"Miss!   :%lf",(interval - gestureStartTime));
//        combo = 0;
//        cg = CGPointZero;
//    }
    
    return cg;
}

- (void)judgeTouchTiming:(MBAnimationView *)MBAnimation cg:(CGPoint)cg interval:(NSTimeInterval)interval gestureStartTime:(float)gestureStartTime{
    float  thresholdOfTimeInterval_Perfect = 0.25; //タップしたタイミングの曖昧さの閾値を設定(Perfect)
    float  thresholdOfTimeInterval_Great = 0.35; //タップしたタイミングの曖昧さの閾値を設定(Great)
    float  thresholdOfTimeInterval_Good = 0.50; //タップしたタイミングの曖昧さの閾値を設定(Good)
    
    if ((interval - gestureStartTime) >= thresholdOfTimeInterval_Perfect * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval_Perfect) {
        NSLog(@"Perfect!:%lf",(interval - gestureStartTime));
        combo++;
        perfectNum++;
        [self popUpHanteiKekka:MBAnimation Kekka:Perfect];
        [self caliculateScore:1];
    }else if ((interval - gestureStartTime) >= thresholdOfTimeInterval_Great * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval_Great) {
        NSLog(@"Great!  :%lf",(interval - gestureStartTime));
        combo++;
        greatNum++;
        [self popUpHanteiKekka:MBAnimation Kekka:Great];
        [self caliculateScore:2];
    }else if ((interval - gestureStartTime) >= thresholdOfTimeInterval_Good * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval_Good) {
        NSLog(@"Good!   :%lf",(interval - gestureStartTime));
        combo++;
        goodNum++;
        [self popUpHanteiKekka:MBAnimation Kekka:Good];
        [self caliculateScore:3];
    }else{
        NSLog(@"Miss!   :%lf",(interval - gestureStartTime));
        cg = CGPointZero;
        missNum++;
        [self popUpHanteiKekka:MBAnimation Kekka:Miss];
        combo = 0;
    }
}


-(void)caliculateScore:(int)kekka{
    float comboKeisuu;
    if (combo == 0) {
        comboKeisuu = 1;
    }else if (combo <= 20) {
        comboKeisuu = 1 + combo * 0.05;
    }else{
        comboKeisuu = 2;
    }
    
    
    int zoukaInt;
    switch (kekka) {
        case 1:
            //Perfectのとき
            zoukaInt = 1000 * perfectKeisuu + 300 * comboKeisuu;
            score +=  zoukaInt;
            break;
        case 2:
            //Greatのとき
            zoukaInt = 1000 * greatKeisuu   + 300 * comboKeisuu;
            score += zoukaInt;
            break;
        case 3:
            //Goodのとき
            zoukaInt = 1000 * goodKeisuu    + 300 * comboKeisuu;
            score += zoukaInt;
            break;
        default:
            zoukaInt = 0; //絶対defaultは通らないけど、適当に設定しないとWarningが出るので設定しておく
            break;
    }
    [self refleshScore:score];
    NSLog(@"score:%d",score);
}

-(void)popUpHanteiKekka:(MBAnimationView *)MBAnimation Kekka:(KekkaType)kekka{
    DamageValueLabel *label = [DamageValueLabel new];
    label.frame = CGRectOffset(MBAnimation.frame, 50, 50);
    [self.view addSubview:label];
    
    if (kekka == Perfect) {
        label.textColor = [UIColor yellowColor];
        label.text      = @"Perfect!";
    }else if (kekka == Great){
        label.textColor = [UIColor greenColor];
        label.text      = @"Great!";
    }else if (kekka == Good){
        label.textColor = [UIColor blueColor];
        label.text      = @"Good!";
    }else if (kekka == Miss){
        label.textColor = [UIColor redColor];
        label.text      = @"Miss...";
    }
    
    [label startAnimationWithAnimationType:DamageAnimationType3];
}

-(void)refleshScore:(int)syou{
    scoreLabel.text = [NSString stringWithFormat:@"%07d", syou];
    [scoreLabel sizeToFit];
}

-(void)modalResultView{
    int maxScore = [self caliculateMaxScore];
    [audio stop];
    ResultView *result = [[ResultView alloc] initWithData:score maxScore:maxScore perfectNum:perfectNum greatNum:greatNum goodNum:goodNum missNum:missNum];
    [self presentViewController:result animated:YES completion:nil];
}

-(int)caliculateMaxScore{
    int maxScore;
    int x = 0;
    
    for (Icon *icon in tapMusicArray) {
        if (![icon isMemberOfClass:[NSNull class]]) {
            x++;
        }
    }
    
    NSLog(@"x:%d",x);
    
    float keisuu= 0;
    for (int i = 0; i < x; i++) {
        if (i == 0) {
            keisuu = 1;
        }else if (i <= 20) {
            keisuu = 1 + (i * 0.05);
        }else{
            keisuu = 2;
        }
        maxScore += 1000 + 300 * keisuu;
    }
    NSLog(@"maxscore:%d",maxScore);
    
    return maxScore;
}



@end

