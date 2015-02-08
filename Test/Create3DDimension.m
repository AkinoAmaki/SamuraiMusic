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
    road = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groundImage.size.width, groundImage.size.height)];
    road.center = CGPointMake(view.center.x, roadHeight);
    CALayer *roadLayer = [CALayer layer];
    roadLayer.frame = CGRectMake(0, 0, groundImage.size.width, groundImage.size.height);
    roadLayer.contents = (id)groundImage.CGImage;
    [road.layer addSublayer:roadLayer];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / okuyuki * -1;
    //1.0 / - 200.0;
    baseTrans =  CATransform3DTranslate(baseTrans, 0, okuyuki * -1, 0);
    baseTrans =  CATransform3DRotate(transform, roadRadian, 1.0f, 0.0f, 0.0f);
    //0.42 * M_PI
    road.layer.transform = baseTrans;
    [view addSubview:road];
    
    
    leftWall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftWallImage.size.width, leftWallImage.size.height)];
    leftWall.center = CGPointMake(view.center.x - 100, roadHeight - leftWallImage.size.height / 2);
    //view.center.y + 150
    CALayer *leftLayer = [CALayer layer];
    leftLayer.frame = CGRectMake(0, 0, leftWallImage.size.width, leftWallImage.size.height);
    leftLayer.contents = (id)leftWallImage.CGImage;
    [leftWall.layer addSublayer:leftLayer];
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m34 = 1.0 / okuyuki * -1;
    baseTrans2 =  CATransform3DTranslate(baseTrans2, 0, okuyuki * -1, 0);
    baseTrans2 = CATransform3DRotate(transform2, wallRadian, 0.0f, 1.0f, 0.0f);
    //0.35 * M_PI
    leftWall.layer.transform = baseTrans2;
    [view addSubview:leftWall];
    
    rightWall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightWallImage.size.width, rightWallImage.size.height)];
    rightWall.center = CGPointMake(view.center.x + 100, roadHeight - rightWallImage.size.height / 2);
    //view.center.y + 150
    CALayer *rightLayer = [CALayer layer];
    rightLayer.frame = CGRectMake(0, 0, rightWallImage.size.width, rightWallImage.size.height);
    rightLayer.contents = (id)rightWallImage.CGImage;
    [rightWall.layer addSublayer:rightLayer];
    CATransform3D transform3 = CATransform3DIdentity;
    transform3.m34 = 1.0 / okuyuki * -1;
    baseTrans3 =  CATransform3DTranslate(baseTrans3, 0, okuyuki * -1, 0);
    baseTrans3 = CATransform3DRotate(transform3, wallRadian * -1, 0.0f, 1.0f, 0.0f);
    //-0.35 * M_PI
    rightWall.layer.transform = baseTrans3;
    [view addSubview:rightWall];
    
    road2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groundImage.size.width, groundImage.size.height)];
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
    
    leftWall2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftWallImage.size.width, leftWallImage.size.height)];
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
    
    rightWall2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightWallImage.size.width, rightWallImage.size.height)];
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
    
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:road, @"road",leftWall,@"leftWall" ,rightWall,@"rightWall",road2, @"road2", leftWall2, @"leftWall2", rightWall2, @"rightWall2", nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0/moveSpeed target:self selector:@selector(move:) userInfo:dic repeats:YES];
    //1.0/60.0
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
    
    target.backgroundColor = [self colorAtIndex:3];
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
    UIView *moveroad      = [(NSDictionary *)sender.userInfo objectForKey:@"road"];
    UIView *moveleftWall  = [(NSDictionary *)sender.userInfo objectForKey:@"leftWall"];
    UIView *moverightWall = [(NSDictionary *)sender.userInfo objectForKey:@"rightWall"];
    UIView *moveroad2 = [(NSDictionary *)sender.userInfo objectForKey:@"road2"];
    UIView *moveleftWall2 = [(NSDictionary *)sender.userInfo objectForKey:@"leftWall2"];
    UIView *moverightWall2 = [(NSDictionary *)sender.userInfo objectForKey:@"rightWall2"];
    
    moveroad.layer.transform   = CATransform3DTranslate(road.layer.transform, 0, 3, 0);
    moveleftWall.layer.transform   = CATransform3DTranslate(leftWall.layer.transform, -3, 0, 0);
    moverightWall.layer.transform   = CATransform3DTranslate(rightWall.layer.transform, 3, 0, 0);
    moveroad2.layer.transform   = CATransform3DTranslate(road2.layer.transform, 0, 3, 0);
    moveleftWall2.layer.transform   = CATransform3DTranslate(leftWall2.layer.transform, -3, 0, 0);
    moverightWall2.layer.transform   = CATransform3DTranslate(rightWall2.layer.transform, 3, 0, 0);
    
}


- (void)move2:(NSTimer*)sender
{
    UIView *target      = [(NSDictionary *)sender.userInfo objectForKey:@"target"];
    
    target.layer.transform = CATransform3DTranslate(target.layer.transform, 0, 0, -3);
    float dx = 0.5 * (target.center.x - 160.0) / 160.0;
    target.center = CGPointMake(target.center.x + dx, target.center.y);
}


- (UIColor*)colorAtIndex:(int)index
{
    // 001E4E	006AC1	001940	2C4566
    switch (index) {
        case 0:
            return UIColorHex(0x001E4E);
            break;
        case 1:
            return UIColorHex(0x006AC1);
            break;
        case 2:
            return UIColorHex(0x001940);
            break;
        case 3:
            return UIColorHex(0x2C4566);
            break;
        default:
            break;
    }
    return nil;
}

- (void)createTargets:(UIView *)view tagetRadian:(float)tagetRadian  moveSpeed:(float)moveSpeed okuyuki:(float)okuyuki
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:view,@"view",[NSNumber numberWithFloat:tagetRadian],@"tagetRadian", [NSNumber numberWithFloat:moveSpeed],@"moveSpeed",[NSNumber numberWithFloat:okuyuki],@"okuyuki", nil];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(target:) userInfo:dic repeats:YES];
}

//- (void)rin{
//    //2枚の背景を次々にアニメーションさせて背景の動きを実現する
//    UIImageView *backgroundImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ground"]];
//    UIImageView *backgroundImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ground"]];
//    [self.view addSubview:backgroundImageView1];
//    [self.view addSubview:backgroundImageView2];
//    
//    backgroundImageView1.frame = CGRectMake(0,   0, 320, 960);
//    backgroundImageView2.frame = CGRectMake(0, 960, 320, 960);
//    
//    [UIView animateWithDuration:10.0f delay:0.0f options:UIViewAnimationOptionCurveLinear                     animations:^{
//        // アニメーションをする処理
//        backgroundImageView1.frame = CGRectMake(0, -960, 320, 960);
//    }completion:^(BOOL finished){
//        backgroundImageView1.frame = CGRectMake(0, 960, 320, 960);
//        [UIView animateWithDuration:20.0f delay:0.0f options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear                     animations:^{
//            // アニメーションをする処理
//            backgroundImageView1.frame = CGRectMake(0, -960, 320, 960);
//        }completion:^(BOOL finished){
//            backgroundImageView1.frame = CGRectMake(0,  960, 320, 960);
//        }
//         ];
//    }
//     ];
//    
//    [UIView animateWithDuration:20.0f delay:0.0f options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         // アニメーションをする処理
//                         backgroundImageView2.frame = CGRectMake(0, -960, 320, 960);
//                     }completion:^(BOOL finished){
//                         backgroundImageView2.frame = CGRectMake(0, 960, 320, 960);
//                     }
//     ];
//}

//- (void)hit:(UITapGestureRecognizer*)gr
//{
//    gr.view.backgroundColor = [self colorAtIndex:2];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        gr.view.center = CGPointMake(gr.view.center.x + 400, gr.view.center.y);
//    }];
//}

@end
