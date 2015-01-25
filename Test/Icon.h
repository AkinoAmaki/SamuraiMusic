//
//  Icon.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/18.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>

// デリゲートを定義
@protocol IconDelegate <NSObject>

// デリゲートメソッドを宣言
// （宣言だけしておいて，実装はデリゲート先でしてもらう）
+ (NSData *)serialize:(NSMutableArray *)iconArray;
+ (NSMutableArray *)deserialize:(NSData *)data;

@end

@interface Icon : UIView

@property int iconType; //1ならシングルタップ、2ならスワイプ、3ならロングプレス
@property CGPoint centerPoint; //アイコンのcenter
@property NSTimeInterval startTime; //アニメーション開始時間
@property NSTimeInterval endTime;   //アニメーション終了時間
@property int iconTagNumber;

-(id)initWithData:(CGPoint)center iconType:(int)iconType startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime iconTagNumber:(int)iconTagNumber;

// デリゲート先で参照できるようにするためプロパティを定義しておく
@property (nonatomic, assign) id<IconDelegate> delegate;

+ (NSData *)serialize:(NSMutableArray *)iconArray;
+ (NSMutableArray *)deserialize:(NSData *)data;

@end
