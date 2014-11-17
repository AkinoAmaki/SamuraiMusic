//
//  DragForView.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/17.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "DragForView.h"

@implementation DragForView

- (id)initWithStartCenterPoint:(CGPoint)p{
    self = [super init];
    if (self) {
        // Initialization code
        initPoint = p;
        exceptionArea = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setDragAction:(UIView *)view{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [view addGestureRecognizer:pan];
}

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

-(void)setExceptionArea:(CGRect)rect{
    [exceptionArea addObject:[NSValue valueWithCGRect:rect]];
}

@end
