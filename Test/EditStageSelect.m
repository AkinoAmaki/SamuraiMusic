//
//  EditStageSelect.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/23.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "EditStageSelect.h"

@implementation EditStageSelect
@synthesize editStageMenu;
@synthesize stages;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    editStageMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    editStageMenu.delegate = self;
    editStageMenu.dataSource = self;
    [self.view addSubview:editStageMenu];
    
    
    stages = [[NSUserDefaults standardUserDefaults] objectForKey:@"stageArray"];

    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                             target:self action:@selector(returnToMainView)];
    self.navigationItem.leftBarButtonItem = btn;
}

- (void)returnToMainView{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [stages count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"ステージセレクト"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if(indexPath.row < [stages count]){
        NSString *humenName = [[stages objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.textLabel.text = humenName;
    }else{
        cell.textLabel.text = @"新規作成";
    }
    
    
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
    if(indexPath.row < [stages count]){
        //既存譜面の編集の場合
        stageEditViewController = [[StageEditViewController alloc] init];
        stageEditViewController.stageNumber = (int)indexPath.row;
        stageEditViewController.mountOfStages = (int)[stages count];
        stageEditViewController.stages = [[NSMutableArray alloc] initWithArray:self.stages];
        stageEditViewController.newHumen = NO;
        NSLog(@"ステージナンバー:%d",stageEditViewController.stageNumber);
        NSLog(@"ステージ数:%d",stageEditViewController.mountOfStages);
    [self presentViewController:stageEditViewController animated:YES completion:nil];
    }else{
        //新規作成の場合
        NewHumenCreate *newHumen = [[NewHumenCreate alloc] initWithStyle:UITableViewStylePlain stages:stages];
        [self presentViewController:newHumen animated:YES completion:nil];
    }
    // セルの選択を解除する
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
