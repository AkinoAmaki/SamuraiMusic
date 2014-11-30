//
//  NewHumenCreate.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/25.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Icon.h"
#import <MediaPlayer/MediaPlayer.h>
#import "StageEditViewController.h"
#import "UniqueFileName.h"
#import "SVProgressHUD.h"


@interface NewHumenCreate : UITableViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray* sectionPlayList;
    NSMutableArray* sectionSongs;
    NSMutableDictionary* playListSongs;
    MPMusicPlayerController *player;
    StageEditViewController *stageEditViewController;
//    UIAlertView *humenNameAlertView;
//    UITextField *humenNameTextField;
    NSString *kyokumei;
    NSString *kakutyoushi;
    AVURLAsset *urlAsset;
    BOOL finished;
}
@property(nonatomic, strong)UITableView *musicMenu;
@property(nonatomic, retain) NSMutableArray *stages; //全ての譜面名、曲名、曲の拡張子、譜面本体を収めた配列を格納

- (id)initWithStyle:(UITableViewStyle)style stages:(NSMutableArray *)arr;

@end
