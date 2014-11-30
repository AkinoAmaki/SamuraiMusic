//
//  UniqueFileName.m
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/30.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import "UniqueFileName.h"

@implementation UniqueFileName
+ (NSString*)getUniqueFileNameInDocumentDirectory:(NSString*)_name type:(NSString*)_type {
    
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,YES);
    NSString *documentDirectory = [filePaths objectAtIndex:0];
    
    NSString* fileName = [NSString stringWithFormat:@"%@.%@", _name, _type];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    int i = 1;
    
    while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        ++i;
        filePath = [NSString stringWithFormat:@"%@/%@-%d.%@", documentDirectory, _name, i, _type];
        fileName = [NSString stringWithFormat:@"%@-%d.%@", _name, i, _type];
    }
    
    return fileName;
}
@end
