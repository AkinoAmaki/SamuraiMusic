//
//  Create3DDimension.h
//  Samurai
//
//  Created by 秋乃雨弓 on 2015/02/03.
//  Copyright (c) 2015年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Create3DDimension : UIView{
    UIView *road;
    UIView *leftWall;
    UIView *rightWall;
    UIView *road2;
    UIView *leftWall2;
    UIView *rightWall2;
    CATransform3D baseTrans;
    CATransform3D baseTrans2;
    CATransform3D baseTrans3;
}

- (void)createGround:(UIView *)view groundImage:(UIImage *)groundImage rightWallImage:(UIImage *)rightWallImage leftWallImage:(UIImage *)leftWallImage roadHeight:(int)roadHeight roadRadian:(float)roadRadian wallRadian:(float)wallRadian moveSpeed:(float)moveSpeed okuyuki:(float)okuyuki;
- (void)move:(NSTimer*)sender;
- (void)createTargets:(UIView *)view tagetRadian:(float)tagetRadian  moveSpeed:(float)moveSpeed okuyuki:(float)okuyuki;
- (void)move2:(NSTimer*)sender;


@end
