//
//  ExceptionArea.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/21.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "ExceptionArea.h"

@implementation ExceptionArea
@synthesize exceptionArea;
@synthesize startTime;
@synthesize endTime;
@synthesize iconTagNumber;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeCGRect:exceptionArea forKey:@"exceptionArea"];
    [encoder encodeDouble:startTime forKey:@"startTime"];
    [encoder encodeDouble:endTime forKey:@"endTime"];
    [encoder encodeInt:iconTagNumber forKey:@"iconTagNumber"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self){
        exceptionArea = [aDecoder decodeCGRectForKey:@"exceptionArea"];
        startTime = [aDecoder decodeDoubleForKey:@"startTime"];
        endTime = [aDecoder decodeDoubleForKey:@"endTime"];
        iconTagNumber = [aDecoder decodeIntForKey:@"iconTagNumber"];
    }
    return self;
}


-(id)initWithData:(CGRect)exception startTime:(NSTimeInterval)start endTime:(NSTimeInterval)end iconTagNumber:(int)iconTag{
    self = [super init];
    if (self) {
        // Initialization code
        self.exceptionArea = exception;
        self.startTime = start;
        self.endTime = end;
        self.iconTagNumber = iconTag;
    }
    return self;
}

@end
