//
//  AppDelegate.m
//  Test
//
//  Created by 秋乃雨弓 on 2014/11/14.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize font;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*-------------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------------*/
    /*-------------------------------デバッグモードここから------------------------------------*/
    /*-------------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------------*/

    
//    /*---------------------------NSUserDefaultの設定を全て削除--------------------------------*/
//    // アプリケーションのバンドル識別子を取得します。
//    NSString* domain = [[NSBundle mainBundle] bundleIdentifier];
//    // バンドル識別子を使って、アプリに関係する設定を一括消去します。
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domain];
//
//    /*---------------------------音楽ファイル、プロパティリストの削除----------------------------*/
//    //Documents/musicフォルダの音楽ファイルを全て削除する
//    FileHelper *file = [[FileHelper alloc] init];
//    NSArray *stringArray = [file fileNamesAtDirectoryPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"music"] extension:@"m4a"];
//    for (NSString *st in stringArray) {
//        NSString *path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"music"] stringByAppendingPathComponent:st];
//        [self removeFileByPath:path];
//    }
//
//    //Documents/propertyListフォルダのプロパティリストを削除する
//    FileHelper *file2 = [[FileHelper alloc] init];
//    NSArray *stringArray2 = [file2 fileNamesAtDirectoryPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"propertyList"] extension:@"plist"];
//    for (NSString *st in stringArray2) {
//        NSString *path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"propertyList"] stringByAppendingPathComponent:st];
//        [self removeFileByPath:path];
//    }
    
    /*-------------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------------*/
    /*-------------------------------デバッグモードここまで------------------------------------*/
    /*-------------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------------*/
    
    ud = [NSUserDefaults standardUserDefaults];
    firstLaunch =  [ud integerForKey:@"firstLaunch_ud"];
    
    NSLog(@"高さ：%f:幅：%f",[[UIScreen mainScreen] bounds].size.height,[[UIScreen mainScreen] bounds].size.width);
    
    if(firstLaunch == 0){
//        //ユニークなプレイヤーIDを発番する
//        //サーバ側で取得したIDを受け取り、playerIDとして保持する
//        [SVProgressHUD showWithStatus:@"データ通信中..." maskType:SVProgressHUDMaskTypeGradient];
//        NSString *url = @"http://utakatanet.dip.jp:58080/playerID.php";
//        NSMutableURLRequest *request;
//        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
//        [request setHTTPMethod:@"POST"];
//        NSURLResponse *response;
//        NSError *error;
//        NSData *result;
//        result= [NSURLConnection sendSynchronousRequest:request
//                                      returningResponse:&response
//                                                  error:&error];
//        
//        //データがgetできなければ、0.5秒待ったあとに再度get処理する
//        while (!result) {
//            [NSThread sleepForTimeInterval:0.5];
//            result= [NSURLConnection sendSynchronousRequest:request
//                                          returningResponse:&response
//                                                      error:&error];
//            NSLog(@"通信不可");
//        }
//        
//        NSString *string = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
//        [ud setObject:[NSNumber numberWithInt:[string intValue]] forKey:@"playerID_ud"];
//        [ud synchronize];
//        
//        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"firstLaunchSendPhase_ud"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        [SVProgressHUD popActivity];
//        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstLaunch_ud"];
        
    //曲名及び画像を納めるプロパティリストの作成
        //directoryフォルダの直下にpropertyListを作成
            // 作成するディレクトリのパスを作成
            NSString *dirPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"propertyList"];
            // ファイルマネージャを作成
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error;
            // ディレクトリを作成
            BOOL result = [fileManager createDirectoryAtPath:dirPath
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&error];
            //作成結果を判定
            if (result) {
                NSLog(@"ディレクトリの作成に成功：%@", dirPath);
            } else {
                NSLog(@"ディレクトリの作成に失敗：%@", error.description);
            }
        //propertyListフォルダにプロパティリストを保存
            NSString *propertyString = [dirPath stringByAppendingPathComponent:@"musicName.plist"];
            NSArray *propertyList = [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:@"新規作成", @"title", nil,@"image_name",nil,@"image",nil], nil];
            [propertyList writeToFile:propertyString atomically:YES];
            [propertyList writeToFile:@"/Users/AkinoAmaki/Desktop" atomically:YES];
    //曲ファイルを納めるフォルダの作成
        //directoryフォルダの直下にpropertyListを作成
        // 作成するディレクトリのパスを作成
        NSString *dirPath2 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"music"];
        // ファイルマネージャを作成
        NSFileManager *fileManager2 = [NSFileManager defaultManager];
        NSError *error2;
        // ディレクトリを作成
        BOOL result2 = [fileManager2 createDirectoryAtPath:dirPath2
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error2];
        //作成結果を判定
        if (result2) {
            NSLog(@"ディレクトリの作成に成功：%@", dirPath2);
        } else {
            NSLog(@"ディレクトリの作成に失敗：%@", error2.description);
        }
        
        //初期曲をリストに突っ込む
        NSMutableArray *nullArray = [[NSMutableArray alloc] init];
        
        //TODO: 初期曲を入れる
        //        //NSData型への変換は仕様上Iconクラスでしかできないので、とりあえず適用にIconクラスをインスタンス化してメソッド適用
        //        NSData *data = [Icon serialize:nullArray];
        //        NSArray *syokiArray = [[NSArray alloc] initWithObjects:@"humen1",@"Won't Go Home Without You Lyrics",@"mp3",data, nil];
        //        syokiStages = [[NSMutableArray alloc] initWithObjects:syokiArray, nil];
        //        [[NSUserDefaults standardUserDefaults] setObject:syokiStages forKey:@"stageArray"];
        //        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"first"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];


        
        [ud setInteger:1 forKey:@"firstLaunch_ud"];
        NSLog(@"初回起動");
    }


    
    // ナビゲーションコントローラにベースとなるコントローラをセット
    editStageSelect = [[EditStageSelect alloc] init];
    naviController = [[UINavigationController alloc]
                      initWithRootViewController:editStageSelect];
    
    // ナビゲーションコントローラのビューをウィンドウに貼付ける
    [self.window addSubview:naviController.view];
    [self.window makeKeyAndVisible];
    
    //統一して使用するフォントを初期設定
    font = [UIFont fontWithName:@"Tanuki-Permanent-Marker" size:[UIFont systemFontSize]];
    
    // インタースティシャル広告の実装
    // NADInterstitialはシングルトンパターンで実装されています。
    // 以下のように、sharedInstanceメッセージでインスタンスを取得できます。
    // TODO:現在、AAカードバトル用の広告を流用している。侍ミュージック用の広告枠を取り次第、ApiKeyとspotIdを変更する。
    [[NADInterstitial sharedInstance] loadAdWithApiKey:@"32a285a60095a6dcdff78eda42669a585804c707"
                                                spotId:@"240078"];
    
    return YES;
}

-(void)removeFileByPath:(NSString*)path{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        NSLog(@"no file");
        return;
    }
    NSError *error=nil;
    [fm removeItemAtPath:path error:&error];
    if (error!=nil) {//failed
        NSLog(@"failed to remove %@",[error localizedDescription]);
    }else{
        NSLog(@"Successfully removed:%@",path);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Akino.Test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Test" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Test.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
