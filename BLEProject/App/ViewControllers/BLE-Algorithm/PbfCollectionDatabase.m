////
////  PbfCollectionDatabase.m
////  BLEProject
////
////  Created by innerpeacer on 2017/5/5.
////  Copyright © 2017年 innerpeacer. All rights reserved.
////
//
//#import "PbfCollectionDatabase.h"
//#import <sqlite3.h>
//
//#define PBF_COLLECTION_DATABASE_TABLE @"DATA_COLLECTION"
//
//#define PBF_COLLECTION_DATABASE_FIELD_PRIMARY_ID @"_id"
//#define PBF_COLLECTION_DATABASE_FIELD_ID @"dataID"
//#define PBF_COLLECTION_DATABASE_FIELD_TYPE @"type"
//#define PBF_COLLECTION_DATABASE_FIELD_DATA @"data"
//#define PBF_COLLECTION_DATABASE_FIELD_DESCRIPTION @"description"
////#define PBF_COLLECTION_DATABASE_FIELD_ @""
//
//@interface PbfCollectionDatabase()
//{
//    sqlite3 *_database;
//    NSString *_dbPath;
//}
//@end
//
//@implementation PbfCollectionDatabase
//
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        _dbPath = [documentDirectory stringByAppendingPathComponent:@"MyCollection.db"];
//    }
//    return self;
//}
//
//- (BOOL)insertRecord:(PbfDBRecord *)record
//{
//    if ([self existRecord:record.dataID]) {
//       return [self updateRecord:record];
//    } else {
//       return [self insertNewRecord:record];
//    }
//}
//
//- (BOOL)updateRecord:(PbfDBRecord *)record
//{
//    NSString *errorString = @"Error: failed to update data";
//    NSString *sql = [NSString stringWithFormat:@"update %@ set %@=?, %@=?, %@=?, %@=? where %@=?", PBF_COLLECTION_DATABASE_TABLE, PBF_COLLECTION_DATABASE_FIELD_ID, PBF_COLLECTION_DATABASE_FIELD_TYPE, PBF_COLLECTION_DATABASE_FIELD_DATA,PBF_COLLECTION_DATABASE_FIELD_DESCRIPTION, PBF_COLLECTION_DATABASE_FIELD_ID];
//    //    NSLog(@"%@", sql);
//    sqlite3_stmt *statement;
//    
//    int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
//    if (success != SQLITE_OK) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    
//    sqlite3_bind_text(statement, 1, [record.dataID UTF8String], -1, SQLITE_STATIC);
//    sqlite3_bind_int(statement, 2, record.dataType);
//    sqlite3_bind_blob(statement, 3, (const void *)[record.pbfData bytes], (int)[record.pbfData length], SQLITE_STATIC);
//    if (record.dataDescription == nil) {
//        sqlite3_bind_null(statement, 4);
//    } else {
//        sqlite3_bind_text(statement, 4, [record.dataDescription UTF8String], -1, SQLITE_STATIC);
//    }
//    sqlite3_bind_text(statement, 5, [record.dataID UTF8String], -1, SQLITE_STATIC);
//
//    success = sqlite3_step(statement);
//    sqlite3_finalize(statement);
//    
//    if (success == SQLITE_ERROR) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    return YES;
//}
//
//- (BOOL)insertNewRecord:(PbfDBRecord *)record
//{
//    NSString *errorString = @"Error: failed to insert data into the database.";
//    NSString *sql = [NSString stringWithFormat:@"Insert into %@ (%@, %@, %@, %@) values ( ?, ?, ?, ?)", PBF_COLLECTION_DATABASE_TABLE, PBF_COLLECTION_DATABASE_FIELD_ID, PBF_COLLECTION_DATABASE_FIELD_TYPE, PBF_COLLECTION_DATABASE_FIELD_DATA,PBF_COLLECTION_DATABASE_FIELD_DESCRIPTION];
//    sqlite3_stmt *statement;
//    int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
//    if (success != SQLITE_OK) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    
//    sqlite3_bind_text(statement, 1, [record.dataID UTF8String], -1, SQLITE_STATIC);
//    sqlite3_bind_int(statement, 2, record.dataType);
//    sqlite3_bind_blob(statement, 3, (const void *)[record.pbfData bytes], (int)[record.pbfData length], SQLITE_STATIC);
//    if (record.dataDescription == nil) {
//        sqlite3_bind_null(statement, 4);
//    } else {
//        sqlite3_bind_text(statement, 4, [record.dataDescription UTF8String], -1, SQLITE_STATIC);
//    }
//    
//    success = sqlite3_step(statement);
//    sqlite3_finalize(statement);
//    
//    if (success == SQLITE_ERROR) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    return YES;
//}
//
//- (BOOL)existRecord:(NSString *)recordID
//{
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@ FROM %@ ", PBF_COLLECTION_DATABASE_FIELD_ID, PBF_COLLECTION_DATABASE_TABLE];
//    [sql appendFormat:@" where %@ = '%@' ", PBF_COLLECTION_DATABASE_FIELD_ID, recordID];
//    
//    BOOL exist = NO;
//    sqlite3_stmt *statement;
//    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        if (sqlite3_step(statement) == SQLITE_ROW) {
//            exist = YES;
//        }
//    }
//    sqlite3_finalize(statement);
//    return exist;
//}
//
//- (BOOL)deleteRecord:(NSString *)recordID
//{
//    NSString *errorString = @"Error: failed to delete data";
//    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = ?", PBF_COLLECTION_DATABASE_TABLE, PBF_COLLECTION_DATABASE_FIELD_ID];
//    sqlite3_stmt *statement;
//    
//    int success = sqlite3_prepare(_database, [sql UTF8String], -1, &statement, NULL);
//    if (success != SQLITE_OK) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    
//    sqlite3_bind_text(statement, 1, [recordID UTF8String], -1, SQLITE_STATIC);
//    
//    success = sqlite3_step(statement);
//    sqlite3_finalize(statement);
//    
//    if (success == SQLITE_ERROR) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    return YES;
//}
//
//- (BOOL)deleteRecords:(PbfDataType)type
//{
//    NSString *errorString = @"Error: failed to delete data";
//    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = ?", PBF_COLLECTION_DATABASE_TABLE, PBF_COLLECTION_DATABASE_FIELD_TYPE];
//    sqlite3_stmt *statement;
//    
//    int success = sqlite3_prepare(_database, [sql UTF8String], -1, &statement, NULL);
//    if (success != SQLITE_OK) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    
//    sqlite3_bind_int(statement, 1, type);
//    
//    success = sqlite3_step(statement);
//    sqlite3_finalize(statement);
//    
//    if (success == SQLITE_ERROR) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    return YES;
//}
//
//- (PbfDBRecord *)getRecord:(NSString *)recordID
//{
//    PbfDBRecord *record = nil;
//    
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@, %@, %@, %@ FROM %@ ", PBF_COLLECTION_DATABASE_FIELD_ID, PBF_COLLECTION_DATABASE_FIELD_TYPE, PBF_COLLECTION_DATABASE_FIELD_DATA,PBF_COLLECTION_DATABASE_FIELD_DESCRIPTION, PBF_COLLECTION_DATABASE_TABLE];
//    [sql appendFormat:@" where %@ = '%@' ", PBF_COLLECTION_DATABASE_FIELD_ID, recordID];
////    BRTLog(@"%@", sql);
//    sqlite3_stmt *statement;
//    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        if (sqlite3_step(statement) == SQLITE_ROW) {
//            record = [[PbfDBRecord alloc] init];
//            record.dataID = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
//            record.dataType = sqlite3_column_int(statement, 1);
//            record.pbfData = [NSData dataWithBytes:(const char *)sqlite3_column_blob(statement, 2) length:(int)sqlite3_column_bytes(statement, 2)];
//            BRTLog(@"ObjC Length: %d", (int)record.pbfData.length);
//            if (sqlite3_column_type(statement, 3) != SQLITE_NULL) {
//                record.dataDescription = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
//            }
//        }
//    }
//    sqlite3_finalize(statement);
//    return record;
//}
//
//- (NSArray *)getRecords:(PbfDataType)type
//{
//    NSMutableArray *recordArray = [[NSMutableArray alloc] init];
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@, %@, %@, %@ FROM %@ ", PBF_COLLECTION_DATABASE_FIELD_ID, PBF_COLLECTION_DATABASE_FIELD_TYPE, PBF_COLLECTION_DATABASE_FIELD_DATA,PBF_COLLECTION_DATABASE_FIELD_DESCRIPTION, PBF_COLLECTION_DATABASE_TABLE];
//    [sql appendFormat:@" where %@ = %d ", PBF_COLLECTION_DATABASE_FIELD_TYPE, type];
//    
//    sqlite3_stmt *statement;
//    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            PbfDBRecord *record = [[PbfDBRecord alloc] init];
//            record.dataID = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
//            record.dataType = sqlite3_column_int(statement, 1);
//            record.pbfData = [NSData dataWithBytes:(const char *)sqlite3_column_blob(statement, 2) length:(int)sqlite3_column_bytes(statement, 2)];
//            if (sqlite3_column_type(statement, 3) != SQLITE_NULL) {
//                record.dataDescription = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
//            }
//            [recordArray addObject:record];
//        }
//    }
//    sqlite3_finalize(statement);
//    return recordArray;
//}
//
//- (BOOL)eraseDatabase
//{
//    NSString *errorString = @"Error: failed to erase MapData Table";
//    NSString *sql = [NSString stringWithFormat:@"delete from %@", PBF_COLLECTION_DATABASE_TABLE];
//    sqlite3_stmt *statement;
//    
//    int success = sqlite3_prepare(_database, [sql UTF8String], -1, &statement, NULL);
//    if (success != SQLITE_OK) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    
//    success = sqlite3_step(statement);
//    sqlite3_finalize(statement);
//    
//    if (success == SQLITE_ERROR) {
//        NSLog(@"%@", errorString);
//        return NO;
//    }
//    return YES;
//}
//
//- (void)createTablesIfNotExists
//{
//    NSString *mapInfoSql = [NSString stringWithFormat:@"create table if not exists %@ (%@, %@, %@, %@, %@)", PBF_COLLECTION_DATABASE_TABLE,
//                            [NSString stringWithFormat:@"%@ integer primary key autoincrement", PBF_COLLECTION_DATABASE_FIELD_PRIMARY_ID],
//                            [NSString stringWithFormat:@"%@ text not null", PBF_COLLECTION_DATABASE_FIELD_ID],
//                            [NSString stringWithFormat:@"%@ integer not null", PBF_COLLECTION_DATABASE_FIELD_TYPE],
//                            [NSString stringWithFormat:@"%@ blob not null", PBF_COLLECTION_DATABASE_FIELD_DATA],
//                            [NSString stringWithFormat:@"%@ text", PBF_COLLECTION_DATABASE_FIELD_DESCRIPTION]
//                            ];
//    sqlite3_stmt *statement;
//    NSInteger sqlReturn = sqlite3_prepare_v2(_database, [mapInfoSql UTF8String], -1, &statement, nil);
//    if (sqlReturn != SQLITE_OK) {
//        NSLog(@"create DATA table failed!");
//        return;
//    }
//    sqlite3_step(statement);
//    sqlite3_finalize(statement);
//}
//
//- (BOOL)open
//{
//    if (sqlite3_open([_dbPath UTF8String], &_database) == SQLITE_OK) {
//        [self createTablesIfNotExists];
//        return YES;
//    } else {
//        return NO;
//    }
//}
//
//- (BOOL)close
//{
//    return (sqlite3_close(_database) == SQLITE_OK);
//}
//
//@end
