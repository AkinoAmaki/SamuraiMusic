//
//  ExceptionArea.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/21.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "ExceptionArea.h"

@implementation ExceptionArea

-(id)initWithData:(CGRect)exceptionArea startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime iconTagNumber:(int)iconTagNumber{
    self = [super init];
    if (self) {
        // Initialization code
        self.exceptionArea = exceptionArea;
        self.startTime = startTime;
        self.endTime = endTime;
        self.iconTagNumber = iconTagNumber;
    }
    return self;
}

@end
