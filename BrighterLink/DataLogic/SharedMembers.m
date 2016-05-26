//
//  SharedMembers.m
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "SharedMembers.h"
#import "JSWaiter.h"
#import "AppDelegate.h"

@implementation SharedMembers
- (id)init
{
    if (self = [super init])
    {
        _webManager = [[WebManager alloc] init];
        _userInfo = [[UserInfo alloc] init];
        _Members = [[NSMutableArray alloc] init];
        _Accounts = [[NSMutableArray alloc] init];
        _RootTags = [[NSMutableArray alloc] init];
        _Devices = [[NSMutableArray alloc] init];
        _Manufacturers = [[NSMutableArray alloc] init];
        _SFDCAccounts = [[NSMutableArray alloc] init];
        _UtilityProviders = [[NSMutableArray alloc] init];
        
        self.aryGroupDimentions = [NSArray arrayWithObjects:
                                   @{
                                    @"id": @"1",
                                    @"name@": @"COUNT_OF_DATAPOINTS",
                                    @"value": @"Count of Datapoints"},
                                   
                                   @{
                                     @"id": @"2",
                                     @"name@": @"INTERVAL",
                                     @"value": @"Interval"
                                    },
                                   
                                   @{
                                     @"id": @"3",
                                     @"name@": @"ACCESS_METHOD",
                                     @"value": @"Access Method"
                                    },
                                   
                                   @{
                                     @"id": @"4",
                                     @"name@": @"COUNTRY",
                                     @"value": @"Country"
                                    },
                                   
                                   @{
                                     @"id": @"5",
                                     @"name@": @"STATE",
                                     @"value": @"State"
                                    },
                                   
                                   @{
                                     @"id": @"6",
                                     @"name@": @"CITY",
                                     @"value": @"City"
                                    },
                                   
                                   @{
                                     @"id": @"7",
                                     @"name@": @"ZIP_CODE",
                                     @"value": @"Zip code"
                                    },
                                   
                                   @{
                                     @"id": @"8",
                                     @"name@": @"YEAR",
                                     @"value": @"Year"
                                    },
                                   
                                   @{
                                     @"id": @"9",
                                     @"name@": @"MONTH_OF_YEAR",
                                     @"value": @"Month of the Year"
                                    },
                                   
                                   @{
                                     @"id": @"10",
                                     @"name@": @"WEEK_OF_YEAR",
                                     @"value": @"Week of the Year"
                                    },
                                   
                                   @{
                                     @"id": @"11",
                                     @"name@": @"DAY_OF_MONTH",
                                     @"value": @"Day of the Month"
                                    },
                                   
                                   @{
                                     @"id": @"12",
                                     @"name": @"DAY_OF_WEEK",
                                     @"value": @"Day of the Week"
                                    },
                                   
                                   @{
                                     @"id": @"13",
                                     @"name@": @"HOUR_OF_DAY",
                                     @"value": @"Hour of the Day"
                                    },
                                   
                                   @{
                                     @"id": @"14",
                                     @"name@": @"MINUTE_OF_HOUR",
                                     @"value": @"Minute of the Hour"
                                    },
                                   
                                   @{
                                     @"id": @"15",
                                     @"name@": @"MONTH",
                                     @"value": @"Month"
                                    },
                                   
                                   @{
                                     @"id": @"16",
                                     @"name@": @"WEEK",
                                     @"value": @"Week"
                                    },
                                   
                                   @{
                                     @"id": @"17",
                                     @"name@": @"DATE",
                                     @"value": @"Date"
                                    },
                                   
                                   @{
                                     @"id": @"18",
                                     @"name@": @"HOUR",
                                     @"value": @"Hour"
                                    },
                                   
                                   @{
                                     @"id": @"19",
                                     @"name@": @"MINUTE",
                                     @"value": @"Minute"
                                    },
                                   
                                   @{
                                     @"id": @"20",
                                     @"name@": @"MONTH_INDEX",
                                     @"value": @"Month Index"
                                    },
                                   
                                   @{
                                     @"id": @"21",
                                     @"name@": @"WEEK_INDEX",
                                     @"value": @"Week Index"
                                    },
                                   
                                   @{
                                     @"id": @"22",
                                     @"name@": @"DAY_INDEX",
                                     @"value": @"Day Index"
                                    },
                                   
                                   @{
                                     @"id": @"23",
                                     @"name@": @"HOUR_INDEX",
                                     @"value": @"Hour Index"
                                    },
                                   
                                   @{
                                     @"id": @"24",
                                     @"name@": @"MINUTE_INDEX",
                                     @"value": @"Minute Index"
                                    },
                                   
                                   @{
                                     @"id": @"25",
                                     @"name@": @"DATALOGGER_MANUFACTURER",
                                     @"value": @"DataLogger Manufacturer - manufacturer of metric’s datalogger"
                                    },
                                   
                                   @{
                                     @"id": @"26",
                                     @"name@": @"SENSOR_MANUFACTURER",
                                     @"value": @"Sensor Manufacturer - manufacturer of metric’s sensor"
                                    },
                                   
                                   @{
                                     @"id": @"27",
                                     @"name@": @"DATALOGGER_DEVICE",
                                     @"value": @"DataLogger Device - device name of metric’s datalogger"
                                    },
                                   
                                   @{
                                     @"id": @"28",
                                     @"name@": @"SENSOR_DEVICE",
                                     @"value": @"Sensor Device - device name of metric’s sensor"
                                    } , nil];
        
        m_appNames[0] = @"BrighterView";
        m_appNames[1] = @"DataSense";
        m_appNames[2] = @"BrighterSavings";
        m_appNames[3] = @"Verified Savings";
        m_appNames[4] = @"Load Response";
        m_appNames[5] = @"Utility Manager";
        m_appNames[6] = @"Programs & Projects";
        m_appNames[7] = @"ENERGY STAR Portfolio Manager";
        
//    m_appNames[0] = @"Present";
//    m_appNames[1] = @"Analyze";
//    m_appNames[2] = @"Learn";
//    m_appNames[3] = @"Utility";
//    m_appNames[4] = @"Verify";
//    m_appNames[5] = @"Respond";
//    m_appNames[6] = @"Projects";
//    m_appNames[7] = @"ENERGY STAR Connect";
        
        [self initDashboards];
        [self initPresentations];
    }
    return self;
}

+(SharedMembers*)sharedInstance
{
    static SharedMembers *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void) initDashboards
{
    self.aryCollections = [[NSMutableArray alloc] init];
    
    self.arySegmentColors = @[[UIColor colorWithRed:255.0f / 255.0f green:102.0f / 255.0f blue:0.0f / 255.0f alpha:1.0f],
                              [UIColor colorWithRed:248.0f / 255.0f green:22.0f / 255.0f blue:159.0f / 255.0f alpha:1.0f],
                              [UIColor colorWithRed:106.0f / 255.0f green:225.0f / 255.0f blue:156.0f / 255.0f alpha:1.0f],
                              [UIColor colorWithRed:255.0f / 255.0f green:203.0f / 255.0f blue:120.0f / 255.0f alpha:1.0f],
                              [UIColor colorWithRed:148.0f / 255.0f green:103.0f / 255.0f blue:189.0f / 255.0f alpha:1.0f],
                              [UIColor colorWithRed:140.0f / 255.0f green:86.0f / 255.0f blue:75.0f / 255.0f alpha:1.0f],
                              [UIColor colorWithRed:227.0f / 255.0f green:119.0f / 255.0f blue:194.0f / 255.0f alpha:1.0f],
                              [UIColor colorWithRed:127.0f / 255.0f green:127.0f / 255.0f blue:127.0f / 255.0f alpha:1.0f],
                              [UIColor colorWithRed:188.0f / 255.0f green:189.0f / 255.0f blue:34.0f / 255.0f alpha:1.0f],
                              [UIColor colorWithRed:23.0f / 255.0f green:190.0f / 255.0f blue:207.0f / 255.0f alpha:1.0f]];
}

// ####################### dashboard #############################

- (NSInteger) getCollectionIndexWithTitle:(NSString *)title
{
    if(title == nil || title.length == 0)
        return NSNotFound;
    
    for (CollectionInfo *collection in self.aryCollections) {
        
        if([collection.title isEqualToString:title])
        {
            return [self.aryCollections indexOfObject:collection];
        }
    }
    
    return NSNotFound;
}

- (void) addNewDashboard:(DashboardInfo *)dashboard select:(BOOL) isSelect
{
    NSString *collectionTitle = dashboard.collectionName;
    
    NSInteger index = [self getCollectionIndexWithTitle:collectionTitle];
    if (index > self.aryCollections.count - 1)
        index = 0;
    CollectionInfo *collection = nil;
    collection = [self.aryCollections objectAtIndex:index];
    
    [collection addDashboard:dashboard];
    
    if(isSelect)
    {
        [self updateCurrentDashboard:dashboard];
    }
}

- (void) updateDashboard:(DashboardInfo *)dashboard
{
    for (CollectionInfo *collection in self.aryCollections) {
        
        for (DashboardInfo *dashboard_ in collection.aryDashboards) {
            
            if([dashboard._id isEqualToString:dashboard_._id])
            {
                [collection.aryDashboards removeObject:dashboard_];
                
                [self addNewDashboard:dashboard select:YES];
                
                return;
            }
        }
    }
    
    [self addNewDashboard:dashboard select:YES];
}

- (DashboardInfo *) getDashboardWithId:(NSString *)dashboardId
{
    for (CollectionInfo *collection in self.aryCollections) {
        
        for (DashboardInfo *dashboard_ in collection.aryDashboards) {
            
            if([dashboardId isEqualToString:dashboard_._id])
            {
                return dashboard_;
            }
        }
    }
    
    return nil;
}

- (void) deleteCurrentDashboard
{
    int n = 0;
    for (n = 0 ; n < self.aryCollections.count ; n ++) {
        
        CollectionInfo *collection = [self.aryCollections objectAtIndex:n];
        
        BOOL removed = NO;
        for (DashboardInfo *dashboard_ in collection.aryDashboards) {
            
            if([dashboard_._id isEqualToString:self.currentDashboard._id])
            {
                NSInteger index = [collection.aryDashboards indexOfObject:dashboard_];
                [collection.aryDashboards removeObject:dashboard_];
                
                removed = YES;
                
                if(index > 0) index --;
                else if(collection.aryDashboards.count > 0) index = 0;
                else index = NSNotFound;
                
                if(index != NSNotFound)
                {
                    DashboardInfo *newCurrentDashboard = [collection.aryDashboards objectAtIndex:index];
                    
                    [self updateCurrentDashboard:newCurrentDashboard];
                    
                    return ;
                }
                
                break;
            }
        }
        
        if(removed) break;
    }
    
    if(n < self.aryCollections.count)
    {
        CollectionInfo *collection = [self.aryCollections objectAtIndex:n];
        
        if(collection.aryDashboards.count == 0)
        {
            [self.aryCollections removeObject:collection];
        }
    }
    
    if(self.aryCollections.count > 0)
    {
        CollectionInfo *collection = [self.aryCollections objectAtIndex:0];
        
        if(collection.aryDashboards.count > 0)
        {
            DashboardInfo *newCurrentDashboard = [collection.aryDashboards objectAtIndex:0];
            
            [self updateCurrentDashboard:newCurrentDashboard];
            
            return;
        }
    }
}

- (void) updateCurrentDashboard:(DashboardInfo *)dashboard
{
    if(dashboard == nil) return;
    

    [self.aryWidgetDatas removeAllObjects];
    self.currentDashboard = dashboard;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:dashboard._id forKey:KEY_SELECTED_DASHBOARD_ID];
    [prefs synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTED_DASHBOARD object:nil];
}

- (void) updateSegmentsForCurrentDashboard:(NSArray *)segments
{
    [self.currentDashboard updateSegments:segments];
}

- (BOOL) hasWidgetOnCurrentDashboardWithId:(NSString *)widgetId
{
    if(self.currentDashboard == nil) return NO;
    
    NSArray *widgets = self.currentDashboard.widgetDatas;
    
    for (NSDictionary *widget in widgets) {
        
        NSLog(@"%@", widget);
        
        NSString *widgetId_ = [[widget objectForKey:@"widget"] objectForKey:@"_id"];
        
        if([widgetId_ isEqualToString:widgetId])
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL) removeWidgetOnCurrentDashboardWithId:(NSString *)widgetId
{
    if(self.currentDashboard == nil) return NO;
    
    NSMutableArray *widgets = self.currentDashboard.widgetDatas;
    
    NSMutableArray *aryTemp = [[NSMutableArray alloc] init];
    
    BOOL removed = NO;
    for (NSDictionary *widget in widgets) {
        
        NSString *widgetId_ = [[widget objectForKey:@"widget"] objectForKey:@"_id"];
        
        if([widgetId_ isEqualToString:widgetId])
        {
            removed = YES;
        }
        else
        {
            [aryTemp addObject:widget];
        }
    }
    
    self.currentDashboard.widgetDatas = aryTemp;
    aryTemp = nil;
    
    [self removeWidgetFromBaseWidgetListWithId:widgetId];//It's very important.
    
    return removed;
}

- (void) removeWidgetFromBaseWidgetListWithId:(NSString *)widgetId
{
    NSMutableArray *widgets = self.currentDashboard.widgets;
    
    NSMutableArray *aryTemp = [[NSMutableArray alloc] init];
    
    BOOL removed = NO;
    for (NSDictionary *widget in widgets) {
        
        NSString *widgetId_ = [widget objectForKey:@"widget"];
        
        if([widgetId_ isEqualToString:widgetId])
        {
            removed = YES;
        }
        else
        {
            [aryTemp addObject:widget];
        }
    }
    
    self.currentDashboard.widgets = aryTemp;
    aryTemp = nil;
}

- (NSDictionary *) getWidgetInfoWithId:(NSString *)widgetId
{
    if(self.currentDashboard == nil) return nil;
    
    NSMutableArray *widgets = self.currentDashboard.widgetDatas;

    for (NSDictionary *widget in widgets) {
        
        NSString *widgetId_ = [[widget objectForKey:@"widget"] objectForKey:@"_id"];
        
        if([widgetId_ isEqualToString:widgetId])
        {
            return widget;
        }
    }
    
    return nil;
}

- (void) addWidgetGraphicData:(NSString *)widgetId data:(NSDictionary *)graphicData
{
    if(widgetId == nil || ![widgetId isKindOfClass:[NSString class]]) return;
    
    if(graphicData == nil || ![graphicData isKindOfClass:[NSDictionary class]]) return;
    
    if(self.aryWidgetDatas == nil) self.aryWidgetDatas = [[NSMutableArray alloc] init];
    
    for (NSDictionary *widgetData in self.aryWidgetDatas) {
        
        NSString *widgetId_ = [widgetData.allKeys firstObject];
        
        if([widgetId_ isEqualToString:widgetId])
        {
            [widgetData setValue:graphicData forKey:widgetId_];
            
            return;
        }
    }
    
    NSDictionary *newWidgetData = [NSDictionary dictionaryWithObjectsAndKeys:graphicData, widgetId, nil];
    
    [self.aryWidgetDatas addObject:newWidgetData];
}

- (void) removeWidgetGraphicData:(NSString *)widgetId
{
    if(widgetId == nil || ![widgetId isKindOfClass:[NSString class]]) return;
    
    for (NSDictionary *widgetData in self.aryWidgetDatas) {
        
        NSString *widgetId_ = [widgetData.allKeys firstObject];
        
        if([widgetId_ isEqualToString:widgetId])
        {
            [self.aryWidgetDatas removeObject:widgetData];
            
            return;
        }
    }
}

- (NSDictionary *) getWidgetGraphicData:(NSString *)widgetId
{
    if(widgetId == nil || ![widgetId isKindOfClass:[NSString class]]) return nil;
    
    for (NSDictionary *widgetData in self.aryWidgetDatas) {
        
        NSString *widgetId_ = [widgetData.allKeys firstObject];
        
        if([widgetId_ isEqualToString:widgetId])
        {
            
            return [widgetData.allValues firstObject];
        }
    }
    
    return nil;
}

- (UIColor *) getSegmentColorWithIndex:(NSInteger )index
{
    index = index % self.arySegmentColors.count;
    
    return [self.arySegmentColors objectAtIndex:index];
}

// ####################### dashboard #############################

+(void)ShowGlobalWaiter:(NSString*)title  type:(WaiterType)type
{
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [JSWaiter ShowWaiter:app.window.rootViewController.view title:title type:type];
}

+ (UIImage *)fixOrientation:(UIImage*)srcImg
{
    // No-op if the orientation is already correct
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(UIImage*)CaptureBackground:(UIView*)view inRect:(CGRect)inRect withScale:(CGFloat)scale
{    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(inRect.size.width,inRect.size.height),YES,scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -inRect.origin.x, -inRect.origin.y);
    CGContextClipToRect(context, inRect);
    [view.layer renderInContext:context];
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    UIImage* ret = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    return ret;
}

+ (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(NSString*)GetSavePath:(NSString*)dirName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* path = [basePath stringByAppendingPathComponent:dirName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

// string format : ex:2014-11-03T20:11:52.929Z
+(NSDate *) getDateWithString:(NSString *)string
{
    if(![string isKindOfClass:[NSString class]] || string.length == 0)
        return nil;
    
    string = [string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSArray *subDates = [string componentsSeparatedByString:@"."];
    
    if(subDates.count > 0)
    {
        string = [subDates objectAtIndex:0];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}


// ####################### dashboard #############################

-(void) initPresentations
{
    _arrAllPresentations = [[NSMutableArray alloc] init];
    _arrEditors          = [[NSMutableArray alloc] init];
    _arrTemplates        = [[NSMutableArray alloc] init];
    _arrAvailableWidgets = [[NSMutableArray alloc] init];
    _arrEditorUsers      = [[NSMutableArray alloc] init];
    
    
    _curPresent = [[PresentationInfo alloc] init];
    _curWidget  = [[PWidgetInfo alloc] init];
    
    _imgUrl = @"";
    _selectedAccountId = @"";
}
@end
