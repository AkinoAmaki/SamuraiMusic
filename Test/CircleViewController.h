//
//  CircleViewController.h
//  Samurai
//
//  Created by 秋乃雨弓 on 2015/02/06.
//  Copyright (c) 2015年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTableView.h"
#import "StageEditViewController.h"
#import "NewHumenCreate.h"

@interface CircleViewController : UIViewController<UITableViewDataSource,UIScrollViewDelegate,UITableViewDelegate>{
    IBOutlet BBTableView *mTableView;
    NSMutableArray *mDataSource;
    
    StageEditViewController *stageEditViewController;
    
    //ボタンタップ時の効果音
    CFBundleRef mainBundle;
    CFURLRef tapSoundURL;
    SystemSoundID tapSoundID;
}
@property(nonatomic, retain) NSMutableArray *stages; //全ての譜面名、曲名、曲の拡張子、譜面本体を収めた配列を格納

@end
