//
//  ExceptionArea.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/21.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExceptionArea : UIView

@property CGRect exceptionArea;
@property NSTimeInterval startTime;
@property NSTimeInterval endTime;
@property int iconTagNumber;

-(id)initWithData:(CGRect)exceptionArea startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime iconTagNumber:(int)iconTagNumber;

@end
