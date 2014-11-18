//
//  Icon.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/18.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "Icon.h"

@implementation Icon

-(id)initWithData:(CGPoint)center iconType:(int)iconType startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime{
    self = [super init];
        if (self) {
            // Initialization code
            self.center = center;
            self.iconType = iconType;
            self.startTime = startTime;
            self.endTime = endTime;
    }
    return self;
}

@end
