//
//  Icon.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/18.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "Icon.h"

@implementation Icon
@synthesize iconType;
@synthesize centerPoint;
@synthesize startTime;
@synthesize endTime;
@synthesize iconTagNumber;
@synthesize deserializedIconArray;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:iconType forKey:@"iconType"];
    [encoder encodeCGPoint:centerPoint forKey:@"centerPoint"];
    [encoder encodeDouble:startTime forKey:@"startTime"];
    [encoder encodeDouble:endTime forKey:@"endTime"];
    [encoder encodeInt:iconTagNumber forKey:@"iconTagNumber"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self){
        iconType = [aDecoder decodeIntForKey:@"iconType"];
        centerPoint = [aDecoder decodeCGPointForKey:@"centerPoint"];
        startTime = [aDecoder decodeDoubleForKey:@"startTime"];
        endTime = [aDecoder decodeDoubleForKey:@"endTime"];
        iconTagNumber = [aDecoder decodeIntForKey:@"iconTagNumber"];
    }
    return self;
}

-(id)initWithData:(CGPoint)center iconType:(int)type startTime:(NSTimeInterval)sTime endTime:(NSTimeInterval)eTime iconTagNumber:(int)tagNumber{
    self = [super init];
        if (self) {
            // Initialization code
            self.centerPoint = center;
            self.iconType = type;
            self.startTime = sTime;
            self.endTime = eTime;
            self.iconTagNumber = tagNumber;
    }
    return self;
}

- (NSData *)serialize:(NSMutableArray *)iconArray{
    NSData* iconData = [NSKeyedArchiver archivedDataWithRootObject:iconArray];
    return iconData;
}
- (NSMutableArray *)deserialize:(NSData *)data{
    
    deserializedIconArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@",deserializedIconArray);
    return deserializedIconArray;
}

@end
