//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "SolarView.h"

#import "SharedMembers.h"

#import "Command.h"

@interface SolarView()

@end

@implementation SolarView

NSString * sMonths[] = {
    @"January", @"Feburary", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"
};

- (void) awakeFromNib
{
    
}

- (void) setRefresh:(SolarInfo*) info
{
    m_Info = info;
}

- (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//21. 34. 25.14.
- (void) resizeAllSubview:(CGRect) frame origentation:(BOOL) bVertical
{
    
    width = frame.size.width;
    height = frame.size.height;
    
    _m_img_title_bg.layer.cornerRadius  = 5.0f;
    
    
    if ( bVertical )
    {
        [self setHorizontalFrame];
    }
    else
    {
        [self setVerticalFrame];
    }
}

- (void) setVerticalFrame
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    for( UIView * v in [self subviews] )
    {
        [v removeFromSuperview];
    }
    
    if ( m_Info  == nil ) {
        return;
    }
    
/// Title
    
    UIImageView * titleBgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [titleBgView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:titleBgView];
    
    
    UILabel * m_l_title  = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, height)];
    [m_l_title setBackgroundColor:[UIColor clearColor]];

    headerFont * title  = widget.param.headerFnt;
    if ( title ) {
        double font = [title.size doubleValue];
        [m_l_title setFont: [UIFont fontWithName:[Command checkFontName:title.name] size:(int)(font*10)]];
        [m_l_title setTextColor:[self colorFromHexString:title.color]];
        
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {
            NSString * content  = title.content;
            [m_l_title setText:content];
        }
    }
    
    if ( widget.param.backgroundColor) {
        [m_l_title setTextColor: [self colorFromHexString: widget.param.backgroundColor]];
    }
    
    primaryColor * titleBgClr  = widget.param.primaryClr;
    if ( titleBgClr ) {
        [titleBgView setBackgroundColor: [self colorFromHexString: titleBgClr.color]];
        
    }
    
    [self addSubview: m_l_title];
    [Command setAdjustHeightwithFixedWidth:m_l_title];
    
    [titleBgView setFrame: CGRectMake(0, 0, width, 10 + m_l_title.frame.size.height)];
    titleBgView.layer.cornerRadius = 5.f;
    
    if( m_l_title.frame.size.height == 0 )
    {
        [m_l_title setFrame:CGRectMake(m_l_title.frame.origin.x, m_l_title.frame.origin.y, self.frame.size.width, 50)];
    }
    m_l_title.layer.cornerRadius  = 5.f;
    m_l_title.textAlignment = NSTextAlignmentCenter;
    
    NSLog(@"%f", m_l_title.frame.size.width);
    
    float restHeight  = self.frame.size.height - m_l_title.frame.size.height;
    int   nItemNum  = [self checkOptionNum];
    float delta  = restHeight / nItemNum;
    
/// Lines
//    if ( nItemNum  >= 1 ) {
//        for ( int i = 0; i < nItemNum-1; i++ ) {
//            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, m_l_title.frame.size.height + delta * (i + 1), self.frame.size.width - 20, 1)];
//            [imgView setBackgroundColor:[UIColor lightGrayColor]];
//            [self addSubview: imgView];
//        }
//    }
////  Draw Data
    
    normal1Font * calcDic  = widget.param.normal1Fnt;
    int  calcFontSize  = 0;
    NSString * calcFontName = @"";
    NSString * calcFontColor = @"";
    if ( calcDic ) {
        calcFontSize = [calcDic.size doubleValue] * 10;
        calcFontName = [Command checkFontName:calcDic.name];
        calcFontColor = calcDic.color;
        }
    
    
    normal2Font * basicDic  = widget.param.normal2Fnt;
    int  basicFontSize  = 0;
    NSString * basicFontName  = @"";
    NSString * basicFontColor = @"";
    
    if ( basicDic ) {
        basicFontSize = [basicDic.size doubleValue] * 10;
        basicFontName = [Command checkFontName:basicDic.name];
        basicFontColor = basicDic.color;
        
    }
    
    subHeaderFont * suppDic  = widget.param.subHeaderFnt;
    int suppFontSize = 0;
    NSString * suppFontName  = @"";
    NSString * suppFontColor = @"";
    
    if ( suppDic ) {
        suppFontSize = [suppDic.size doubleValue] * 10;
        suppFontName = [Command checkFontName: suppDic.name];
        suppFontColor = suppDic.color;
    }
    

    
        NSString * date = @"";
        NSArray * arr = [m_Info.startDate componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-T"]];
        if ( [arr count] >= 3) {
            NSString * month = [arr objectAtIndex:1];
            NSString * year  = [arr objectAtIndex:0];
            NSString * day   = [arr objectAtIndex:2];
            date = [NSString stringWithFormat:@"since %@ %@, %@", [self GetMonth: month.intValue], day, year];
    }

        NSNumber * kwh = m_Info.kWhGenerated;
        NSNumber * curGeneration = m_Info.currentGeneration;
        NSNumber * reim = m_Info.reimbursement;
    
    
    if ( bCurrent ) {
        UILabel * m_l_Current  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + m_l_title.frame.size.height, self.frame.size.width-20, delta/2)];
        [m_l_Current setText: @"Current Generation"];
        [m_l_Current setFont:[UIFont fontWithName: [Command checkFontName: basicFontName] size:basicFontSize]];
        [m_l_Current setTextColor: [Command colorFromHexString:basicFontColor]];
        [self addSubview: m_l_Current];
        
        [Command setAdjustHeightwithFixedWidth: m_l_Current];
        
            NSLog(@"%f", m_l_Current.frame.size.width);
        
        UILabel * m_l_Current_Val  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 +  m_l_title.frame.size.height + m_l_Current.frame.size.height, self.frame.size.width-20, delta/2)];
        [m_l_Current_Val setText: [NSString stringWithFormat:@"%.1f kW", [curGeneration doubleValue]] ];
        [m_l_Current_Val setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
        [m_l_Current_Val setTextColor:[Command colorFromHexString:calcFontColor]];
        
        [self addSubview: m_l_Current_Val];
        
        [Command setAdjustHeightwithFixedWidth:m_l_Current_Val];
        
        float fMove  = m_l_Current_Val.frame.origin.y + m_l_Current_Val.frame.size.height;
        fMove -= m_l_Current.frame.origin.y;
        fMove  = (delta - fMove)/2;
        
        m_l_Current.center  = CGPointMake( m_l_Current.center.x, m_l_Current.center.y + fMove);
        m_l_Current_Val.center  = CGPointMake( m_l_Current_Val.center.x, m_l_Current_Val.center.y + fMove);

    }
    
    if ( bTotal ) {
        if ( bCurrent ) {
            
            UILabel * m_l_Total  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + m_l_title.frame.size.height + delta, self.frame.size.width-20, delta/3)];
            [m_l_Total setText: @"Total Generation"];
            [m_l_Total setFont:[UIFont fontWithName: [Command checkFontName: basicFontName] size:basicFontSize]];
            [m_l_Total setTextColor:[Command colorFromHexString:basicFontColor]];
            [self addSubview: m_l_Total];
            
            [Command setAdjustHeightwithFixedWidth:m_l_Total];
            
            float oriY  = m_l_Total.frame.origin.y +  m_l_Total.frame.size.height;
            
            UILabel * m_l_Since  = [[UILabel alloc] initWithFrame:CGRectMake(10, oriY, self.frame.size.width-20, delta/3)];
            [m_l_Since setText:[NSString stringWithFormat:@"since %@", date] ];
            
            [m_l_Since setTextColor:[UIColor lightGrayColor]];
            [m_l_Since setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
            [self addSubview: m_l_Since];
            
            [self m_l_Since];
            [Command setAdjustHeightFrame:m_l_Since];   [Command setAdjustWidthFrame:m_l_Since];
            
            oriY = m_l_Since.frame.origin.y + m_l_Since.frame.size.height;
            
            UILabel * m_l_Total_Val  = [[UILabel alloc] initWithFrame:CGRectMake( m_l_Since.frame.origin.x, oriY, self.frame.size.width-20, delta/3)];
            [m_l_Total_Val setText: [NSString stringWithFormat:@"%.1f kW", [kwh doubleValue]] ];
            [m_l_Total_Val setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
            [m_l_Total_Val setTextColor:[Command colorFromHexString:calcFontColor]];
            m_l_Total_Val.textAlignment = NSTextAlignmentLeft;
            
            [self addSubview: m_l_Total_Val];
            
            float fMove  = m_l_Total_Val.frame.origin.y + m_l_Total_Val.frame.size.height;
            fMove -= m_l_Total.frame.origin.y;
            fMove  = (delta - fMove)/2;
            
            m_l_Total.center  = CGPointMake( m_l_Total.center.x, m_l_Total.center.y + fMove);
            m_l_Since.center  = CGPointMake( m_l_Since.center.x, m_l_Since.center.y + fMove);
            m_l_Total_Val.center  = CGPointMake( m_l_Total_Val.center.x, m_l_Total_Val.center.y + fMove);
            
        }
        else{
            UILabel * m_l_Total  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + m_l_title.frame.size.height, self.frame.size.width-20, delta/3)];
            [m_l_Total setText: @"Total Generation"];
            [m_l_Total setFont:[UIFont fontWithName: [Command checkFontName: basicFontName] size:basicFontSize]];
            [m_l_Total setTextColor:[Command colorFromHexString:basicFontColor]];
            
            [self addSubview: m_l_Total];
            
            [Command setAdjustHeightwithFixedWidth:m_l_Total];
            
            float oriY  = m_l_Total.frame.origin.y + m_l_Total.frame.size.height;
            
            UILabel * m_l_Since  = [[UILabel alloc] initWithFrame:CGRectMake(10, oriY, self.frame.size.width-20, delta/3)];
            [m_l_Since setText: [NSString stringWithFormat:@"since %@", date]];
            [m_l_Since setTextColor:[UIColor lightGrayColor]];
            [m_l_Since setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
            
            [self addSubview: m_l_Since];

           [Command setAdjustHeightFrame:m_l_Since];   [Command setAdjustWidthFrame:m_l_Since];
            
            oriY = m_l_Since.frame.origin.y + m_l_Since.frame.size.height;
            UILabel * m_l_Total_Val  = [[UILabel alloc] initWithFrame:CGRectMake( m_l_Since.frame.origin.x, oriY, self.frame.size.width-20, delta/3)];
            [m_l_Total_Val setText: [NSString stringWithFormat:@"%.1f kW", [kwh doubleValue]]];
            [m_l_Total_Val setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
            [m_l_Total_Val setTextColor:[Command colorFromHexString:calcFontColor]];
             m_l_Total_Val.textAlignment = NSTextAlignmentLeft;
            [self addSubview: m_l_Total_Val];

//            [self setAdjustFrame:m_l_Total_Val];
            
            float fMove  = m_l_Total_Val.frame.origin.y + m_l_Total_Val.frame.size.height;
            fMove -= m_l_Total.frame.origin.y;
            fMove  = (delta - fMove)/2;
            
            m_l_Total.center  = CGPointMake( m_l_Total.center.x, m_l_Total.center.y + fMove);
            m_l_Since.center  = CGPointMake( m_l_Since.center.x, m_l_Since.center.y + fMove);
            m_l_Total_Val.center  = CGPointMake( m_l_Total_Val.center.x, m_l_Total_Val.center.y + fMove);
        }
    }
    
    if ( bReim )
    {
        UILabel * m_l_Reim  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + m_l_title.frame.size.height + (nItemNum-1) * delta, self.frame.size.width-20, delta/2)];
        [m_l_Reim setText: @"Reimbursement :"];
        [m_l_Reim setFont:[UIFont fontWithName:[Command checkFontName: suppFontName] size:suppFontSize]];
        [m_l_Reim setTextColor: [Command colorFromHexString:suppFontColor]];
        [self addSubview: m_l_Reim];

        [Command setAdjustHeightwithFixedWidth: m_l_Reim];
        
        float oriY  = m_l_Reim.frame.origin.y + m_l_Reim.frame.size.height;

        UILabel * m_l_Reim_Val  = [[UILabel alloc] initWithFrame:CGRectMake(10, oriY, self.frame.size.width-20, delta/2)];
        [m_l_Reim_Val setText: [NSString stringWithFormat:@"$ %.1f", [reim doubleValue]] ];
        [m_l_Reim_Val setTextColor:[Command colorFromHexString:calcFontColor]];

        [self addSubview: m_l_Reim_Val];
        
        float fMove  = m_l_Reim_Val.frame.origin.y + m_l_Reim_Val.frame.size.height;
        fMove -= m_l_Reim.frame.origin.y;
        fMove  = (delta - fMove)/2;
        
        m_l_Reim.center  = CGPointMake( m_l_Reim.center.x, m_l_Reim.center.y + fMove);
        m_l_Reim_Val.center  = CGPointMake( m_l_Reim_Val.center.x, m_l_Reim_Val.center.y + fMove);

    }
}

- (void) setHorizontalFrame
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    for( UIView * v in [self subviews] )
    {
        [v removeFromSuperview];
    }
    
    if ( m_Info  == nil ) {
        return;
    }
    
    /// Title
    headerFont * title  = widget.param.headerFnt;
    NSString * titleContent  = @"";
    NSString * titleFontName = @"";
    NSString * titleFontColor = @"";
    int        titleFontSize  = 0;
    
    if ( title ) {
        titleFontSize = [title.size doubleValue] * 10;
        titleFontColor = title.color;
        titleFontName = title.name;
        
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {
            titleContent  = title.content;
        }
    }
    
    primaryColor * titleBgClr  = widget.param.primaryClr;
    
    UIImageView * titleBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width/3, height)];
    titleBgView.layer.cornerRadius = 5.f;
    [self addSubview: titleBgView];
    if ( titleBgClr ) {
        [titleBgView setBackgroundColor:[self colorFromHexString: titleBgClr.color]];
    }
    else{
        [titleBgView setBackgroundColor:[UIColor whiteColor]];
    }
    
    NSArray * arrTitle = [titleContent componentsSeparatedByString:@" "];
    
    UILabel * temp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/3-10, 100)];
    [temp setText:@"Generation"];
    [temp setFont:[UIFont fontWithName: [Command checkFontName: titleFontName] size:titleFontSize]];
    [Command setAdjustHeightwithFixedWidth:temp];
    float titleHeight = temp.frame.size.height;
    if ( [arrTitle count] > 0 ) {
        for ( int i = 0;  i < [arrTitle count]; i++ ) {
            UILabel * title  = [[UILabel alloc] initWithFrame: CGRectMake( 5, 10 + titleHeight * i, width/3-10, titleHeight)];
            [title setText: [arrTitle objectAtIndex:i]];
            [title setFont:[UIFont fontWithName:[Command checkFontName:titleFontName] size:titleFontSize]];
            [title setTextColor:[Command colorFromHexString:titleFontColor]];
            [self addSubview:title];
        }
    }
    
//    [Command setAdjustHeightwithFixedWidth: m_l_title];
    
    
    float restWidth  = width * 2/3;
    int   nItemNum  = [self checkOptionNum];
    float delta  = self.frame.size.height / nItemNum;
    
    /// Lines
//    if ( nItemNum  >= 1 ) {
//        for ( int i = 0; i < nItemNum-1; i++ ) {
//            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(m_l_title.frame.size.width + restWidth * 2/3, delta * i, 1, 50)];
//            [imgView setBackgroundColor:[UIColor lightGrayColor]];
//            [self addSubview: imgView];
//        }
//    }
    
//    if ( nItemNum  >= 1 ) {
//        for ( int i = 0; i < nItemNum-1; i++ ) {
//            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(m_l_title.frame.size.width +5,  delta * (i + 1), restWidth - 10, 1)];
//            [imgView setBackgroundColor:[UIColor lightGrayColor]];
//            [self addSubview: imgView];
//        }
//    }
    
    normal1Font * calcDic  = widget.param.normal1Fnt;
    int  calcFontSize  = 0;
    NSString * calcFontName = @"";
    NSString * calcFontColor = @"";
    if ( calcDic ) {
        calcFontSize = [calcDic.size doubleValue] * 10;
        calcFontName = [Command checkFontName:calcDic.name];
        calcFontColor = calcDic.color;
    }
    
    
    normal2Font * basicDic  = widget.param.normal2Fnt;
    int  basicFontSize  = 0;
    NSString * basicFontName  = @"";
    NSString * basicFontColor = @"";
    
    if ( basicDic ) {
        basicFontSize = [basicDic.size doubleValue] * 10;
        basicFontName = [Command checkFontName:basicDic.name];
        basicFontColor = basicDic.color;
        
        }
    
    subHeaderFont * suppDic  = widget.param.subHeaderFnt;
    int suppFontSize = 0;
    NSString * suppFontName  = @"";
    NSString * suppFontColor = @"";
    
    if ( suppDic ) {
        suppFontSize = [suppDic.size doubleValue] * 10;
        suppFontName = [Command checkFontName: suppDic.name];
        suppFontColor = suppDic.color;
    }


    ////  Draw Data
    
    NSString * date = @"";
    NSArray * arr = [m_Info.startDate componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-T"]];
    if ( [arr count] >= 3) {
        NSString * month = [arr objectAtIndex:1];
        NSString * year  = [arr objectAtIndex:0];
        NSString * day   = [arr objectAtIndex:2];
        date = [NSString stringWithFormat:@"since %@ %@, %@", [self GetMonth: month.intValue], day, year];
    }
    
    NSNumber * kwh = m_Info.kWhGenerated;
    NSNumber * curGeneration = m_Info.currentGeneration;
    NSNumber * reim = m_Info.reimbursement;

    
    if ( bCurrent ) {
        UILabel * m_l_Current  = [[UILabel alloc] initWithFrame:CGRectMake( width/ 3+5 , 0, restWidth-10, delta/2)];
        [m_l_Current setText: @"Current Generation"];
        [m_l_Current setFont:[UIFont fontWithName: [Command checkFontName: basicFontName] size:basicFontSize]];
        [m_l_Current setTextColor: [Command colorFromHexString:basicFontColor]];
        
        [self addSubview: m_l_Current];
        
        [Command setAdjustHeightwithFixedWidth: m_l_Current];
        
        float oriY  = m_l_Current.frame.origin.y + m_l_Current.frame.size.height;
        
        UILabel * m_l_Current_Val  = [[UILabel alloc] initWithFrame:CGRectMake(width/ 3 +5 ,  oriY, restWidth-10 , delta/2)];
        [m_l_Current_Val setText: [NSString stringWithFormat:@"%.1f kW", [curGeneration doubleValue] ]];
        [m_l_Current_Val setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
        [m_l_Current_Val setTextColor:[Command colorFromHexString:calcFontColor]];
        
        [self addSubview: m_l_Current_Val];
        
       [Command setAdjustHeightwithFixedWidth:m_l_Current_Val];
        
        float fMove  = m_l_Current_Val.frame.origin.y + m_l_Current_Val.frame.size.height;
        fMove -= m_l_Current.frame.origin.y;
        fMove  = (delta - fMove)/2;
        
        m_l_Current.center  = CGPointMake( m_l_Current.center.x, m_l_Current.center.y + fMove);
        m_l_Current_Val.center  = CGPointMake( m_l_Current_Val.center.x, m_l_Current_Val.center.y + fMove);

    }
    
    if ( bTotal ) {
        if ( bCurrent ) {
            UILabel * m_l_Total  = [[UILabel alloc] initWithFrame:CGRectMake(width/ 3 + 5,  delta, restWidth-10, delta/2)];
            [m_l_Total setText: @"Total Generation"];
            [m_l_Total setFont:[UIFont fontWithName: [Command checkFontName: basicFontName] size:basicFontSize]];
            [m_l_Total setTextColor:[Command colorFromHexString:basicFontColor]];
            
            [self addSubview: m_l_Total];
            
             [Command setAdjustHeightwithFixedWidth:m_l_Total];
            
            float oriY = m_l_Total.frame.origin.y + m_l_Total.frame.size.height;
            UILabel * m_l_Since  = [[UILabel alloc] initWithFrame:CGRectMake(width/ 3 + 5,  oriY, restWidth * 2/3, delta/2)];
            [m_l_Since setText: [NSString stringWithFormat:@"since %@", date]];
            [m_l_Since setTextColor:[UIColor lightGrayColor]];
            [m_l_Since setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
            
            [self addSubview: m_l_Since];
            
            [Command setAdjustHeightFrame:m_l_Since];   [Command setAdjustWidthFrame:m_l_Since];

            oriY = m_l_Since.frame.origin.y + m_l_Since.frame.size.height;
            
            UILabel * m_l_Total_Val  = [[UILabel alloc] initWithFrame:CGRectMake( m_l_Since.frame.origin.x ,  oriY, restWidth/3, delta/2)];
            [m_l_Total_Val setText: [NSString stringWithFormat:@"%.1f kW", [kwh doubleValue]]];
            [m_l_Total_Val setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
            [m_l_Total_Val setTextColor:[Command colorFromHexString:calcFontColor]];
            
            [self addSubview: m_l_Total_Val];
            
            [Command setAdjustWidthFrame:m_l_Total_Val];
            
            float fMove  = m_l_Total_Val.frame.origin.y + m_l_Total_Val.frame.size.height;
            fMove -= m_l_Total.frame.origin.y;
            fMove  = (delta - fMove)/2;
            
            m_l_Total.center  = CGPointMake( m_l_Total.center.x, m_l_Total.center.y + fMove);
            m_l_Since.center  = CGPointMake( m_l_Since.center.x, m_l_Since.center.y + fMove);
            m_l_Total_Val.center  = CGPointMake( m_l_Total_Val.center.x, m_l_Total_Val.center.y + fMove);
            
        }
        else{
            UILabel * m_l_Total  = [[UILabel alloc] initWithFrame:CGRectMake( width/ 3 + 5, 0 , restWidth-10, delta/2)];
            [m_l_Total setText: @"Total Generation"];
            [self addSubview: m_l_Total];
            [Command setAdjustHeightwithFixedWidth:m_l_Total];
            
            float oriY  = m_l_Total.frame.origin.y + m_l_Total.frame.size.height;
            UILabel * m_l_Since  = [[UILabel alloc] initWithFrame:CGRectMake( width/ 3 + 5,  oriY, restWidth * 2/3, delta/2)];
            [m_l_Since setText: [NSString stringWithFormat:@"since %@", date]];
            [m_l_Since setText: [NSString stringWithFormat:@"since %@", date]];
            [m_l_Since setTextColor:[UIColor lightGrayColor]];
            [m_l_Since setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
            
            [self addSubview: m_l_Since];
            [Command setAdjustHeightFrame:m_l_Since]; [Command setAdjustWidthFrame: m_l_Since];
            
            oriY = m_l_Since.frame.origin.y + m_l_Since.frame.size.height;
            UILabel * m_l_Total_Val  = [[UILabel alloc] initWithFrame:CGRectMake(m_l_Since.frame.origin.x ,  oriY, restWidth/3, delta/2)];
            [m_l_Total_Val setText: [NSString stringWithFormat:@"%.1f kW", [kwh doubleValue]]];
            [m_l_Total_Val setFont: [UIFont fontWithName: [Command checkFontName:calcFontName] size:calcFontSize]];
            [m_l_Total_Val setTextColor:[Command colorFromHexString:calcFontColor]];
            
            [self addSubview: m_l_Total_Val];

            [Command setAdjustWidthFrame:m_l_Total_Val];
            
            float fMove  = m_l_Total_Val.frame.origin.y + m_l_Total_Val.frame.size.height;
            fMove -= m_l_Total.frame.origin.y;
            fMove  = (delta - fMove)/2;
            
            m_l_Total.center  = CGPointMake( m_l_Total.center.x, m_l_Total.center.y + fMove);
            m_l_Since.center  = CGPointMake( m_l_Since.center.x, m_l_Since.center.y + fMove);
            m_l_Total_Val.center  = CGPointMake( m_l_Total_Val.center.x, m_l_Total_Val.center.y + fMove);
            
        }
    }
    
    if ( bReim )
    {
        UILabel * m_l_Reim  = [[UILabel alloc] initWithFrame:CGRectMake( width/ 3 + 5,  (nItemNum-1) * delta, restWidth -10, delta)];
        [m_l_Reim setText: @"Reimbursement :"];
        [m_l_Reim setFont:[UIFont fontWithName:[Command checkFontName: suppFontName] size:suppFontSize]];
        [m_l_Reim setTextColor: [Command colorFromHexString:suppFontColor]];
        
        [self addSubview: m_l_Reim];
        [Command setAdjustHeightwithFixedWidth:m_l_Reim];
        
        float oriY  = m_l_Reim.frame.origin.y + m_l_Reim.frame.size.height;
        UILabel * m_l_Reim_Val  = [[UILabel alloc] initWithFrame:CGRectMake( width/ 3 + 5 ,  oriY, restWidth -10, delta/2)];
        [m_l_Reim_Val setText: [NSString stringWithFormat:@"$ %.1f", [reim doubleValue] ]];
        [m_l_Reim_Val setTextColor:[Command colorFromHexString:calcFontColor]];
        
        [self addSubview: m_l_Reim_Val];
        [Command setAdjustHeightFrame: m_l_Reim_Val];
        
        float fMove  = m_l_Reim_Val.frame.origin.y + m_l_Reim_Val.frame.size.height;
        fMove -= m_l_Reim.frame.origin.y;
        fMove  = (delta - fMove)/2;
        
        m_l_Reim_Val.center  = CGPointMake( m_l_Reim_Val.center.x, m_l_Reim_Val.center.y + fMove);
        m_l_Reim.center  = CGPointMake( m_l_Reim.center.x, m_l_Reim.center.y + fMove);
        
    }
}

- (int) checkOptionNum
{
    int ret = 0;
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    bCurrent = [widget.param.widgetSolarGenerationCurrent boolValue];
    if ( bCurrent ) {
        ret ++;
    }
    bTotal = [widget.param.widgetSolarGenerationkWh boolValue];
    if ( bTotal ) {
        ret ++;
    }
    bReim = [widget.param.widgetSolarGenerationReimbursement boolValue];
    if ( bReim ) {
        ret ++;
    }
    
    return ret;
}

- (void) setAdjustFrame:(UILabel *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (CGFloat) getFontSize:(UILabel*) label
{
    CGFloat fontSize = 40;
    while (fontSize > 0.0)
    {
        CGFloat fixedHeight = label.frame.size.height;
        CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, fixedHeight)];
        if (size.height <= label.frame.size.height) break;
        fontSize -= 1.0;
    }

    return fontSize;
}

- (NSString*) GetMonth :(int) month
{
    return  sMonths[month+1];
}

- (NSString*) checkFontName:(NSString*) font
{
    if ( [font isEqualToString: @"BentonSans"] || [font isEqualToString:@"BentonSans, sans-serif"] ) {
        font  = @"Bangla Sangam MN";
    }else if ( [font isEqualToString:@"Arial Black"]){
        font = @"Arial Hebrew";
    }
    return  font;
}

////21. 34. 25.14.
//- (void) resizeAllSubview:(CGRect) frame origentation:(BOOL) bVertical
//{
//
//    _m_img_title_bg.layer.cornerRadius  = 5.0f;
//
//    NSArray * arr = [m_Info.startDate componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-T"]];
//    NSString * month = [arr objectAtIndex:1];
//    NSString * year  = [arr objectAtIndex:0];
//    NSString * day   = [arr objectAtIndex:2];
//
//
//    NSString * str = [NSString stringWithFormat:@"since %@ %@, %@", [self GetMonth: month.intValue], day, year];
//    NSNumber * kwh = m_Info.kWhGenerated;
//
//
//    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
//
//
//    if ( bVertical )
//    {
//        [_m_img_title_bg setFrame: CGRectMake(0, 0, 0.3f * frame.size.width, frame.size.height)];
//
//
//        [_m_l_title2 setFrame: CGRectMake(0.02f * frame.size.width, 0.12f * frame.size.height,  0.24f * frame.size.width, 0.08f * frame.size.height)];
//        [_m_l_title2 setText:@"Generation"];
//        [_m_l_title2 setFont:[UIFont systemFontOfSize:[self getFontSize: _m_l_title2]]];
//
//        [_m_l_title1 setFrame: CGRectMake(0.02f * frame.size.width, 0.04f * frame.size.height, 0.24f * frame.size.width, 0.08f * frame.size.height)];
//        [_m_l_title1 setText:@"Solar"];
//        [_m_l_title1 setFont:[UIFont systemFontOfSize:[self getFontSize: _m_l_title2]]];
//
//
//        [_m_l_Total setFrame:CGRectMake( 0.32f * frame.size.width, 0.44f * frame.size.height, 0.4f * frame.size.width, 0.08f * frame.size.height)];
//        [_m_l_Total setFont:[UIFont systemFontOfSize:[self getFontSize: _m_l_Total]]];
//
//        [_m_l_Since setFrame: CGRectMake( 0.32f * frame.size.width, 0.56f * frame.size.height, 0.65f * frame.size.width, 0.05f * frame.size.height)];
//        [_m_l_Since setFont:[UIFont systemFontOfSize:[self getFontSize: _m_l_Since]]];
//        [_m_l_Since setText: str];
//
//        [_m_l_kwh setFrame:CGRectMake( 0.72f * frame.size.width, 0.44f * frame.size.height, 0.3f * frame.size.width, 0.05f * frame.size.height)];
//        [_m_l_kwh setFont:[UIFont systemFontOfSize:[self getFontSize: _m_l_kwh]]];
//
//        [_m_l_kwh setText: [NSString stringWithFormat:@"%d kwh", (int)[kwh floatValue]]];
//
//    }
//    else
//    {
//        [_m_l_title2 setText:@""];
//        [_m_l_title1 setText:@"Solar Generation"];
//        [_m_img_title_bg setFrame: CGRectMake(0, 0, frame.size.width, 0.32f * frame.size.height)];
//
//        [_m_l_title1 setFrame: CGRectMake(0.06f * frame.size.width, 0.12f * frame.size.height, 0.8f * frame.size.width, 0.1f * frame.size.height)];
//        [_m_l_title1 setFont:[UIFont systemFontOfSize:[self getFontSize: _m_l_title1]]];
//
//        [_m_l_Total setFrame:CGRectMake( 0.06f * frame.size.width, 0.54f * frame.size.height, 0.8f * frame.size.width, 0.08f * frame.size.height)];
//        [_m_l_Total setFont:[UIFont systemFontOfSize:[self getFontSize: _m_l_Total]]];
//
//        [_m_l_Since setFrame: CGRectMake( 0.06f * frame.size.width, 0.6f * frame.size.height, 0.8f * frame.size.width, 0.08f * frame.size.height)];
//        [_m_l_Since setFont:[UIFont systemFontOfSize:[self getFontSize: _m_l_Since]]];
//        [_m_l_Since setText: str];
//
//        [_m_l_kwh setFrame:CGRectMake( 0.06f * frame.size.width, 0.7f * frame.size.height, 0.8f * frame.size.width, 0.12f * frame.size.height)];
//        [_m_l_kwh setFont:[UIFont systemFontOfSize:[self getFontSize: _m_l_kwh]]];
//        [_m_l_kwh setText: [NSString stringWithFormat:@"%d kwh", (int)[kwh floatValue]]];
//
//    }
//
//}


@end
