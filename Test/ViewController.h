//
//  ViewController.h
//  Test
//
//  Created by 秋乃雨弓 on 2014/11/14.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Icon.h"
#import <GameKit/GameKit.h>

@interface ViewController : UIViewController<NSCoding, GKGameCenterControllerDelegate>{
    float singleTapGestureDuration;
    float panGestureDuration;
    float longPressGestureDuration;
    NSMutableArray *syokiStages;

}

@end

