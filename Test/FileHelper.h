//
//  FileHelper.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/30.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject
/* tmp */
- (NSString*)temporaryDirectory;
/* /tmp/fileName */
- (NSString*)temporaryDirectoryWithFileName:(NSString*)fileName;

/* /Documents */
- (NSString*)documentDirectory;
/* /Documents/fileName */
- (NSString*)documentDirectoryWithFileName:(NSString*)fileName;

/* pathのファイルが存在しているか */
- (BOOL)fileExistsAtPath:(NSString*)path;

/* pathのファイルがelapsedTimeを超えているか */
- (BOOL)isElapsedFileModificationDateWithPath:(NSString*)path elapsedTimeInterval:(NSTimeInterval)elapsedTime;

/* directoryPath内のextension(拡張子)と一致する全てのファイル名 */
- (NSArray*)fileNamesAtDirectoryPath:(NSString*)directoryPath extension:(NSString*)extension;

/* pathのファイルを削除 */
- (BOOL)removeFilePath:(NSString*)path;
@end
