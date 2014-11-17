//
//  DragForView.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/17.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragForView : UIView{
    CGPoint initPoint;
    NSMutableArray *exceptionArea;
}

- (id)initWithStartCenterPoint:(CGPoint)p;
- (void)setDragAction:(UIView *)view;

@end
