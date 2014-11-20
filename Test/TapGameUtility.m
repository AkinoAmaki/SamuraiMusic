//
//  TapGameUtility.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/21.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "TapGameUtility.h"

@implementation TapGameUtility

+ (void)createTapGestureRecognizers:(UIView *)targetView {
    UITapGestureRecognizer *singleFingerSingleTap = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handleSingleTap:)];
    [targetView addGestureRecognizer:singleFingerSingleTap];
}

+ (void)handleSingleTap:(id)sender {
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

+ (void)createPanGestureRecognizers:(UIView *)targetView {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(handlePanGesture:)];
    [targetView addGestureRecognizer:panGestureRecognizer];
}

+ (void)handlePanGesture:(id)sender {
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

+ (void)createLongPressGestureRecognizers:(UIView *)targetView {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPress.allowableMovement = 10.0; //ロングプレス中に動いても許容されるピクセル数を指定
    longPress.minimumPressDuration = 0.4; //ジェスチャ認識のために押し続ける秒数を指定
    [targetView addGestureRecognizer:longPress];
}

+ (void)handleLongPressGesture:(id)sender {
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
+ (CGPoint)accuracyOfTapGesture:(CGPoint)point{
    CGPoint cg = CGPointZero;
    float  thresholdOfTimeInterval = 0.5; //タップしたタイミングの曖昧さの閾値を設定
    NSDate *now = [NSDate date]; //現在時刻を取得
    NSTimeInterval interval = [now timeIntervalSinceDate:musicStartTime]; //現在時刻とスタート時点の時刻を比較
    TapGesture *t;
    //設定した閾値から、タップ成功範囲とタイミングを設定
    if (CGRectContainsPoint(mbAnimation1.frame, point)) {
        t = [tapMusicArray objectAtIndex:(mbAnimation1.tag - 1)]; //判定対象のTapGestureを取得
        if([t isKindOfClass:[TapGesture class]]) cg = CGPointMake(mbAnimation1.frame.origin.x, mbAnimation1.frame.origin.y);
    }else if (CGRectContainsPoint(mbAnimation2.frame, point)){
        t = [tapMusicArray objectAtIndex:(mbAnimation2.tag - 1)]; //判定対象のTapGestureを取得
        if([t isKindOfClass:[TapGesture class]]) cg = CGPointMake(mbAnimation2.frame.origin.x, mbAnimation2.frame.origin.y);
    }else if (CGRectContainsPoint(mbAnimation3.frame, point)){
        t = [tapMusicArray objectAtIndex:(mbAnimation3.tag - 1)]; //判定対象のTapGestureを取得
        if([t isKindOfClass:[TapGesture class]]) cg = CGPointMake(mbAnimation3.frame.origin.x, mbAnimation3.frame.origin.y);
    }else{
        NSLog(@"タップした座標が合っていない");
        NSLog(@"x:%f y:%f",mbAnimation1.frame.origin.x,mbAnimation1.frame.origin.y);
        return cg;
    }
    
    float gestureStartTime = t.startTime;
    
    if ((interval - gestureStartTime) >= thresholdOfTimeInterval * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval) {
        NSLog(@"最高得点時からの差:%lf",(interval - gestureStartTime));
    }else{
        NSLog(@"タイミング合っていない");
        NSLog(@"最高得点時からの差:%lf",(interval - gestureStartTime));
        cg = CGPointZero;
    }
    return cg;
}

//スワイプ開始のタイミングと座標が一致しているかを判定するメソッド。一致していれば対象のアニメーションのorigin.xとorigin.yを返す。一致していなければCGPointZeroを返す。
+ (CGPoint)accuracyOfPanGesture:(CGPoint)point{
    CGPoint cg = CGPointZero;
    float  thresholdOfTimeInterval = 0.5; //タップしたタイミングの曖昧さの閾値を設定
    NSDate *now = [NSDate date]; //現在時刻を取得
    NSTimeInterval interval = [now timeIntervalSinceDate:musicStartTime]; //現在時刻とスタート時点の時刻を比較
    PanGesture *p;
    
    NSLog(@"pointX:%f pointY:%f",point.x, point.y);
    NSLog(@"originX:%f originY:%f sizeX:%f sizeY:%f",mbAnimation1.frame.origin.x,mbAnimation1.frame.origin.y,mbAnimation1.frame.size.width,mbAnimation1.frame.size.height);
    
    //設定した閾値から、タップ成功範囲とタイミングを設定
    if (CGRectContainsPoint(mbAnimation1.frame, point)) {
        p = [tapMusicArray objectAtIndex:(mbAnimation1.tag - 1)]; //判定対象のLongPressGestureを取得
        if([p isKindOfClass:[PanGesture class]]) cg = CGPointMake(mbAnimation1.frame.origin.x, mbAnimation1.frame.origin.y);
    }else if (CGRectContainsPoint(mbAnimation2.frame, point)){
        p = [tapMusicArray objectAtIndex:(mbAnimation2.tag - 1)]; //判定対象のLongPressGestureを取得
        if([p isKindOfClass:[PanGesture class]]) cg = CGPointMake(mbAnimation2.frame.origin.x, mbAnimation2.frame.origin.y);
    }else if (CGRectContainsPoint(mbAnimation3.frame, point)){
        p = [tapMusicArray objectAtIndex:(mbAnimation3.tag - 1)]; //判定対象のLongPressGestureを取得
        if([p isKindOfClass:[PanGesture class]]) cg = CGPointMake(mbAnimation3.frame.origin.x, mbAnimation3.frame.origin.y);
    }else{
        NSLog(@"タップした座標が合っていない");
        NSLog(@"x:%f y:%f",mbAnimation1.frame.origin.x,mbAnimation1.frame.origin.y);
        return cg;
    }
    
    float gestureStartTime = p.startTime;
    
    if ((interval - gestureStartTime) >= thresholdOfTimeInterval * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval) {
        NSLog(@"最高得点時からの差:%lf",(interval - gestureStartTime));
    }else{
        NSLog(@"タイミング合っていない");
        NSLog(@"最高得点時からの差:%lf",(interval - gestureStartTime));
        cg = CGPointZero;
    }
    
    return cg;
    
}


//ロングプレス開始のタイミングと座標が一致しているかを判定するメソッド。一致していれば対象のアニメーションのorigin.xとorigin.yを返す。一致していなければCGPointZeroを返す。
+ (CGPoint)accuracyOfLongPressGesture:(CGPoint)point{
    CGPoint cg = CGPointZero;
    float  thresholdOfTimeInterval = 0.5; //タップしたタイミングの曖昧さの閾値を設定
    NSDate *now = [NSDate date]; //現在時刻を取得
    NSTimeInterval interval = [now timeIntervalSinceDate:musicStartTime]; //現在時刻とスタート時点の時刻を比較
    LongPressGesture *l;
    //設定した閾値から、タップ成功範囲とタイミングを設定
    if (CGRectContainsPoint(mbAnimation1.frame, point)) {
        l = [tapMusicArray objectAtIndex:(mbAnimation1.tag - 1)]; //判定対象のLongPressGestureを取得
        if([l isKindOfClass:[LongPressGesture class]]) cg = CGPointMake(mbAnimation1.frame.origin.x, mbAnimation1.frame.origin.y);
    }else if (CGRectContainsPoint(mbAnimation2.frame, point)){
        l = [tapMusicArray objectAtIndex:(mbAnimation2.tag - 1)]; //判定対象のLongPressGestureを取得
        if([l isKindOfClass:[LongPressGesture class]]) cg = CGPointMake(mbAnimation2.frame.origin.x, mbAnimation2.frame.origin.y);
    }else if (CGRectContainsPoint(mbAnimation3.frame, point)){
        l = [tapMusicArray objectAtIndex:(mbAnimation3.tag - 1)]; //判定対象のLongPressGestureを取得
        if([l isKindOfClass:[LongPressGesture class]]) cg = CGPointMake(mbAnimation3.frame.origin.x, mbAnimation3.frame.origin.y);
    }else{
        NSLog(@"タップした座標が合っていない");
        NSLog(@"x:%f y:%f",mbAnimation1.frame.origin.x,mbAnimation1.frame.origin.y);
        return cg;
    }
    
    float gestureStartTime = l.startTime;
    
    if ((interval - gestureStartTime) >= thresholdOfTimeInterval * -1 && (interval - gestureStartTime) <= thresholdOfTimeInterval) {
        NSLog(@"最高得点時からの差:%lf",(interval - gestureStartTime));
    }else{
        NSLog(@"タイミング合っていない");
        NSLog(@"最高得点時からの差:%lf",(interval - gestureStartTime));
        cg = CGPointZero;
    }
    
    return cg;
}


@end
