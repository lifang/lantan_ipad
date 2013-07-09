//
//  RJFileUtils.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-27.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "RJFileUtils.h"

@implementation RJFileUtils


+ (NSString *)pathWithinDocumentDir:(NSString*)aPath
{	
	NSString *fullPath = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	if ([paths count] > 0) {
		fullPath = (NSString*)[paths objectAtIndex:0];
		if([aPath length] > 0) 
        {
			fullPath = [fullPath stringByAppendingPathComponent:aPath];
		}
	}
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:fullPath];
    if(!success){
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:aPath];
        
        [fileManager copyItemAtPath:databasePathFromApp toPath:fullPath error:nil];
        
        
    }
	return fullPath;
}

+ (BOOL)createDirectory:(NSString*)dirPath lastComponentIsDirectory:(BOOL)isDir 
{
	NSString* path = nil;
	if(isDir) 
    {
        path = dirPath;
    }
	else 
    {
        path = [dirPath stringByDeletingLastPathComponent];
    }
	
	if(dirPath && ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO))
    {
		NSError* error = nil;		
		BOOL ret;
		
		ret = [[NSFileManager defaultManager] createDirectoryAtPath:path
										withIntermediateDirectories:YES
														 attributes:nil
															  error:&error];				
		if(!ret && error) 
        {
			DLog(@"create directory failed at path '%@',error:%@,%@",dirPath,[error localizedDescription],[error localizedFailureReason]);
			return NO;
		}
	}
	return YES;
}

+ (BOOL)ensureDirectoryIsExist:(NSString*)dirPath lastComponentIsDirectory:(BOOL)isDir
{
    BOOL isDirectory = NO;
    if (YES == [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirectory])
    {
        if (isDir == isDirectory)
        {
            return YES;
        }
    }
    return [RJFileUtils createDirectory:dirPath lastComponentIsDirectory:isDir];
}
@end

#pragma mark - RJFileUtils(RJCategory_projectDepend)
@implementation RJFileUtils(RJCategory_projectDepend)
+ (NSString*)shopListDBPath
{
    NSString* path = @"order.sqlite";
    return [RJFileUtils pathWithinDocumentDir:path];
}
@end


