//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "GraphView.h"
#import "SharedMembers.h"
#import "SeriesItem.h"
#import "GraphPointInfo.h"
#import "Command.h"


int  LEFT_SPACE  = 10;
int  RIGHT_SPACE =   10;

#define  BOTTOM_SPACE 45
#define  TOP_SPACE    15

@interface GraphView()

@end

@implementation GraphView


NSString * sMonth[] = {
   @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"
};

- (void) awakeFromNib
{
    
}

// space : 30
// space : 45
//bottom:  45

- (UIColor *) colorFromHexString:(NSString *)hexString
{
    
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

- (void) setInfo:(GraphInfo*) info Widget:(PWidgetInfo*)widget  generation:(BOOL) bGeneration maxPower:(BOOL) bMax
{
    m_GenerationMax = 0;
    m_MaxPowerMax = 0;

    m_Info  = info;
    m_widget  = widget;
    
    
    m_bGeneration = bGeneration;
    m_bMaxPower  = bMax;
    

    
    if ( widget.param.backgroundImage ) {
        UIImage * image  = [UIImage imageNamed: widget.param.backgroundImage];
        UIImageView * imgView  = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [imgView setImage:image];
        [self addSubview: imgView];
    }else{

    }
    
    if ( widget.param.backgroundColor) {
        [self setBackgroundColor:[self colorFromHexString:widget.param.backgroundColor]];
    }else{
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    headerFont * title  = widget.param.headerFnt;
    if ( title ) {
        
        double font = [title.size doubleValue];
        
        [_m_txtHeader setFont: [UIFont fontWithName: [self checkFontName:title.name] size: (int)(font*10)]];
        [_m_txtHeader setTextColor:[self colorFromHexString: title.color]];
        
        [_m_txtHeader setFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {

            if( str != nil )
                if ( ![str isEqualToString:@""]) {
            [_m_txtHeader setHidden: false];
            [_m_txtHeader setText: title.content];
                }

        }else{
            [_m_txtHeader setHidden: true];
        }
    }
    
    primaryColor * titleBgClr  = widget.param.primaryClr;
    if ( titleBgClr ) {
        [_m_txtHeader setBackgroundColor:[self colorFromHexString: titleBgClr.color]];
    }
    
    secondaryColor * generationDic  = widget.param.secondaryClr;
    if ( generationDic ) {
        generationClr = [self colorFromHexString: generationDic.color];
    }
    
    sixthColor * maxDic  = widget.param.sixthClr;
    if ( maxDic ) {
        maxClr = [self colorFromHexString: maxDic.color];
    }
    
    [self setNeedsDisplay];
}

- (void) drawBottom:(UIView*) v
{
    
}

- (void) drawDatas:(UIView*) v Max:(float) max Type:(int) type Data:(NSMutableArray*) datas  Color:(UIColor*) clr Index:(int) idx Series:(NSMutableArray*) series
{
    if( max <= 0 )
        return;
    
    if ( m_Info == nil ) {
        [v setBackgroundColor:[UIColor whiteColor]];
        return;
    }

    
    // The color to fill the rectangle (in this case black)
    
    normal2Font * basicDic  = m_widget.param.normal2Fnt;
    secondaryColor * generationDic  = m_widget.param.secondaryClr;
    tertiaryColor * temperatureDic  = m_widget.param.tertiaryClr;
    fifthColor * currentDic  = m_widget.param.fifthClr;
    fourthColor * humidityDic  = m_widget.param.fourthClr;
    sixthColor * maxDic  = m_widget.param.sixthClr;
    seventhColor * weatherDic  = m_widget.param.seventhClr;

    
    float LineSpace  = v.frame.size.height - BOTTOM_SPACE;
    
    float step  = (LineSpace  - BOTTOM_SPACE)/ max;

    float valDelta  = max / 8;
    
    // Left Values
    if ( type < 2 ) {
        for ( int i = 0; i < 9; i++ )
        {
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake( 10 + 50 * idx, 0, 40, 15)];
            if ( max > 10 ) {
                [label setText: [NSString stringWithFormat:@"%d", (int)(i*valDelta) ]];
            }
            else{
                [label setText: [NSString stringWithFormat:@"%.2f", (i*valDelta) ]];
            }
            
            [label setFont: [UIFont fontWithName:[Command checkFontName: basicDic.name] size:[basicDic.size intValue] * 10]];
            [label setTextColor:[Command colorFromHexString:basicDic.color]];
            
            [self addSubview: label];
            label.center = CGPointMake( label.center.x, v.frame.size.height  - step * i * valDelta - BOTTOM_SPACE);
        }
    }

    
    
    if ( m_bFillColor == false ) {

        m_bFillColor = true;
        
        // Background Color
        
        CGContextRef contextBody = UIGraphicsGetCurrentContext ();
        const CGFloat *components = CGColorGetComponents([Command colorFromHexString:m_widget.param.backgroundColor].CGColor);
        CGFloat r = components[0];
        CGFloat g = components[1];
        CGFloat b = components[2];
        CGContextSetRGBFillColor(contextBody, r, g, b, 1.0);
        // draw the filled rectangle
        CGContextFillRect (contextBody, self.bounds);

       
        
        // Line Draw
        for ( int i = 0; i < 9; i++ )
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
            if ( i == 0 ) {
                CGContextSetLineWidth(context, 2.0);
            }
            else
                CGContextSetLineWidth(context, 0.5);

            CGContextBeginPath(context);
            CGContextMoveToPoint(context, LEFT_SPACE, v.frame.size.height  - step * i * valDelta - BOTTOM_SPACE);
            CGContextAddLineToPoint(context, v.frame.size.width - RIGHT_SPACE, v.frame.size.height - step * i * valDelta - BOTTOM_SPACE);
            CGContextStrokePath(context);
            CGContextClosePath(context);
            
        }

       /// Date in Bottom
        
        int num = 6;
        if ( [datas count] < 6 ) {
            num  = [datas count];
        }
        float dateDelta  = (v.frame.size.width - LEFT_SPACE - RIGHT_SPACE) / num;
        int    bottomFont   = 0;
        for ( int i = 0; i < num; i++ )
        {
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
            CGContextSetLineWidth(context, 0.5);
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, dateDelta/2 + LEFT_SPACE + dateDelta * i , v.frame.size.height - BOTTOM_SPACE);
            CGContextAddLineToPoint(context,dateDelta/2 + LEFT_SPACE + dateDelta * i, v.frame.size.height + 5 - BOTTOM_SPACE);
            CGContextStrokePath(context);
            CGContextClosePath(context);
            
            NSString * sDate = @"";
            
            NSString * interval = (m_widget.param.widgetGraphInterval).lowercaseString;
            if(  [interval isEqualToString:@"yearly"] )
            {
                GraphPointInfo * point = [datas objectAtIndex: i*[datas count]/num];
                //"2015-01-18T09:17:50.000Z"
                NSString * date = point.t;
                NSArray * arr  = [date componentsSeparatedByString:@"T"];
                NSArray * arrSub = [[arr objectAtIndex:0] componentsSeparatedByString:@"-"];
              
                sDate = [NSString stringWithFormat:@"%@", [arrSub objectAtIndex:0]];

            }
            else if ( [interval isEqualToString:@"monthly"]){
                
                GraphPointInfo * point = [datas objectAtIndex: i*[datas count]/num];
                //"2015-01-18T09:17:50.000Z"
                NSString * date = point.t;
                NSArray * arr  = [date componentsSeparatedByString:@"T"];
                NSArray * arrSub = [[arr objectAtIndex:0] componentsSeparatedByString:@"-"];
                int j  = [[arrSub objectAtIndex:1] integerValue];
                
                sDate = [NSString stringWithFormat:@"%@ %@",  sMonth[j-1], [arrSub objectAtIndex:0] ];
                
            }
            else if ( [interval isEqualToString:@"weekly"]){
                GraphPointInfo * point = [datas objectAtIndex: i*[datas count]/num];
                //"2015-01-18T09:17:50.000Z"
                NSString * date = point.t;
                NSArray * arr  = [date componentsSeparatedByString:@"T"];
                NSArray * arrSub = [[arr objectAtIndex:0] componentsSeparatedByString:@"-"];
                
                int j  = [[arrSub objectAtIndex:1] integerValue];
                
                sDate = [NSString stringWithFormat:@"%@ %@",   sMonth[j-1], [arrSub objectAtIndex:0] ];
                
            }
            else if ( [interval isEqualToString:@"daily"]){
                
                GraphPointInfo * point = [datas objectAtIndex: i*[datas count]/num];
                //"2015-01-18T09:17:50.000Z"
                NSString * date = point.t;
                NSArray * arr  = [date componentsSeparatedByString:@"T"];
                NSArray * arrSub = [[arr objectAtIndex:0] componentsSeparatedByString:@"-"];

                int j  = [[arrSub objectAtIndex:1] integerValue];
                sDate = [NSString stringWithFormat:@"%@ %@",   sMonth[j-1] ,  [arrSub objectAtIndex:2]];
                
            }
            else if ( [interval isEqualToString:@"hourly"]){
                GraphPointInfo * point = [datas objectAtIndex: i*[datas count]/num];
                //"2015-01-18T09:17:50.000Z"
                NSString * date = point.t;
                NSArray * arr  = [date componentsSeparatedByString:@"T"];
                NSArray * arrSub = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
                
                sDate = [NSString stringWithFormat:@"%@:%@",   [arrSub objectAtIndex:0] ,  [arrSub objectAtIndex:1]];

            }
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake( 0, v.frame.size.height + 10 - BOTTOM_SPACE, dateDelta, 20)];
            [label setText: sDate];
            
            if ( i == 0) {
                bottomFont = [Command getFontSize:label];
            }
            
            [label setFont: [UIFont systemFontOfSize: bottomFont]];
            [Command setAdjustWidthFrame:label];
            [Command setAdjustHeightFrame:label];
            [self addSubview: label];
            label.center = CGPointMake( dateDelta/2 + LEFT_SPACE + dateDelta * i, label.center.y);

        }
        
        /// Buttons in Bottom
        
        UIImageView * imgbtnBgView;
        imgbtnBgView  = [[UIImageView alloc] initWithFrame:CGRectMake( 0,  v.frame.size.height - BOTTOM_SPACE, 30, 30)];
        [imgbtnBgView setImage:[UIImage imageNamed:@"graph_btn_bg"]];
        [self addSubview: imgbtnBgView];

        
        float offset  = 0;
        for ( int i = 0 ; i < [series count]; i++ ) {

            SeriesItem * item =  [m_Info.series objectAtIndex:i];
            UIColor * color ;
            NSString * imgName ;
            
            int flag = 1;
            if ( [item.name isEqualToString:@"Generation"] ) {
                NSString * sType = m_widget.param.widgetGraphGenerationChartType;
                if( [sType.lowercaseString isEqualToString:@"line"] ){
                    imgName = @"line_icon.png";
                }
                else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                    imgName = @"bar_icon.png";
                }
                color  = [Command colorFromHexString:generationDic.color];
                flag = [m_widget.param.widgetGraphGeneration intValue];
            }
            else if ( [item.name isEqualToString:@"Current Power"] )
            {
                NSString * sType = m_widget.param.widgetGraphCurrentPowerChartType;
                if( [sType.lowercaseString isEqualToString:@"line"] ){
                    imgName = @"line_icon.png";
                }
                else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                    imgName = @"bar_icon.png";
                }
                color  = [Command colorFromHexString:currentDic.color];
                flag = [m_widget.param.widgetGraphCurrentPower intValue];
            }
            else if ( [item.name isEqualToString:@"Max Power"] )
            {
                NSString * sType = m_widget.param.widgetGraphMaxPowerChartType;
                if( [sType.lowercaseString isEqualToString:@"line"] ){
                    imgName = @"line_icon.png";
                }
                else if ( [sType.lowercaseString isEqualToString:@"bar"] || [sType.lowercaseString isEqualToString:@"false"]){
                    imgName = @"bar_icon.png";
                }
                color = [Command colorFromHexString: maxDic.color ];
                flag = [m_widget.param.widgetGraphMaxPower intValue];
            }
            else if ( [item.name isEqualToString:@"Humidity"] )
            {
                NSString * sType = m_widget.param.widgetGraphHumidityChartType;
                if( [sType.lowercaseString isEqualToString:@"line"] ){
                    imgName = @"line_icon.png";
                }
                else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                    imgName = @"bar_icon.png";
                }
                color = [Command colorFromHexString:humidityDic.color];
                flag = [m_widget.param.widgetGraphHumidity intValue];
            }
            else if ( [item.name isEqualToString:@"Temperature"] )
            {
                NSString * sType = m_widget.param.wIdgetGraphTemperatureChartType;
                
                if( [sType.lowercaseString isEqualToString:@"line"] ){
                    imgName = @"line_icon.png";
                }
                else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                    imgName = @"bar_icon.png";
                }
                color  = [Command colorFromHexString:temperatureDic.color];
                
                flag  =  [m_widget.param.widgetGraphTemperature intValue];
            }
            else if ( [item.name isEqualToString:@"Weather"] )
            {
                imgName = @"line_icon.png";
                color  = [Command colorFromHexString:   weatherDic.color];
                flag = [m_widget.param.widgetGraphWeather intValue];
            }

            
            UIImage * image ;
            if ( flag == 1 ) {
                image    = [Command imageNamed:imgName withColor:color];
            }
            else{
                image    = [Command imageNamed:imgName withColor:[UIColor lightGrayColor]];
            }

            UIImageView * imgView;
            if ( [imgName isEqualToString:@"bar_icon.png"] ) {
                imgView  = [[UIImageView alloc] initWithFrame:CGRectMake( offset,  v.frame.size.height - BOTTOM_SPACE, 10, 10)];
            }
            else{
                imgView  = [[UIImageView alloc] initWithFrame:CGRectMake( offset,  v.frame.size.height - BOTTOM_SPACE, 15, 15)];
            }

            [imgView setImage: image];
            imgView.tag = 10 + i;
            [v addSubview:imgView];
            
            UILabel * txt = [[UILabel alloc] initWithFrame: CGRectMake( offset + 15,  v.frame.size.height - BOTTOM_SPACE, 50, 20)];
            [txt setBackgroundColor:[UIColor clearColor]];
            [txt setText: item.name];
            [txt setFont: [UIFont systemFontOfSize:12]];
            txt.tag = 10 + i;
            [v addSubview: txt];
            [Command setAdjustWidthFrame:txt];
            [Command setAdjustHeightFrame:txt];
            
            imgView.center = CGPointMake(imgView.center.x, txt.center.y);
            offset = txt.frame.size.width + txt.frame.origin.x + 10;
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self
                       action:@selector(onSelectType:)
             forControlEvents:UIControlEventTouchUpInside];
            button.tag  = 10 + i;
            button.frame = CGRectMake(imgView.frame.origin.x, v.frame.size.height - BOTTOM_SPACE, txt.frame.size.width + txt.frame.origin.x - imgView.frame.origin.x, 30);
            [v addSubview:button];
            
        }
        
        float move  = (v.frame.size.width - offset)/2;
        float height  = 0;
        
        for ( UIView * subV in [v subviews] ) {
            if ( subV.tag >= 10 ) {
                subV.center = CGPointMake( subV.center.x + move, subV.center.y + 10);
                height  = subV.center.y + 10;
            }
        }
        
        
        [imgbtnBgView setFrame:CGRectMake(0,  v.frame.size.height - BOTTOM_SPACE + 35, offset + 20, imgbtnBgView.frame.size.height) ];
        imgbtnBgView.center  = CGPointMake( v.center.x, imgbtnBgView.center.y);
        
        
    }
    
    // Draw Datas
    if ( type  == 1 ) {
        float deltaX;
        deltaX = (v.frame.size.width - LEFT_SPACE - RIGHT_SPACE) / [datas count];
        if ( [datas count] > 0 ) {
            for ( int i = 0; i < [datas count]; i++  )
            {
                GraphPointInfo * point = [datas objectAtIndex:i];
                double y  = [point.y doubleValue];
                
                if ( !clr ) {
                    clr = [UIColor blackColor];
                }
                
                const CGFloat *components = CGColorGetComponents(clr.CGColor);
                CGFloat r = components[0];
                CGFloat g = components[1];
                CGFloat b = components[2];
                
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetRGBStrokeColor(context, r, g, b, 1.0);
                CGContextSetLineWidth(context, deltaX/5);
                
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, LEFT_SPACE + deltaX/2 + deltaX * i , v.frame.size.height - BOTTOM_SPACE);
                CGContextAddLineToPoint(context, LEFT_SPACE + deltaX/2 + deltaX * i, v.frame.size.height  - step * y - BOTTOM_SPACE);
                CGContextStrokePath(context);
                CGContextClosePath(context);
            }
        }

    }
    else if ( type  == 0 ){
        float deltaX;
        deltaX = (v.frame.size.width - LEFT_SPACE - RIGHT_SPACE) / [datas count];
        if ( [datas count] > 0 ) {
            for ( int i = 0; i < [datas count]-1; i++  )
            {
                GraphPointInfo * point = [datas objectAtIndex:i];
                GraphPointInfo * point1 = [datas objectAtIndex:i+1];
                double y  = [point.y doubleValue];
                double y1  = [point1.y doubleValue];
                
                const CGFloat *components = CGColorGetComponents(clr.CGColor);
                CGFloat r = components[0];
                CGFloat g = components[1];
                CGFloat b = components[2];
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetRGBStrokeColor(context, r, g, b, 1.0);
                CGContextSetLineWidth(context, 3);
                
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, LEFT_SPACE + deltaX/2 + deltaX * i, v.frame.size.height  - step * y - BOTTOM_SPACE);
                CGContextAddLineToPoint(context, LEFT_SPACE  + deltaX/2 + deltaX * (i+1), v.frame.size.height  - step * y1 - BOTTOM_SPACE);
                CGContextStrokePath(context);
                CGContextClosePath(context);
                
                /* Draw a circle */
                // Get the contextRef
                CGContextRef contextRef = UIGraphicsGetCurrentContext();
                
                // Set the border width
                CGContextSetLineWidth(contextRef, 1.0);
                
                // Set the circle fill color to GREEN
                CGContextSetRGBFillColor(contextRef, r, g, b, 1.0);
                
                // Set the cicle border color to BLUE
                CGContextSetRGBStrokeColor(contextRef, r, g, b, 1.0);
                
                // Fill the circle with the fill color
                CGContextFillEllipseInRect(contextRef, CGRectMake(LEFT_SPACE+ deltaX/2 + deltaX * i-5, v.frame.size.height  - step * y-5 - BOTTOM_SPACE, 10, 10) );
                
                // Draw the circle border
                CGContextStrokeEllipseInRect(contextRef, CGRectMake(LEFT_SPACE+ deltaX/2 + deltaX * i-5, v.frame.size.height  - step * y-5 - BOTTOM_SPACE, 10, 10) );
            }
        }
     
    }
    else if ( type == 2){
        
    }
}

- (void) onSelectType:(UIButton*) btn
{
    int tag  = btn.tag;
    for ( UIView * subV in [self subviews] ) {
        if ( subV.tag == 102 ) {
            for ( UIView * subSmallV in [subV subviews] ) {
                if ( subSmallV.tag == tag ) {

                    normal2Font * basicDic  = m_widget.param.normal2Fnt;
                    secondaryColor * generationDic  = m_widget.param.secondaryClr;
                    tertiaryColor * temperatureDic  = m_widget.param.tertiaryClr;
                    fifthColor * currentDic  = m_widget.param.fifthClr;
                    fourthColor * humidityDic  = m_widget.param.fourthClr;
                    sixthColor * maxDic  = m_widget.param.sixthClr;
                    seventhColor * weatherDic  = m_widget.param.seventhClr;
                    
                    
                    SeriesItem * item =  [m_Info.series objectAtIndex:tag-10];
                    UIColor * color ;
                    NSString * imgName ;
                    
                    if ( [item.name isEqualToString:@"Generation"] ) {
                        NSString * sType = m_widget.param.widgetGraphGenerationChartType;
                        if( [sType.lowercaseString isEqualToString:@"line"] ){
                            imgName = @"line_icon.png";
                        }
                        else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                            imgName = @"bar_icon.png";
                        }
                        
                        
                        NSNumber * flag = m_widget.param.widgetGraphGeneration;
                        
                        if ( [flag intValue] == 1 ) {
                            m_widget.param.widgetGraphGeneration = [NSNumber numberWithInt:0];
                            color  = [UIColor lightGrayColor];
                        }
                        else{
                            m_widget.param.widgetGraphGeneration = [NSNumber numberWithInt:1];
                            color  = [Command colorFromHexString:generationDic.color];
                        }
                    }
                    else if ( [item.name isEqualToString:@"Current Power"] )
                    {
                        NSString * sType = m_widget.param.widgetGraphCurrentPowerChartType;
                        if( [sType.lowercaseString isEqualToString:@"line"] ){
                            imgName = @"line_icon.png";
                        }
                        else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                            imgName = @"bar_icon.png";
                        }
                        color  = [Command colorFromHexString:currentDic.color];
                        
                        NSNumber * flag = m_widget.param.widgetGraphCurrentPower;
                        
                        if ( [flag intValue] == 1 ) {
                            m_widget.param.widgetGraphCurrentPower = [NSNumber numberWithInt:0];
                            color  = [UIColor lightGrayColor];
                        }
                        else{
                            m_widget.param.widgetGraphCurrentPower = [NSNumber numberWithInt:1];
                            color  = [Command colorFromHexString:generationDic.color];
                        }
                        
                    }
                    else if ( [item.name isEqualToString:@"Max Power"] )
                    {
                        NSString * sType = m_widget.param.widgetGraphMaxPowerChartType;
                        if( [sType.lowercaseString isEqualToString:@"line"] ){
                            imgName = @"line_icon.png";
                        }
                        else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                            imgName = @"bar_icon.png";
                        }
                        color = [Command colorFromHexString: maxDic.color ];
                        
                        NSNumber * flag = m_widget.param.widgetGraphMaxPower;
                        
                        if ( [flag intValue] == 1 ) {
                            m_widget.param.widgetGraphMaxPower = [NSNumber numberWithInt:0];
                            color  = [UIColor lightGrayColor];
                        }
                        else{
                            m_widget.param.widgetGraphMaxPower = [NSNumber numberWithInt:1];
                            color  = [Command colorFromHexString:generationDic.color];
                        }
                        
                        
                    }
                    else if ( [item.name isEqualToString:@"Humidity"] )
                    {
                        NSString * sType = m_widget.param.widgetGraphHumidityChartType;
                        if( [sType.lowercaseString isEqualToString:@"line"] ){
                            imgName = @"line_icon.png";
                        }
                        else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                            imgName = @"bar_icon.png";
                        }
                        color = [Command colorFromHexString:humidityDic.color];
                        
                        NSNumber * flag = m_widget.param.widgetGraphHumidity;
                        
                        if ( [flag intValue] == 1 ) {
                            m_widget.param.widgetGraphHumidity = [NSNumber numberWithInt:0];
                            color  = [UIColor lightGrayColor];
                        }
                        else{
                            m_widget.param.widgetGraphHumidity = [NSNumber numberWithInt: 1];
                            color  = [Command colorFromHexString:generationDic.color];
                        }
                        
                        
                    }
                    else if ( [item.name isEqualToString:@"Temperature"] )
                    {
                        NSString * sType = m_widget.param.wIdgetGraphTemperatureChartType;
                        
                        if( [sType.lowercaseString isEqualToString:@"line"] ){
                            imgName = @"line_icon.png";
                        }
                        else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                            imgName = @"bar_icon.png";
                        }
                        color  = [Command colorFromHexString:temperatureDic.color];
                        
                        NSNumber * flag = m_widget.param.widgetGraphTemperature;
                        
                        if ( [flag intValue] == 1 ) {
                            m_widget.param.widgetGraphTemperature = [NSNumber numberWithInt:0];
                            color  = [UIColor lightGrayColor];
                        }
                        else{
                            m_widget.param.widgetGraphTemperature = [NSNumber numberWithInt:1];
                            color  = [Command colorFromHexString:generationDic.color];
                        }
                        
                        
                    }
                    else if ( [item.name isEqualToString:@"Weather"] )
                    {
                        imgName = @"line_icon.png";
                        color  = [Command colorFromHexString:   weatherDic.color];
                        
                        NSNumber * flag = m_widget.param.widgetGraphWeather;
                        
                        if ( [flag boolValue] ) {
                            m_widget.param.widgetGraphWeather = [NSNumber numberWithInt:0];
                            color  = [UIColor lightGrayColor];
                        }
                        else{
                            m_widget.param.widgetGraphWeather = [NSNumber numberWithInt:1];
                            color  = [Command colorFromHexString:generationDic.color];
                        }
                        
                    }
                    
                }
            }
        }
    }

    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    
    for ( UIView * v in [self subviews]) {
        [v removeFromSuperview];
    }

    UITextView * txt  = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, 50)];
    [txt setUserInteractionEnabled:false];
    
    if ( ![m_widget.name isEqualToString:@"Graph"] ) {
        return;
    }
    
    headerFont * title  = m_widget.param.headerFnt;
    if ( title ) {
        
        double font = [title.size doubleValue];
        
        NSString * fontName  = [self checkFontName:title.name];
        [txt setFont: [UIFont fontWithName: @"Arial" size: (int)(font*10)]];
        [txt setTextColor:[self colorFromHexString: title.color]];
        
        [txt setFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {
            if ( str ) {
                if ( ![str isEqualToString:@""] ) {
                    [txt setHidden: false];
                    [txt setText: [NSString stringWithFormat:@"     %@", title.content]];
                }
                else
                    [txt setHidden: true];
            }
            else
            {
                [txt setHidden: true];
            }
        }else{
                [txt setHidden: true];
        }
        [self addSubview: txt];
    }
    
    [Command setAdjust_TextView_HeightwithFixedWidth: txt];
    
    primaryColor * titleBgClr  = m_widget.param.primaryClr;
    if ( titleBgClr ) {
        [txt setBackgroundColor:[self colorFromHexString: titleBgClr.color]];
    }
    
    UIView * drawView  = [[UIView alloc] initWithFrame:CGRectMake(0,txt.frame.size.height, self.frame.size.width, self.frame.size.height - txt.frame.size.height)];
    [drawView setBackgroundColor:[UIColor clearColor]];
    drawView.tag = 102;
    [self addSubview: drawView];
    
    normal2Font * basicDic  = m_widget.param.normal2Fnt;
    secondaryColor * generationDic  = m_widget.param.secondaryClr;
    tertiaryColor * temperatureDic  = m_widget.param.tertiaryClr;
    fifthColor * currentDic  = m_widget.param.fifthClr;
    fourthColor * humidityDic  = m_widget.param.fourthClr;
    sixthColor * maxDic  = m_widget.param.sixthClr;
    seventhColor * weatherDic  = m_widget.param.seventhClr;
    
    m_bFillColor  = false;
    
    int Type  = 0; // 0: Line   1: bar
    int idx   = 0;
     LEFT_SPACE = 10 + 50 * [m_Info.series count];
    for ( SeriesItem * item in m_Info.series) {
        
        float max  = 0;
        UIColor * color ;
        if ( [item.datas count] > 0 ) {
            for ( int i = 0; i < [item.datas count]; i++  )
            {
                GraphPointInfo * point = [item.datas objectAtIndex:i];
                double y  = [point.y doubleValue];
                (max < y) ? max = y : max;
            }
        }
        
        if ( [item.name isEqualToString:@"Generation"] ) {
            NSString * sType = m_widget.param.widgetGraphGenerationChartType;
            if( [sType.lowercaseString isEqualToString:@"line"] ){
                Type = 0;
            }
            else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                Type = 1;
            }
            color  = [Command colorFromHexString:generationDic.color];

            NSNumber * flag = m_widget.param.widgetGraphGeneration;
            if ( [flag intValue] == 0 ) {
                Type = 5;
            }
            [self drawDatas:drawView Max:max Type:Type Data:item.datas Color:color Index:idx Series:m_Info.series];
            idx ++;
        }
        else if ( [item.name isEqualToString:@"Current Power"] )
        {
            NSString * sType = m_widget.param.widgetGraphCurrentPowerChartType;
            if( [sType.lowercaseString isEqualToString:@"line"] ){
                Type = 0;
            }
            else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                Type = 1;
            }
            color  = [Command colorFromHexString:currentDic.color];
            NSNumber * flag = m_widget.param.widgetGraphCurrentPower;
            if ( [flag intValue] == 0) {
                Type = 5;
            }
            [self drawDatas:drawView Max:max Type:Type Data:item.datas Color:color Index:idx Series:m_Info.series];
            idx ++;
        }
        else if ( [item.name isEqualToString:@"Max Power"] )
        {
            NSString * sType = m_widget.param.widgetGraphMaxPowerChartType;
            if( [sType.lowercaseString isEqualToString:@"line"] ){
                Type = 0;
            }
            else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                Type = 1;
            }
            color = [Command colorFromHexString: maxDic.color ];

             NSNumber * flag = m_widget.param.widgetGraphMaxPower;
            if ( [flag intValue] == 0 ) {
                Type = 5;
            }
            [self drawDatas:drawView Max:max Type:Type Data:item.datas Color:color Index:idx Series:m_Info.series];
            idx ++;
        }
        else if ( [item.name isEqualToString:@"Humidity"] )
        {
            NSString * sType = m_widget.param.widgetGraphHumidityChartType;
            if( [sType.lowercaseString isEqualToString:@"line"] ){
                Type = 0;
            }
            else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                Type = 1;
            }
            color = [Command colorFromHexString:humidityDic.color];
            NSNumber * flag = m_widget.param.widgetGraphHumidity;
            if ( [flag intValue] == 0 ) {
                Type = 5;
            }
            [self drawDatas:drawView Max:max Type:Type Data:item.datas Color:color Index:idx Series:m_Info.series];
            idx ++;
        }
        else if ( [item.name isEqualToString:@"Temperature"] )
        {
            NSString * sType = m_widget.param.wIdgetGraphTemperatureChartType;
            
            if( [sType.lowercaseString isEqualToString:@"line"] ){
                Type = 0;
            }
            else if ( [sType.lowercaseString isEqualToString:@"bar"] ){
                Type = 1;
            }
            color  = [Command colorFromHexString:temperatureDic.color];
            NSNumber * flag = m_widget.param.widgetGraphTemperature;
            if ( [flag intValue] == 0 ) {
                Type = 5;
            }
            [self drawDatas:drawView Max:max Type:Type Data:item.datas Color:color Index: idx Series:m_Info.series];
            idx ++;
        }
        else if ( [item.name isEqualToString:@"Weather"] )
        {
            Type = 0;
            color  = [Command colorFromHexString:   weatherDic.color];
            NSNumber * flag = m_widget.param.widgetGraphWeather;
            if ( [flag intValue] == 0 ) {
                Type = 5;
            }
            [self drawDatas:drawView Max:max Type:Type Data:item.datas Color:color Index: idx Series:m_Info.series];
            idx ++;
        }
    }
}

- (void) onGeneration:(id) sender
{
    UIButton * btn  = (UIButton*)sender;
    m_bGeneration = !m_bGeneration;
    if ( m_bGeneration ) {
        [btn setImage:[UIImage imageNamed:@"btn_generation_on.png"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"btn_generation_off.png"] forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}

- (void) onMaxPower:(id) sender
{
    UIButton * btn  = (UIButton*)sender;
    m_bMaxPower = !m_bMaxPower;
    if ( m_bMaxPower ) {
        [btn setImage:[UIImage imageNamed:@"btn_maxpower_on.png"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"btn_maxpower_off.png"] forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
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

@end
