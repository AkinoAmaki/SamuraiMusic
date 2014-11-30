//
//  UniqueFileName.h
//  SamuraiMusic
//
//  Created by 秋乃雨弓 on 2014/11/30.
//  Copyright (c) 2014年 秋乃雨弓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniqueFileName : NSObject
+ (NSString*)getUniqueFileNameInDocumentDirectory:(NSString*)_name type:(NSString*)_type;
@end
