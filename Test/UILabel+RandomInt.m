//
//  UILabel+RandomInt.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2015/01/10.
//  Copyright (c) 2015年 秋乃雨弓. All rights reserved.
//

#import "UILabel+RandomInt.h"

@implementation UILabel (RandomInt)

+(void) randomInt:(UILabel *)label ketasuu:(int)ketasuu keizokuJikan:(NSTimeInterval)keizokuJikan lastScore:(int)lastScore{
    //スコアは右揃えで表示
    label.textAlignment = NSTextAlignmentRight;
    
    int i = keizokuJikan * 10; //ランダム表示する回数
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat:ketasuu], @"ketasuu", label, @"label", [NSNumber numberWithInt:lastScore], @"lastScore",nil];
    // タイマーを生成
    for (int j = 0; j <= i; j++) {
        if (j < i) {
            [NSTimer scheduledTimerWithTimeInterval:0.1 + ((float)j / 10)
                                             target:self
                                           selector:@selector(doTimer:)
                                           userInfo:userInfo
                                            repeats:NO
             ];
        }else{
            //最後はlastScoreを表示する
            [NSTimer scheduledTimerWithTimeInterval:0.1 + ((float)j / 10)
                                             target:self
                                           selector:@selector(doTimer2:)
                                           userInfo:userInfo
                                            repeats:NO
             ];
        }
    }
}

+ (void)doTimer:(NSTimer *)timer{
    //timerのuserInfoから各種数値を取得
    int ketasuu = [[(NSDictionary *)timer.userInfo objectForKey:@"ketasuu"] intValue];
    UILabel *label = [UILabel new];
    label = [(NSDictionary *)timer.userInfo objectForKey:@"label"];
    
    int i = arc4random() % 10000000;
    //ランダム生成した数値が求められる桁数以下の数値であった場合、もう一度生成し直す
    while (i < (10^(ketasuu - 1))) {
        i = arc4random() % 10000000;
    }
    label.text = [NSString stringWithFormat:@"%d",i];
}

+ (void)doTimer2:(NSTimer *)timer{
    //timerのuserInfoから最終的に表示したいスコアを取得
    int lastScore = [[(NSDictionary *)timer.userInfo objectForKey:@"lastScore"] intValue];
    UILabel *label = [UILabel new];
    label = [(NSDictionary *)timer.userInfo objectForKey:@"label"];
    label.text = [NSString stringWithFormat:@"%d",lastScore];
}

@end
