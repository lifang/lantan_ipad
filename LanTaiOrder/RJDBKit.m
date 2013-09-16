
//
//  RJDBKit.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-27.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//
#import "RJDBKit.h"

#pragma mark - RJDBEngine
@implementation RJDBKit

- (void)dealloc
{
    [_path release];
    
    [super dealloc];
}

- (id)initWithPath:(NSString*)aPath
{
    if (nil == aPath)
		return nil;
	
	if (!(self = [super init]))
		return nil;
	
	_path = [[NSString alloc] initWithString:aPath];
	_db = nil;
//	DLog(@"###%@",_path);
	return self;
}

- (BOOL)open
{
    if (_db)
		return YES;
	
	if (nil == _path)
		return NO;
	
	NSInteger ret = sqlite3_open([_path UTF8String], &_db);
	if (SQLITE_OK != ret) {
		DLog(@"RJDBEngine Error=%d: Failed to open database(%@)", ret, _path);
		return NO;
	}
	return YES;	
}
- (BOOL)insertOrUpdateUser:(NSString *)sql{
    if (nil == _db || nil == sql)
		return NO;
    char *errorMsg;
    if (sqlite3_exec(_db, [sql UTF8String], NULL,NULL,&errorMsg) != SQLITE_OK) {
        DLog(@"Insert or update is failed!");
        return NO;
    }else{
        DLog(@"Insert or update successfully!");
        return YES;
    }
    sqlite3_close(_db);
        
    return YES;
}
- (BOOL)close
{
    if (nil == _db)
		return YES;
	
	NSInteger ret = sqlite3_close(_db);
	if (SQLITE_OK != ret) {
		DLog(@"RJDBEngine Error=%d: Failed to close database(%@)", ret, _path);
		return NO;
	}
	
	_db = nil;
	return YES;
}
//添加数据
- (BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param {
    if (nil == _db || nil == sql)
		return NO;
    sqlite3_stmt *statement = nil;
    int success = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        DLog(@"Error: failed to prepare");
        return NO;
    }
    //绑定参数
    NSInteger max = [param count];
    for (int i=0; i<max; i++) {
        NSString *temp = [param objectAtIndex:i];
        sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
    }
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        DLog(@"添加数据===> 失败");
        return NO;
    }
//    sqlite3_close(_db);
    DLog(@"添加数据===> 成功");
    return TRUE;
}

- (RJDbRecordSet*) sqlQuery:(NSString*)aQurey
{
    if (nil == _db || nil == aQurey)
		return nil;
	sqlite3_stmt *stmt;
    NSInteger ret = sqlite3_prepare_v2(_db, [aQurey UTF8String], -1, &stmt, NULL);
	if (SQLITE_OK != ret) {
        DLog(@"RJDBEngine Error=%d: failed to prepare statement in sqlQuery(%@)", ret, aQurey);
		return nil;
	}
	
	RJDbRecordSet *rs = [[[RJDbRecordSet alloc] initWithStmt:stmt] autorelease];
	return rs;
}

- (BOOL) sqlCommand:(NSString*)aCommand
{
    if (nil == _db || nil == aCommand)
		return NO;
	
	sqlite3_stmt *stmt;
	NSInteger ret = sqlite3_prepare_v2(_db, [aCommand UTF8String], -1, &stmt, nil);
	if (ret != SQLITE_OK) {
        DLog(@"RJDBEngine Error=%d: failed to prepare statement in sqlCommand(%@)", ret, aCommand);
        return NO;
    }
	
    ret = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    if (ret != SQLITE_DONE) {
		DLog(@"RJDBEngine Error=%d: failed to step statement in sqlCommand(%@)", ret, aCommand);
		return NO;
	}
	return YES;
}

- (NSInteger) getLastErrorCode
{
	if (nil == _db)
		return -1;
	NSInteger ret = sqlite3_errcode(_db);
	return ret;
}

- (NSString*) getLastErrorMsg
{
	if (nil == _db)
		return nil;
	const char *utf8_errmsg = sqlite3_errmsg(_db);
	if (!utf8_errmsg)
		return nil;
	NSString *ret = [NSString stringWithUTF8String:utf8_errmsg];
	return ret;
}

@end

#pragma mark - RJDbRecordSet
@implementation RJDbRecordSet
- (id) initWithStmt:(sqlite3_stmt*)aStmt
{
	if (!aStmt)
		return nil;
	if (!(self = [super init]))
		return nil;
    
	_stmt = aStmt;
	return self;
}

- (void) dealloc
{
	_stmt = nil;
	
	[super dealloc];
}

- (BOOL) next
{
	if (!_stmt) 
		return NO;
	
	if (SQLITE_ROW == sqlite3_step(_stmt))	
		return YES;
	return NO;
}

- (void) close
{
	if (!_stmt)
		return;
	
	sqlite3_finalize(_stmt);
}

- (NSInteger) columnCount
{
	if (!_stmt)
		return 0;
    
	NSInteger count = sqlite3_data_count(_stmt);
	return count;
}

- (NSInteger) columnInteger:(NSInteger)aCol
{
	if (!_stmt) {
		[NSException raise:@"RJDBError" format:@"RJDbRecord not set statement"];
	}
	
	NSInteger ret = sqlite3_column_int(_stmt, aCol);
	return ret;
}

- (NSString*) columnString:(NSInteger)aCol
{
	if (!_stmt) {
        DLog(@"_stmt is nil");
		[NSException raise:@"RJDBError" format:@"RJDbRecord not set statement"];
	}
	
	const unsigned char *value = sqlite3_column_text(_stmt, aCol);
	if (!value)
		return nil;
	
	NSString *ret = [NSString stringWithUTF8String:(const char*)value];
	return ret;
}

- (double) columnDouble:(NSInteger)aCol
{
	if (!_stmt) {
		[NSException raise:@"RJDBError" format:@"RJDbRecord not set statement"];
	}
	
	double ret = sqlite3_column_double(_stmt, aCol);
	return ret;					  
}
@end
