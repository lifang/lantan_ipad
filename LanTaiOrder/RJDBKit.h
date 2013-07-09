//
//  RJDBKit.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-27.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

//
//RJDBEngine
//
@class RJDbRecordSet;
@interface RJDBKit : NSObject
{
    sqlite3* _db;
    NSString* _path;
}
- (id)initWithPath:(NSString*)aPath;
- (BOOL)open;
- (BOOL)close;
- (RJDbRecordSet*) sqlQuery:(NSString*)aQurey;
- (BOOL) sqlCommand:(NSString*)aCommand;
- (NSInteger) getLastErrorCode;
- (NSString*) getLastErrorMsg;
- (BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param;
- (BOOL)insertOrUpdateUser:(NSString *)sql;
@end

//
//RJDbRecordSet
//
@interface RJDbRecordSet : NSObject {
	sqlite3_stmt		*_stmt;
}

- (id) initWithStmt:(sqlite3_stmt*)aStmt;
- (BOOL) next;
- (void) close;

// must execute next first
- (NSInteger) columnCount;

- (NSInteger) columnInteger:(NSInteger)aCol;
- (NSString*) columnString:(NSInteger)aCol;
- (double) columnDouble:(NSInteger)aCol;
@end