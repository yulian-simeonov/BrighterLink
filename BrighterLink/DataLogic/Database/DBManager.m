//
//  DBManager.m
//  BrazilWorldCup
//
//  Created by  NOVNUS LLC   on 12/20/13.
//  Copyright (c) 2013 NOVNUS LLC. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

- (id)init {
    if (self = [super init]) {
        m_dbConnector = [[JSDBConnector alloc] initWithDBName:@"brigherlink"];
    }
    return self;
}

+(DBManager*)sharedInstance
{
    static DBManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

//##########################################################################################################################
@end
