//
//  RJFileUtils.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-27.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJFileUtils : NSObject

+ (NSString*)pathWithinDocumentDir:(NSString*)aPath;
+ (BOOL)createDirectory:(NSString*)dirPath lastComponentIsDirectory:(BOOL)isDir;
+ (BOOL)ensureDirectoryIsExist:(NSString*)dirPath lastComponentIsDirectory:(BOOL)isDir;
@end


@interface RJFileUtils(RJCategory_projectDepend)
+ (NSString*)shopListDBPath;
@end