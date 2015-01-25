//
//  ExceptionArea.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/21.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>

// デリゲートを定義
@protocol ExceptionAreaDelegate <NSObject>

// デリゲートメソッドを宣言
// （宣言だけしておいて，実装はデリゲート先でしてもらう）
+ (NSData *)serialize:(NSMutableArray *)iconArray;
+ (NSMutableArray *)deserialize:(NSData *)data;

@end


@interface ExceptionArea : UIView

@property CGRect exceptionArea;
@property NSTimeInterval startTime;
@property NSTimeInterval endTime;
@property int iconTagNumber;

-(id)initWithData:(CGRect)exceptionArea startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime iconTagNumber:(int)iconTagNumber;

// デリゲート先で参照できるようにするためプロパティを定義しておく
@property (nonatomic, assign) id<ExceptionAreaDelegate> delegate;

+ (NSData *)serialize:(NSMutableArray *)iconArray;
+ (NSMutableArray *)deserialize:(NSData *)data;


@end
