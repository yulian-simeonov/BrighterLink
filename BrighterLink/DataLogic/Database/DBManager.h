//
//  DBManager.h
//  BrazilWorldCup
//
//  Created by NOVNUS LLC    on 12/20/13.
//  Copyright (c) 2013 NOVNUS LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSDBConnector.h"

@interface DBManager : NSObject
{
    JSDBConnector*  m_dbConnector;
}

//########################################################### Methods ########################################################################
+(DBManager*)sharedInstance;

//############################################################################################################################################
@end
