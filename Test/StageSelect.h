//
//  StageSelect.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/12/23.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface StageSelect : UITableViewController<UITableViewDataSource, UITableViewDelegate>{
    MainViewController *mainViewController;
}
@property(nonatomic, strong)UITableView *stageMenu;
@property(nonatomic, retain) NSMutableArray *stages; //全ての譜面名、曲名、曲の拡張子、譜面本体を収めた配列を格納

@end
