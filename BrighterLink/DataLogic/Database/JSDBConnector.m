//
//  DBConnector.m
//  Transform!
//
//  Created by NOVNUS LLC on 1/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "JSDBConnector.h"

@implementation JSDBConnector

-(id)initWithDBName:(NSString*)dbName
{
    if (self = [super init])
    {
        [self Open:dbName];
    }
    return self;
}

-(void)dealloc
{
    [self Close];
}

-(void)Open:(NSString*)dbName
{
    if (m_dbConnection == nil) {
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
        NSLog(@"DB Path:%@", writableDBPath);
        if ([fileManager fileExistsAtPath:writableDBPath] == NO) {
            NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"db_twinqli" ofType:@"db"];
            success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
            if (!success) {
                NSCAssert1(0, @"Failed to create writable database_list file with message '%@'.", [error localizedDescription]);
            }
        }
		
        if (sqlite3_open([writableDBPath UTF8String], &m_dbConnection) != SQLITE_OK) {
            sqlite3_close(m_dbConnection);
            m_dbConnection = NULL;
            NSCAssert1(0, @"Failed to open database_list with message '%s'.", sqlite3_errmsg(m_dbConnection));
        }
    }
}

- (void)Close {
    if(m_dbConnection == nil) 
		return;
	
    if(sqlite3_close(m_dbConnection) != SQLITE_OK) {
        NSCAssert1(0, @"Error: failed to close database_list with message '%s'.", sqlite3_errmsg(m_dbConnection));
    }
    m_dbConnection = nil;
}

-(BOOL)ExecuteNonQuery:(NSString*)strQuery
{
    if (!strQuery)
        return false;
    BOOL result = false;
    if (m_dbConnection == nil)
        return false;
    @synchronized(self)
    {
        sqlite3_stmt *statement;
        int errCode = sqlite3_prepare(m_dbConnection,[strQuery UTF8String],-1,&statement,NULL);
        if (errCode == SQLITE_OK)
        {
            errCode = sqlite3_step(statement);
            if (errCode == SQLITE_DONE)
                result = true;
            else {
                NSLog(@"Error Code: %d", errCode);
            }
        }
        
        sqlite3_finalize(statement);
    }
    return result;
}

-(id)ExecuteScalar:(NSString*)strQuery
{
    if (!strQuery)
        return nil;
    id result = nil;
    sqlite3_stmt* statement;
    @synchronized(self)
    {
        if (sqlite3_prepare(m_dbConnection, [strQuery UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                if (sqlite3_column_count(statement) > 0)
                {
                    switch (sqlite3_column_type(statement, 0))
                    {
                        case SQLITE_TEXT:
                            result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                            break;
                        case SQLITE_INTEGER:
                            result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,0)];
                            break;
                        case SQLITE_FLOAT:
                            result = [NSNumber numberWithFloat:(float)sqlite3_column_int(statement,0)];
                            break;
                        case SQLITE_BLOB:
                            result = [NSNumber numberWithBool:sqlite3_column_int(statement,0)];
                            break;
                        case SQLITE_NULL:
                            result = nil;
                            break;
                        default:
                            break;
                    }
                }
            }
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    return result;
}

-(NSMutableArray*)ExecuteReader:(NSString*)strQuery
{
    if (!strQuery)
        return nil;
    NSMutableArray* result = [[NSMutableArray alloc] init];
    sqlite3_stmt* statement;
    @synchronized(self)
    {
        if (sqlite3_prepare(m_dbConnection, [strQuery UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary* thisDict = [[NSMutableDictionary alloc] init];
                for (int i = 0; i < sqlite3_column_count(statement); i++)
                {
                    id queryResult = nil;
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_TEXT:
                            queryResult = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                            break;
                        case SQLITE_INTEGER:
                            queryResult = [NSNumber numberWithInt:sqlite3_column_int(statement,i)];
                            break;
                        case SQLITE_FLOAT:
                            queryResult = [NSNumber numberWithDouble:sqlite3_column_int(statement,i)];
                            break;
                        case SQLITE_BLOB:
                            queryResult = [NSNumber numberWithBool:sqlite3_column_int(statement,i)];
                            break;
                        case SQLITE_NULL:
                            queryResult = [NSNull null];
                            break;
                        default:
                            break;
                    }
                    NSString* key = [NSString stringWithUTF8String:sqlite3_column_name(statement,i)];
                    [thisDict setObject:queryResult forKey:key];
                }
                [result addObject:thisDict];
            }
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    return result;
}

@end
