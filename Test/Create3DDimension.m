//
//  Create3DDimension.m
//  Samurai
//
//  Created by 秋乃雨弓 on 2015/02/03.
//  Copyright (c) 2015年 秋乃雨弓. All rights reserved.
//

#import "Create3DDimension.h"
#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation Create3DDimension

- (void)createGround:(UIView *)view groundImage:(UIImage *)groundImage rightWallImage:(UIImage *)rightWallImage leftWallImage:(UIImage *)leftWallImage roadHeight:(int)roadHeight roadRadian:(float)roadRadian wallRadian:(float)wallRadian moveSpeed:(float)moveSpeed okuyuki:(float)okuyuki
{
    test = 0;
    
    //２組の床＆壁を交互に奥から手前にスライドさせて、3Dイメージを無限ループさせている。
    //手前の１組目を生成(一度手前まで来終わったら、createBackImage1の関数で奥に戻し、再び手前に来させる)
    [self createFrontImage:view groundImage:groundImage rightWallImage:rightWallImage leftWallImage:leftWallImage roadHeight:roadHeight roadRadian:roadRadian wallRadian:wallRadian moveSpeed:moveSpeed okuyuki:okuyuki];
    //奥の２組目を生成
    [self createBackImage2:view groundImage:groundImage rightWallImage:rightWallImage leftWallImage:leftWallImage roadHeight:roadHeight roadRadian:roadRadian wallRadian:wallRadian moveSpeed:moveSpeed okuyuki:okuyuki];
    
    //受け取った変数を全てディクショナリに突っ込んで、画像を動かすのに備える
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:view,@"view", groundImage,@"groundImage",rightWallImage,@"rightWallImage",leftWallImage,@"leftWallImage",[NSNumber numberWithInt:roadHeight],@"roadHeight",[NSNumber numberWithFloat:roadRadian],@"roadRadian",[NSNumber numberWithFloat:wallRadian],@"wallRadian",[NSNumber numberWithFloat:moveSpeed],@"moveSpeed",[NSNumber numberWithFloat:okuyuki],@"okuyuki",nil];
    
    //床＆壁を動かす
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/moveSpeed target:self selector:@selector(move:) userInfo:dic repeats:YES];
    //1.0/60.0
}

- (void)createFrontImage:(UIView *)view groundImage:(UIImage *)groundImage rightWallImage:(UIImage *)rightWallImage leftWallImage:(UIImage *)leftWallImage roadHeight:(int)roadHeight roadRadian:(float)roadRadian wallRadian:(float)wallRadian moveSpeed:(float)moveSpeed okuyuki:(float)okuyuki
{
    //床の画像の生成
    road = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groundImage.size.width, groundImage.size.height)];
    road.tag = 1;
    road.center = CGPointMake(view.center.x, roadHeight);
    CALayer *roadLayer = [CALayer layer];
    roadLayer.frame = CGRectMake(0, 0, groundImage.size.width, groundImage.size.height);
    roadLayer.contents = (id)groundImage.CGImage;
    [road.layer addSublayer:roadLayer];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / okuyuki * -1;
    //1.0 / - 200.0;
    baseTrans =  CATransform3DRotate(transform, roadRadian, 1.0f, 0.0f, 0.0f);
    //0.42 * M_PI
    road.layer.transform = baseTrans;
    [view addSubview:road];
    
    //左側壁の画像の生成
    leftWall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftWallImage.size.width, leftWallImage.size.height)];
    leftWall.tag = 2;
    leftWall.center = CGPointMake(view.center.x - 100, roadHeight - leftWallImage.size.height / 2);
    //view.center.y + 150
    CALayer *leftLayer = [CALayer layer];
    leftLayer.frame = CGRectMake(0, 0, leftWallImage.size.width, leftWallImage.size.height);
    leftLayer.contents = (id)leftWallImage.CGImage;
    [leftWall.layer addSublayer:leftLayer];
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m34 = 1.0 / okuyuki * -1;
    baseTrans2 = CATransform3DRotate(transform2, wallRadian, 0.0f, 1.0f, 0.0f);
    //0.35 * M_PI
    leftWall.layer.transform = baseTrans2;
    [view addSubview:leftWall];
    
    //右側壁の画像の生成
    rightWall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightWallImage.size.width, rightWallImage.size.height)];
    rightWall.tag = 3;
    rightWall.center = CGPointMake(view.center.x + 100, roadHeight - rightWallImage.size.height / 2);
    //view.center.y + 150
    CALayer *rightLayer = [CALayer layer];
    rightLayer.frame = CGRectMake(0, 0, rightWallImage.size.width, rightWallImage.size.height);
    rightLayer.contents = (id)rightWallImage.CGImage;
    [rightWall.layer addSublayer:rightLayer];
    CATransform3D transform3 = CATransform3DIdentity;
    transform3.m34 = 1.0 / okuyuki * -1;
    baseTrans3 = CATransform3DRotate(transform3, wallRadian * -1, 0.0f, 1.0f, 0.0f);
    //-0.35 * M_PI
    rightWall.layer.transform = baseTrans3;
    [view addSubview:rightWall];
}

- (void)createBackImage1:(UIView *)view groundImage:(UIImage *)groundImage rightWallImage:(UIImage *)rightWallImage leftWallImage:(UIImage *)leftWallImage roadHeight:(int)roadHeight roadRadian:(float)roadRadian wallRadian:(float)wallRadian moveSpeed:(float)moveSpeed okuyuki:(float)okuyuki
{
    //床の画像の生成
    road = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groundImage.size.width, groundImage.size.height)];
    road.tag = 4;
    road.center = CGPointMake(view.center.x, roadHeight);
    road.layer.contents = (id)groundImage.CGImage;
    CATransform3D transformX = CATransform3DIdentity;
    transformX.m34 = 1.0 / okuyuki * -1;
    //1.0 / - 200.0;
    transformX =  CATransform3DTranslate(transformX, 0, -(groundImage.size.height - 200) /2, -groundImage.size.height + 200);
    transformX =  CATransform3DRotate(transformX, roadRadian, 1.0f, 0.0f, 0.0f);
    //0.42 * M_PI
    road.layer.transform = transformX;
    [view addSubview:road];
    
    //左側壁の画像の生成
    leftWall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftWallImage.size.width, leftWallImage.size.height)];
    leftWall.tag = 5;
    leftWall.center = CGPointMake(view.center.x - 100, roadHeight - leftWallImage.size.height / 2);
    leftWall.layer.contents = (id)leftWallImage.CGImage;
    CATransform3D transformY = CATransform3DIdentity;
    transformY.m34 = 1.0 / okuyuki * -1;
    //1.0 / - 200.0;
    transformY =  CATransform3DTranslate(transformY, (leftWallImage.size.width - 50) / 2, 0, -leftWallImage.size.width + 200);
    transformY =  CATransform3DRotate(transformY, wallRadian, 0.0f, 1.0f, 0.0f);
    //0.42 * M_PI
    leftWall.layer.transform = transformY;
    [view addSubview:leftWall];
    
    //右側壁の画像の生成
    rightWall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightWallImage.size.width, rightWallImage.size.height)];
    rightWall.tag = 6;
    rightWall.center = CGPointMake(view.center.x - 100, roadHeight - rightWallImage.size.height / 2);
    rightWall.layer.contents = (id)rightWallImage.CGImage;
    CATransform3D transformZ = CATransform3DIdentity;
    transformZ.m34 = 1.0 / okuyuki * -1;
    //1.0 / - 200.0;
    transformZ =  CATransform3DTranslate(transformZ, (rightWallImage.size.width  + 115) / 2, 0, -rightWallImage.size.width + 150);
    transformZ =  CATransform3DRotate(transformZ, wallRadian * -1.9, 0.0f, 1.0f, 0.0f);
    //0.42 * M_PI
    rightWall.layer.transform = transformZ;
    [view addSubview:rightWall];
}


- (void)createBackImage2:(UIView *)view groundImage:(UIImage *)groundImage rightWallImage:(UIImage *)rightWallImage leftWallImage:(UIImage *)leftWallImage roadHeight:(int)roadHeight roadRadian:(float)roadRadian wallRadian:(float)wallRadian moveSpeed:(float)moveSpeed okuyuki:(float)okuyuki
{
    //床の画像の生成
    road2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groundImage.size.width, groundImage.size.height)];
    road2.tag = 4;
    road2.center = CGPointMake(view.center.x, roadHeight);
    road2.layer.contents = (id)groundImage.CGImage;
    CATransform3D transformX = CATransform3DIdentity;
    transformX.m34 = 1.0 / okuyuki * -1;
    //1.0 / - 200.0;
    transformX =  CATransform3DTranslate(transformX, 0, -(groundImage.size.height - 200) /2, -groundImage.size.height + 200);
    transformX =  CATransform3DRotate(transformX, roadRadian, 1.0f, 0.0f, 0.0f);
    //0.42 * M_PI
    road2.layer.transform = transformX;
    [view addSubview:road2];
    
    //左側壁の画像の生成
    leftWall2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftWallImage.size.width, leftWallImage.size.height)];
    leftWall2.tag = 5;
    leftWall2.center = CGPointMake(view.center.x - 100, roadHeight - leftWallImage.size.height / 2);
    leftWall2.layer.contents = (id)leftWallImage.CGImage;
    CATransform3D transformY = CATransform3DIdentity;
    transformY.m34 = 1.0 / okuyuki * -1;
    //1.0 / - 200.0;
    transformY =  CATransform3DTranslate(transformY, (leftWallImage.size.width - 50) / 2, 0, -leftWallImage.size.width + 200);
    transformY =  CATransform3DRotate(transformY, wallRadian, 0.0f, 1.0f, 0.0f);
    //0.42 * M_PI
    leftWall2.layer.transform = transformY;
    [view addSubview:leftWall2];
    
    //右側壁の画像の生成
    rightWall2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightWallImage.size.width, rightWallImage.size.height)];
    rightWall2.tag = 6;
    rightWall2.center = CGPointMake(view.center.x - 100, roadHeight - rightWallImage.size.height / 2);
    rightWall2.layer.contents = (id)rightWallImage.CGImage;
    CATransform3D transformZ = CATransform3DIdentity;
    transformZ.m34 = 1.0 / okuyuki * -1;
    //1.0 / - 200.0;
    transformZ =  CATransform3DTranslate(transformZ, (rightWallImage.size.width  + 115) / 2, 0, -rightWallImage.size.width + 150);
    transformZ =  CATransform3DRotate(transformZ, wallRadian * -1.9, 0.0f, 1.0f, 0.0f);
    //0.42 * M_PI
    rightWall2.layer.transform = transformZ;
    [view addSubview:rightWall2];
}

- (void)target:(NSTimer*)sender
{NSLog(@"生成");
    UIView *view = [(NSDictionary *)sender.userInfo objectForKey:@"view"];
    float radian = [[(NSDictionary *)sender.userInfo objectForKey:@"tagetRadian"] floatValue];
    float moveSpeed  = [[(NSDictionary *)sender.userInfo objectForKey:@"moveSpeed"] floatValue];
    float okuyuki = [[(NSDictionary *)sender.userInfo objectForKey:@"okuyuki"] floatValue];
    
    int x = (arc4random()%3) * 40 + 100;
    UIView *target = [[UIView alloc] initWithFrame:CGRectMake(x, road.center.y, 50, -50)];
    target.layer.cornerRadius = 5.0;
    
    UIView *eyeR = [[UIView alloc] initWithFrame:CGRectMake(5, -15, 10, 10)];
    eyeR.backgroundColor = [UIColor whiteColor];
    eyeR.layer.cornerRadius = 5;
    [target addSubview:eyeR];
    
    
    UIView *eyeL = [[UIView alloc] initWithFrame:CGRectMake(35, -15, 10, 10)];
    eyeL.backgroundColor = [UIColor whiteColor];
    eyeL.layer.cornerRadius = 5;
    [target addSubview:eyeL];

    CATransform3D t = baseTrans;
    t = CATransform3DTranslate(t, 0, -okuyuki, okuyuki / -20);
    t = CATransform3DRotate(t, radian, 1, 0, 0);
    //M_PI * 0.52
    target.layer.transform = t;
    [view addSubview:target];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:target,@"target", nil];
    
     [NSTimer scheduledTimerWithTimeInterval:1.0/moveSpeed target:self selector:@selector(move2:) userInfo:dic repeats:YES];
    //1.0/60.0
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hit:)];
    [target addGestureRecognizer:tap];
}

- (void)move:(NSTimer*)sender
{
    //１組目の床＆壁が手前まで来終わったら、一旦ビューを消去したあと、奥で再生成する
    if (road.layer.transform.m44 <= -2)/* 画像の長さによって適切なm44の数値は上下する */ {
        UIView *view = [(NSDictionary *)sender.userInfo objectForKey:@"view"];
        UIImage *gImage = [(NSDictionary *)sender.userInfo objectForKey:@"groundImage"];
        UIImage *rImage = [(NSDictionary *)sender.userInfo objectForKey:@"rightWallImage"];
        UIImage *lImage = [(NSDictionary *)sender.userInfo objectForKey:@"leftWallImage"];
        int roadH =  [[(NSDictionary *)sender.userInfo objectForKey:@"roadHeight"] intValue];
        float roadR = [[(NSDictionary *)sender.userInfo objectForKey:@"roadRadian"] floatValue];
        float wallR = [[(NSDictionary *)sender.userInfo objectForKey:@"wallRadian"] floatValue];
        float moveS = [[(NSDictionary *)sender.userInfo objectForKey:@"moveSpeed"] floatValue];
        float oku = [[(NSDictionary *)sender.userInfo objectForKey:@"okuyuki"] floatValue];
        [[view viewWithTag:1] removeFromSuperview];
        [[view viewWithTag:2] removeFromSuperview];
        [[view viewWithTag:3] removeFromSuperview];
        [self createBackImage1:view groundImage:gImage rightWallImage:rImage leftWallImage:lImage roadHeight:roadH roadRadian:roadR wallRadian:wallR moveSpeed:moveS okuyuki:oku];
    }
    //２組目の床＆壁が手前まで来終わったら、一旦ビューを消去したあと、奥で再生成する
    else if (road2.layer.transform.m44 <= -2)/* 画像の長さによって適切なm44の数値は上下する */ {
        UIView *view = [(NSDictionary *)sender.userInfo objectForKey:@"view"];
        UIImage *gImage = [(NSDictionary *)sender.userInfo objectForKey:@"groundImage"];
        UIImage *rImage = [(NSDictionary *)sender.userInfo objectForKey:@"rightWallImage"];
        UIImage *lImage = [(NSDictionary *)sender.userInfo objectForKey:@"leftWallImage"];
        int roadH =  [[(NSDictionary *)sender.userInfo objectForKey:@"roadHeight"] intValue];
        float roadR = [[(NSDictionary *)sender.userInfo objectForKey:@"roadRadian"] floatValue];
        float wallR = [[(NSDictionary *)sender.userInfo objectForKey:@"wallRadian"] floatValue];
        float moveS = [[(NSDictionary *)sender.userInfo objectForKey:@"moveSpeed"] floatValue];
        float oku = [[(NSDictionary *)sender.userInfo objectForKey:@"okuyuki"] floatValue];
        [[view viewWithTag:4] removeFromSuperview];
        [[view viewWithTag:5] removeFromSuperview];
        [[view viewWithTag:6] removeFromSuperview];
        [self createBackImage2:view groundImage:gImage rightWallImage:rImage leftWallImage:lImage roadHeight:roadH roadRadian:roadR wallRadian:wallR moveSpeed:moveS okuyuki:oku];
    
    }
    //１組目も２組目もまだ手前に来ていない場合は、両方共手前に移動させる(CATransform3DTranslateの数値を変えることでスピードが変えられる)
    else{
        road.layer.transform   = CATransform3DTranslate(road.layer.transform, 0, 3, 0);
        leftWall.layer.transform   = CATransform3DTranslate(leftWall.layer.transform, -3, 0, 0);
        rightWall.layer.transform   = CATransform3DTranslate(rightWall.layer.transform, 3, 0, 0);
        road2.layer.transform   = CATransform3DTranslate(road2.layer.transform, 0, 3, 0);
        leftWall2.layer.transform   = CATransform3DTranslate(leftWall2.layer.transform, -3, 0, 0);
        rightWall2.layer.transform   = CATransform3DTranslate(rightWall2.layer.transform, 3, 0, 0);
    }
}


- (void)move2:(NSTimer*)sender
{
    UIView *target      = [(NSDictionary *)sender.userInfo objectForKey:@"target"];
    
    target.layer.transform = CATransform3DTranslate(target.layer.transform, 0, 0, -3);
    float dx = 0.5 * (target.center.x - 160.0) / 160.0;
    target.center = CGPointMake(target.center.x + dx, target.center.y);
}

- (void)createTargets:(UIView *)view tagetRadian:(float)tagetRadian  moveSpeed:(float)moveSpeed okuyuki:(float)okuyuki
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:view,@"view",[NSNumber numberWithFloat:tagetRadian],@"tagetRadian", [NSNumber numberWithFloat:moveSpeed],@"moveSpeed",[NSNumber numberWithFloat:okuyuki],@"okuyuki", nil];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(target:) userInfo:dic repeats:YES];
}

- (void)pauseAnimation{
    if ([moveTimer isValid]) [moveTimer invalidate];
}

//- (void)hit:(UITapGestureRecognizer*)gr
//{
//    gr.view.backgroundColor = [self colorAtIndex:2];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        gr.view.center = CGPointMake(gr.view.center.x + 400, gr.view.center.y);
//    }];
//}

@end
