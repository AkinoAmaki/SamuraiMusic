//
//  StageSelectCircleViewController.h
//  Samurai
//
//  Created by 秋乃雨弓 on 2015/02/07.
//  Copyright (c) 2015年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTableView.h"
#import "MainViewController.h"

@interface StageSelectCircleViewController : UIViewController<UITableViewDataSource,UIScrollViewDelegate>{
    IBOutlet BBTableView *mTableView;
    NSMutableArray *mDataSource;
    MainViewController *mainViewController;
}
@property(nonatomic, retain) NSMutableArray *stages; //全ての譜面名、曲名、曲の拡張子、譜面本体を収めた配列を格納

@end
