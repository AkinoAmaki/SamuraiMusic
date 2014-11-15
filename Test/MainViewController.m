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
    TapGesture *t1 = [[TapGesture alloc] init];
    t1.startTime = 3;
    t1.x = 100;
    t1.y = 100;
    
    TapGesture *t2 = [[TapGesture alloc] init];
    t2.startTime = 3.4;
    t2.x = 150;
    t2.y = 150;
    
    TapGesture *t3 = [[TapGesture alloc] init];
    t3.startTime = 3.8;
    t3.x = 200;
    t3.y = 200;
    
    tapMusicArray = [[NSArray alloc] initWithObjects:t1, t2, t3, nil];
    [self createTapGestureRecognizers:mainView];
    
    for (int i = 0;  i < [tapMusicArray count]; i++) {
        tapGesture = [tapMusicArray objectAtIndex:i];

        // 指定時間経過後に呼び出すメソッドに渡すデータをセット
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:tapGesture.x], @"x", [NSNumber numberWithFloat:tapGesture.y], @"y", [NSNumber numberWithInt:i], @"gestureNumber", nil];
        NSLog(@"x:%f",tapGesture.x);
        
        // タイマーを生成
        [NSTimer scheduledTimerWithTimeInterval:tapGesture.startTime - animationDuration
                                         target:self
                                       selector:@selector(doTimer:)
                                       userInfo:userInfo
                                        repeats:NO
         ];
    }
    
    
    
}

- (void)doTimer:(NSTimer *)timer{
    //timerのuserInfoからX座標とY座標を取得する
    float userInfoX = [[(NSDictionary *)timer.userInfo objectForKey:@"x"] floatValue];
    float userInfoY = [[(NSDictionary *)timer.userInfo objectForKey:@"y"] floatValue];
    int gestureNumber = [[(NSDictionary *)timer.userInfo objectForKey:@"gestureNumber"] intValue];
    NSDictionary *userInfo; // 指定時間経過後に呼び出すメソッドに渡すデータ
    if (mbAnimation1 == nil) {
        NSLog(@"mbAnimation1起動");
        mbAnimation1 = [[MBAnimationView alloc] init];
        [mbAnimation1 setAnimationImage:@"pipo-btleffect007.png" :120 :120 :14];
        mbAnimation1.frame = CGRectMake(userInfoX - 60, userInfoY - 60, 120, 120);
        mbAnimation1.animationDuration = animationDuration;
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
        mbAnimation2.animationDuration = animationDuration;
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
        mbAnimation3.animationDuration = animationDuration;
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


- (void)createTapGestureRecognizers:(UIView *)targetView {
    UITapGestureRecognizer *singleFingerSingleTap = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handleSingleTap:)];
    [targetView addGestureRecognizer:singleFingerSingleTap];
}

- (void)handleSingleTap:(id)sender {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGPoint point = [sender locationOfTouch:0 inView:window];
    NSLog(@"Tap Point: %@", NSStringFromCGPoint(point));
    
    if([self accuracyOfTapGesture:CGPointMake(point.x, point.y)]){
        NSLog(@"成功");
    }else{
        NSLog(@"ミス");
    }
}

- (void)createPanGestureRecognizers:(UIView *)targetView {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePanGesture:)];
    [targetView addGestureRecognizer:panGesture];
}

- (void)handlePanGesture:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
    CGPoint point = [pan translationInView:mainView];
    CGPoint velocity = [pan velocityInView:mainView];
    NSLog(@"pan. translation: %@, velocity: %@", NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
}

- (void)createLongPressGestureRecognizers:(UIView *)targetView {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(handleLongPressGesture:)];
    [targetView addGestureRecognizer:longPressGesture];
}

- (void)handleLongPressGesture:(id)sender {
    if([sender state] == UIGestureRecognizerStateEnded){
         NSLog(@"長押し終了のタイミング");
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        CGPoint point = [sender locationOfTouch:0 inView:window];
        NSLog(@"Tap Point: %@", NSStringFromCGPoint(point));
    }else if ([sender state] == UIGestureRecognizerStateBegan){
        NSLog(@"Long press.");
        NSLog(@"長押し開始のタイミング。何もしない");
        
    }
}

//タップのタイミングと座標が一致しているかを判定するメソッド
-(BOOL)accuracyOfTapGesture:(CGPoint)point{
    BOOL accuracy; //正確にタップできてたらYES,ダメならNO
    float  thresholdOfTimeInterval = 0.5; //タップしたタイミングの曖昧さの閾値を設定
    NSDate *now = [NSDate date]; //現在時刻を取得
    NSTimeInterval interval = [now timeIntervalSinceDate:musicStartTime]; //現在時刻とスタート時点の時刻を比較
    TapGesture *t;
    //設定した閾値から、タップ成功範囲とタイミングを設定
    if (CGRectContainsPoint(mbAnimation1.frame, point)) {
        t = [tapMusicArray objectAtIndex:(mbAnimation1.tag - 1)]; //判定対象のTapGestureを取得
    }else if (CGRectContainsPoint(mbAnimation2.frame, point)){
        t = [tapMusicArray objectAtIndex:(mbAnimation2.tag - 1)]; //判定対象のTapGestureを取得
    }else if (CGRectContainsPoint(mbAnimation3.frame, point)){
        t = [tapMusicArray objectAtIndex:(mbAnimation3.tag - 1)]; //判定対象のTapGestureを取得
    }else{
        accuracy = NO;
        NSLog(@"タップした座標が合っていない");
        return accuracy;
    }
    
    float gestureStartTime = t.startTime;
    
    if ((interval - gestureStartTime) >= thresholdOfTimeInterval * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval) {
        accuracy = YES;
        NSLog(@"最高得点時からの差:%lf",(interval - gestureStartTime));
    }else{
        accuracy = NO;
        NSLog(@"タイミング合っていない");
        NSLog(@"最高得点時からの差:%lf",(interval - gestureStartTime));
    }

    
    return accuracy;
}




@end
