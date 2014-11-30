//
//  ViewController.h
//  Test
//
//  Created by 秋乃雨弓 on 2014/11/14.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Icon.h"

@interface ViewController : UIViewController<NSCoding>{
    float singleTapGestureDuration;
    float panGestureDuration;
    float longPressGestureDuration;
    NSMutableArray *syokiStages;

}

@end

