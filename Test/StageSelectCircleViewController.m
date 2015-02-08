//
//  StageSelectCircleViewController.m
//  Samurai
//
//  Created by 秋乃雨弓 on 2015/02/07.
//  Copyright (c) 2015年 秋乃雨弓. All rights reserved.
//

#import "StageSelectCircleViewController.h"
#import "BBCell.h"
#import <QuartzCore/QuartzCore.h>

//Keys used in the plist file to read the data for the table
#define KEY_TITLE @"title"
#define KEY_IMAGE_NAME @"image_name"
#define KEY_IMAGE @"image"


@interface StageSelectCircleViewController ()
-(void)setupShapeFormationInVisibleCells;
-(void)loadDataSource;
-(float)getDistanceRatio;
@end

@implementation StageSelectCircleViewController
@synthesize stages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //CircleViewの実装
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.opaque=NO;
    mTableView.showsHorizontalScrollIndicator=NO;
    mTableView.showsVerticalScrollIndicator=YES;
    mTableView.enableInfiniteScrolling = NO;
    
    UILabel *mainTitle = (UILabel*) [self.view viewWithTag:100];
    mainTitle.text = @"CRICKET \n LEGENDS";
    [self loadDataSource];

    //メイン画面に戻るボタンの実装
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 10, 100, 30);
    [btn setTitle:@"押してね" forState:UIControlStateNormal];
    [btn setTitle:@"ぽち" forState:UIControlStateHighlighted];
    [btn setTitle:@"押せません" forState:UIControlStateDisabled];
    // ボタンがタッチダウンされた時にhogeメソッドを呼び出す
    [btn addTarget:self action:@selector(returnToMainView)
  forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    
    //ステージ情報を格納
    stages = [[NSUserDefaults standardUserDefaults] objectForKey:@"stageArray"];

    
    // 通知センターにオブザーバ（通知を受け取るオブジェクト）を追加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnToStageSelect) name:@"returnToStageSelect" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnToMainView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //we need to update the cells as the table might have changed its dimensions after rotation
    // [self setupShapeFormationInVisibleCells];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //update the cells to form the circle shape
    //[self setupShapeFormationInVisibleCells];
}

#pragma mark UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"mDataSource:%d",[mDataSource count]);
    return  [mDataSource count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *test = @"table";
    BBCell *cell = (BBCell*)[tableView dequeueReusableCellWithIdentifier:test];
    if( !cell )
    {
        cell = [[BBCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:test];
    }
    NSDictionary *info = [mDataSource objectAtIndex:indexPath.row ];
    [cell setCellTitle:[info objectForKey:KEY_TITLE]];
    //MARK: 選択肢にアイコン画像を入れることになった場合はこの部分のコメントアウトを解除する    [cell setIcon:[info objectForKey:KEY_IMAGE]];
    return cell;
}

//read the data from the plist and alos the image will be masked to form a circular shape
- (void)loadDataSource
{
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithContentsOfFile:[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"propertyList"] stringByAppendingPathComponent:@"musicName.plist"]];
    [dataSource removeObject:[dataSource lastObject]];
    
    NSLog(@"count:%d",[dataSource count]);
    
    mDataSource = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //generate image clipped in a circle
        for( NSDictionary * dataInfo in dataSource )
        {
            NSMutableDictionary *info = [dataInfo mutableCopy];
            //MARK: 選択肢にアイコン画像を入れることになった場合はこの部分のコメントアウトを解除する
            //            UIImage *image = [UIImage imageNamed:[info objectForKey:KEY_IMAGE_NAME]];
            //            UIImage *image = [UIImage imageNamed:@"error"];
            //            UIImage *finalImage = nil;
            //            UIGraphicsBeginImageContext(image.size);
            //            {
            //                CGContextRef ctx = UIGraphicsGetCurrentContext();
            //                CGAffineTransform trnsfrm = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0, -1.0));
            //                trnsfrm = CGAffineTransformConcat(trnsfrm, CGAffineTransformMakeTranslation(0.0, image.size.height));
            //                CGContextConcatCTM(ctx, trnsfrm);
            //                CGContextBeginPath(ctx);
            //                CGContextAddEllipseInRect(ctx, CGRectMake(0.0, 0.0, image.size.width, image.size.height));
            //                CGContextClip(ctx);
            //                CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, image.size.width, image.size.height), image.CGImage);
            //                finalImage = UIGraphicsGetImageFromCurrentImageContext();
            //                UIGraphicsEndImageContext();
            //            }
            //    [info setObject:finalImage forKey:KEY_IMAGE];
            
            [mDataSource addObject:info];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mTableView reloadData];
            // [self setupShapeFormationInVisibleCells];
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //曲・譜面等をセットして演奏開始
    
    mainViewController = [[MainViewController alloc] init];
    mainViewController.stageNumber = (int)indexPath.row;
    mainViewController.stages = [[NSMutableArray alloc] initWithArray:self.stages];
    [self presentViewController:mainViewController animated:YES completion:nil];

    // セルの選択を解除する
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)returnToStageSelect{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
