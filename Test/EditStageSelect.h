//
//  EditStageSelect.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/23.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StageEditViewController.h"
#import "NewHumenCreate.h"

@interface EditStageSelect : UITableViewController<UITableViewDataSource, UITableViewDelegate>{
    StageEditViewController *stageEditViewController;
}
@property(nonatomic, strong)UITableView *editStageMenu;
@property(nonatomic, retain) NSMutableArray *stages; //全ての譜面名、曲名、曲の拡張子、譜面本体を収めた配列を格納


@end
