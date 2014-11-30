//
//  NewHumenCreate.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/25.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "NewHumenCreate.h"

@implementation NewHumenCreate
@synthesize musicMenu;
@synthesize stages;


- (id)initWithStyle:(UITableViewStyle)style stages:(NSMutableArray *)arr
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.stages = [[NSMutableArray alloc] initWithArray:arr];
        
        //各セクション名と曲名用の配列の初期化
        sectionPlayList = [[NSMutableArray alloc] init];
        playListSongs = [[NSMutableDictionary alloc]init];
        
        //iPhoneの音楽ライブラリから取得
        MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
        NSArray *playlists = [myPlaylistsQuery collections];
        
        for (MPMediaPlaylist *playlist in playlists) {
            
            //section名を配列にセット
            [sectionPlayList addObject:[playlist valueForProperty: MPMediaPlaylistPropertyName]];
            
            //各sectionにぶらさがる曲名用の配列を初期化
            sectionSongs  = [[NSMutableArray alloc] init];
            
            for (MPMediaItem *song in [playlist items]) {
                
                //曲情報を配列にセット(曲ID、曲名等)
                NSString *temp = [[song valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
                temp = [temp substringWithRange:NSMakeRange([temp length] - 26, 3)];
                
                NSArray* cellDataArray = [[NSArray alloc]init];
                cellDataArray = [NSArray arrayWithObjects:[song valueForProperty: MPMediaItemPropertyPersistentID], [song valueForProperty: MPMediaItemPropertyTitle], temp, [song valueForKey:MPMediaItemPropertyAssetURL], nil];
                
                [sectionSongs addObject:cellDataArray];
                
            }
            
            //1section分のデータができたので、全体テーブル用の配列にセット
            [playListSongs setObject:sectionSongs forKey:[playlist valueForProperty: MPMediaPlaylistPropertyName]];
            
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    musicMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    musicMenu.delegate = self;
    musicMenu.dataSource = self;
    [self.view addSubview:musicMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSzectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionPlayList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id key = [sectionPlayList objectAtIndex:section];
    return [[playListSongs objectForKey:key]count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [sectionPlayList objectAtIndex:section];
//    return [NSString stringWithFormat:@"使用する曲を選んでください"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.textColor = [UIColor blackColor];//セルのテキストカラー変更
    cell.detailTextLabel.textColor = [UIColor grayColor];//セルの詳細テキストのカラー変更
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];//セルのフォント変更
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];//セルの詳細テキストのフォント変更
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//セルのアクセサリ設定
    
    //セルにデータの割り当て
    cell.textLabel.text =  [[[playListSongs objectForKey:[sectionPlayList objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row]objectAtIndex:1];
    
    
    // Configure the cell...
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //使える拡張子を限定し、それ以外を弾く。（とりあえずいまのところmp3とm4aのみ指定している。）
    //曲名および拡張子を格納
    kyokumei = [[[playListSongs objectForKey:[sectionPlayList objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row]objectAtIndex:1];
    kakutyoushi = [[[playListSongs objectForKey:[sectionPlayList objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row]objectAtIndex:2];
    urlAsset = [AVURLAsset URLAssetWithURL:[[[playListSongs objectForKey:[sectionPlayList objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row]objectAtIndex:3] options:nil];
    
    if ([kakutyoushi isEqualToString:@"mp3"] || [kakutyoushi isEqualToString:@"MP3"] || [kakutyoushi isEqualToString:@"m4a"] || [kakutyoushi isEqualToString:@"M4A"]) {
        //タップした曲をdirectoryに保存する
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:urlAsset
                                               presetName:AVAssetExportPresetAppleM4A];
        exportSession.outputFileType = [[exportSession supportedFileTypes] objectAtIndex:0];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [docDir stringByAppendingPathComponent:[UniqueFileName getUniqueFileNameInDocumentDirectory:kyokumei type:@"m4a"]];
        exportSession.outputURL = [NSURL fileURLWithPath:filePath];
        
        NSLog(@"曲名　：%@", kyokumei);
        NSLog(@"拡張子：%@", kakutyoushi);
        NSLog(@"パス　：%@", filePath);
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                NSLog(@"export session completed");
            } else {
                NSLog(@"export session error");
            }
            
            //待機を解除
            finished = YES;
        }];
        
        
        //音楽データのエクスポート処理が終わるまで待機
        finished = NO;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        while(!finished) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        }

        [SVProgressHUD dismiss];
        //新規作成したステージをstagesに格納
        NSMutableArray *nullArray = [[NSMutableArray alloc] init];
        Icon *icon = [[Icon alloc] init];
        NSData *data = [icon serialize:nullArray];
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:@"humenxxx", kyokumei, kakutyoushi, data, filePath, nil];
        NSLog(@"FILEPATH:%@",filePath);
        [stages addObject:tempArray];
        [[NSUserDefaults standardUserDefaults] setObject:stages forKey:@"stageArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //stageEditViewControllerをモーダルビューで表示
        stageEditViewController = [[StageEditViewController alloc] init];
        stageEditViewController.stageNumber = (int)[stages count] - 1;
        stageEditViewController.mountOfStages = (int)[stages count];
        stageEditViewController.stages = [[NSMutableArray alloc] initWithArray:self.stages];
        stageEditViewController.musicPath = filePath;
        stageEditViewController.newHumen = YES;
        NSLog(@"ステージナンバー:%d",stageEditViewController.stageNumber);
        NSLog(@"ステージ数:%d",stageEditViewController.mountOfStages);
        [self presentViewController:stageEditViewController animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"使用不可" message:[NSString stringWithFormat:@"%@の拡張子は使用できません。使用できる拡張子はmp3及びm4aです",kakutyoushi] delegate:self cancelButtonTitle:nil otherButtonTitles:@"選びなおす", nil];
        [alert show];
    }
    
     // セルの選択を解除する
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}


@end