//
//  MainViewController.m
//  Test
//
//  Created by 秋乃雨弓 on 2014/11/15.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    animationDuration = 1.0f;
    // Do any additional setup after loading the view, typically from a nib.
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn setTitle:@"押してね" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    // ボタンがタッチダウンされた時にhogeメソッドを呼び出す
    [btn addTarget:self action:@selector(hoge:)
  forControlEvents:UIControlEventTouchUpInside];
    
}

//音楽が選ばれ、ゲームスタートする際のメソッド
-(void)hoge:(UIButton*)button{
    // ここに何かの処理を記述する
    // （引数の button には呼び出し元のUIButtonオブジェクトが引き渡されてきます）
    [button removeFromSuperview];
    [self startMusic];
    musicStartTime = [NSDate date];
}

//音楽の再生と決められた時間毎にアニメーションとタップ判定を生み出すメソッド
- (void)startMusic{
    //デバッグ用に、適当にデータを作る
//    TapGesture *t1 = [[TapGesture alloc] init];
//    t1.startTime = 3;
//    t1.x = 100;
//    t1.y = 100;
//    
//    TapGesture *t2 = [[TapGesture alloc] init];
//    t2.startTime = 4;
//    t2.x = 150;
//    t2.y = 150;
//    
//    TapGesture *t3 = [[TapGesture alloc] init];
//    t3.startTime = 5;
//    t3.x = 200;
//    t3.y = 200;
//    
//    tapMusicArray = [[NSArray alloc] initWithObjects:t1, t2, t3, nil];
    
    [self createTapGestureRecognizers:mainView];
    
//    LongPressGesture *l1 = [[LongPressGesture alloc] init];
//    l1.startTime = 3;
//    l1.x = 100;
//    l1.y = 100;
//    
//    LongPressGesture *l2 = [[LongPressGesture alloc] init];
//    l2.startTime = 4;
//    l2.x = 150;
//    l2.y = 150;
//    
//    LongPressGesture *l3 = [[LongPressGesture alloc] init];
//    l3.startTime = 5;
//    l3.x = 200;
//    l3.y = 200;
//    
//    tapMusicArray = [[NSArray alloc] initWithObjects:l1, l2, l3, nil];
    
    [self createLongPressGestureRecognizers:mainView];
    
    TapGesture *p1 = [[TapGesture alloc] init];
    p1.startTime = 3;
    p1.x = 100;
    p1.y = 100;
    
    PanGesture *p2 = [[PanGesture alloc] init];
    p2.startTime = 5;
    p2.x = 150;
    p2.y = 150;
    
    LongPressGesture *p3 = [[LongPressGesture alloc] init];
    p3.startTime = 7;
    p3.x = 200;
    p3.y = 200;
    
    tapMusicArray = [[NSArray alloc] initWithObjects:p1, p2, p3, nil];
    
    [self createPanGestureRecognizers:mainView];
    
    for (int i = 0;  i < [tapMusicArray count]; i++) {
        //シングルタップ・スワイプ・ロングプレスのいずれかを判定し、タップ画像を表示するタイマーを設定する
        if ([[tapMusicArray objectAtIndex:i] isKindOfClass:[TapGesture class]]) {
            tapGesture = [tapMusicArray objectAtIndex:i];
            // 指定時間経過後に呼び出すメソッドに渡すデータをセット
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:tapGesture.x], @"x", [NSNumber numberWithFloat:tapGesture.y], @"y", [NSNumber numberWithInt:i], @"gestureNumber", @"TapGesture", @"gestureType", nil];
            NSLog(@"x:%f",tapGesture.x);
            // タイマーを生成
            [NSTimer scheduledTimerWithTimeInterval:tapGesture.startTime - animationDuration
                                             target:self
                                           selector:@selector(doTimer:)
                                           userInfo:userInfo
                                            repeats:NO
             ];
        }else if ([[tapMusicArray objectAtIndex:i] isKindOfClass:[PanGesture class]]){
            panGesture = [tapMusicArray objectAtIndex:i];
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

        }else if ([[tapMusicArray objectAtIndex:i] isKindOfClass:[LongPressGesture class]]){
            longPressGesture = [tapMusicArray objectAtIndex:i];
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
    }
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
            NSLog(@"mbAnimation1起動");
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
            NSLog(@"mbAnimation2起動");
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
            NSLog(@"mbAnimation3起動");
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
        [NSTimer scheduledTimerWithTimeInterval:animationDuration
                                         target:self
                                       selector:@selector(mbAnimationToNil:)
                                       userInfo:userInfo
                                        repeats:NO
         ];
    }else if ([gestureType isEqualToString:@"PanGesture"]){
        if (mbAnimation1 == nil) {
            NSLog(@"mbAnimation1起動");
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
            NSLog(@"mbAnimation2起動");
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
            NSLog(@"mbAnimation3起動");
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
            NSLog(@"mbAnimation1起動");
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
            NSLog(@"mbAnimation2起動");
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
            NSLog(@"mbAnimation3起動");
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
    
    [NSTimer scheduledTimerWithTimeInterval:animationDuration
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
            mbAnimation1 = nil;
            break;
        case 2:
            mbAnimation2 = nil;
            break;
        case 3:
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

@end
