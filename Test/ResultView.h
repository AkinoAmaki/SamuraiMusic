//
//  ResultView.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/12/26.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Origin.h"
#import "UILabel+RandomInt.h"
#import "AAButton.h"
#import <GameKit/GameKit.h>

@interface ResultView : UIViewController<GKGameCenterControllerDelegate>{
    UILabel *scoreLabel;
    UIImageView *pggb; //Perfect Great Good Bad の回数を表示する
    UIImageView *hantei;
    UIImageView *returnToMusicSelectView;
    UIImageView *returnToMainView;
    UIImageView *repeatThisMusic;
    
    
    UIImageView *perfect;  //perfectの画像
    UIImageView *great;    //greatの画像
    UIImageView *good;     //goodの画像
    UIImageView *bad;      //badの画像
    UILabel *perfectNum;   //perfectの回数
    UILabel *greatNum;     //greatの回数
    UILabel *goodNum;      //goodの回数
    UILabel *badNum;       //badの回数
}

@property (nonatomic) int score;
@property (nonatomic) int maxScore;
@property (nonatomic) int perfectNumber;
@property (nonatomic) int greatNumber;
@property (nonatomic) int goodNumber;
@property (nonatomic) int badNumber;

- (id)initWithData:(int)s maxScore:(int)m perfectNum:(int)p greatNum:(int)gr goodNum:(int)go missNum:(int)b;

@end
