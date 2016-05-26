//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "WeatherView.h"

#import "SharedMembers.h"
#import "Command.h"

@interface WeatherView()

@end

@implementation WeatherView

NSString *  sArrow[] = {
    @"arrow_0.png", @"arrow_0_90.png", @"arrow_90.png", @"arrow_90_180.png",@"arrow_180.png",@"arrow_180_270.png",@"arrow_270.png",@"arrow_270_360.png"
};

- (void) awakeFromNib
{

}

- (void) setRefresh:(WeatherInfo*) info Col:(int) col Row:(int) row
{
    m_Info = info;
}

- (void) resizeAllSubview:(CGRect) frame
{
    m_width  = frame.size.width;
    m_height = frame.size.height;
    
    PWidgetInfo *  info  = [SharedMembers sharedInstance].curWidget;
    
    [self setFrame:frame];
    [_m_vMini setFrame:frame];   _m_vMini.layer.cornerRadius  = 10.0f;
    [_m_vDetail setFrame:frame]; _m_vDetail.layer.cornerRadius  = 10.f;
    
    if ( [info.param.widgetWeatherType isEqualToString:@"Minimal"] ) {
        [self setAdjustMiniFrame];
    }
    else{
        [self setAdjustDetailFrame];
    }
}

- (void) setInfo
{
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    if ( [widget.param.widgetWeatherType isEqualToString:@"Minimal"] ) {
        if ( widget.param.backgroundColor) {
            [_m_vMini setBackgroundColor: [Command colorFromHexString: widget.param.backgroundColor]];
        }else{
            [_m_vMini setBackgroundColor: [UIColor whiteColor]];
        }
        
        headerFont * title  = widget.param.headerFnt;
        if ( title ) {
            double font = [title.size doubleValue];
            [_m_l_top_mini setFont:[UIFont fontWithName: title.name size: (int)(font*10)]];
            [_m_l_top_mini setTextColor: [Command colorFromHexString: title.color]];
            
            
            NSString * str  =  title.content;
            if ( ![str isKindOfClass:[NSNull class]] ) {
                [_m_l_top_mini setText: title.content];
            }
        }
        
        primaryColor * titleBgClr  = widget.param.primaryClr;
        if ( titleBgClr ) {
            [_m_img_top_mini setBackgroundColor:[Command colorFromHexString: titleBgClr.color]];
        }
        
        normal1Font * weatherDic  = widget.param.normal1Fnt;
        if ( weatherDic ) {
            double font = [weatherDic.size doubleValue];
            [_m_l_state setFont:[UIFont fontWithName: weatherDic.name size: (int)(font*10)]];
            [_m_l_state setTextColor: [Command colorFromHexString: weatherDic.color]];
        }
    }
    else{
        if ( widget.param.backgroundColor) {
            [_m_vDetail setBackgroundColor: [Command colorFromHexString: widget.param.backgroundColor]];
        }else{
            [_m_vDetail setBackgroundColor: [UIColor whiteColor]];
        }
        
        headerFont * title  = widget.param.headerFnt;
        if ( title ) {
            double font = [title.size doubleValue];
            [_m_l_top setFont:[UIFont fontWithName: title.name size: (int)(font*10)]];
            [_m_l_top setTextColor: [Command colorFromHexString: title.color]];

            
            NSString * str  = title.content;
            if ( ![str isKindOfClass:[NSNull class]] ) {
                [_m_l_top setText: title.content];
            }
        }
        
        primaryColor * titleBgClr  = widget.param.primaryClr;
        if ( titleBgClr ) {
            [_m_imgTop setBackgroundColor:[Command colorFromHexString: titleBgClr.color]];
            [_m_vtempView setBackgroundColor: [Command colorFromHexString: titleBgClr.color]];
        }
        
        normal1Font * weatherDic  = widget.param.normal1Fnt;
        if ( weatherDic ) {
            double font = [weatherDic.size doubleValue];
//            [_m_l_weather setFont:[UIFont fontWithName:[weatherDic objectForKey:@"name"] size: (int)(font*10)]];
            [_m_l_weather setTextColor: [Command colorFromHexString: weatherDic.color]];
        }
        
        normal2Font * basicDic  = widget.param.normal2Fnt;
        if ( basicDic ) {
            double font = [title.size doubleValue];
            //        [_m_txt_MeasureFontSize setText: [NSString stringWithFormat:@"%.2f", font]];
            //        [_m_txt_MeasureFontName setText: [basicDic objectForKey:@"name"]];
            //        [_m_txt_MeasureFontColor setText: [basicDic objectForKey:@"color"]];
            //
            //        [_m_imgClr5 setBackgroundColor:[self colorFromHexString1:[basicDic objectForKey:@"color"]]];
        }
        
        
        double pressure  = [m_Info.pressure doubleValue];
        [_m_l_pressure_val setText:[NSString stringWithFormat:@"%.1f", pressure]];
        
        int visibility = [m_Info.visibility intValue];
        [_m_l_visibility_val setText: [NSString stringWithFormat:@"%d", visibility]];
        
        double wind  = [m_Info.windSpeed doubleValue];
        [_m_l_wind_val_detail setText: [NSString stringWithFormat:@"%.2f", wind]];
        
        double humidity  = [m_Info.humidity doubleValue];
        [_m_l_humidity_val setText: [NSString stringWithFormat:@"%d", (int)humidity]];
        
        NSString * icon = [NSString stringWithFormat:@"%@.png", m_Info.icon];
        [_m_imgIcon setImage:[UIImage imageNamed:icon]];
        
        
        int windBearing = [m_Info.windBearing intValue];
        [_m_imgArrow setImage: [UIImage imageNamed:[self GetArrowImagePath:windBearing]]];
    }
}

- (CGFloat) getLengthOfLabel:(UILabel*) label
{
    NSString *yourString = label.text;
    CGSize s = [yourString sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode: NSLineBreakByWordWrapping];
    return  s.width;
}

- (NSString*) GetArrowImagePath:(int) val
{
    NSString * ret;
    if ( val >= 337 || val < 23) {
        ret = sArrow[0];
    } else if (val >= 23 && val < 68) {
        ret = sArrow[1];
    } else if (val >= 68 && val < 113) {
        ret = sArrow[2];
    } else if (val >= 113 &&
               val < 158) {
        ret = sArrow[3];
    } else if (val >= 158 &&
               val < 203) {
        ret = sArrow[4];
    } else if (val >= 203 &&
               val < 248) {
        ret = sArrow[5];
    } else if (val >= 248 &&
               val < 293) {
        ret = sArrow[6];
    } else if (val >= 293 &&
               val < 337) {
        ret = sArrow[7];
    }
    
    return  ret;
}

- (void) setAdjustMiniFrame
{
    for ( UIView * v in [self subviews]) {
        [v removeFromSuperview];
    }
    
    if ( m_Info == nil ) {
        return;
    }
    
    double apparent  = [m_Info.temperature doubleValue];
    double wind  = [m_Info.windSpeed doubleValue];
    NSString * icon = [NSString stringWithFormat:@"%@.png", m_Info.icon];
    NSString * summary = m_Info.summary;
    int windBearing = [m_Info.windBearing intValue];

    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    NSString * bgClr = widget.param.backgroundColor;
    [self setBackgroundColor: [Command colorFromHexString:bgClr]];
    
    headerFont * titleDic  = widget.param.headerFnt;
    
    NSString * titleFontName  = @"";
    NSString * titleFontColor = @"";
    int        titleFontSize  = 0;
    NSString * titleContent  = @"";
    NSString * titleBgClr    = @"";
    
    if ( titleDic ) {
        
        titleFontName = titleDic.name;
        titleFontColor= titleDic.color;
        titleFontSize = (int)([titleDic.size doubleValue] * 10);
        
        titleContent  = @"";
        if ( ![titleDic.content isKindOfClass:[NSNull class]] ) {
            titleContent  = titleDic.content;
        }
    }
    
    primaryColor * titleBgClrDic  = widget.param.primaryClr;
    if ( titleBgClrDic ) {
        titleBgClr = titleBgClrDic.color;
    }
    
    normal1Font * weatherDic  = widget.param.normal1Fnt;
    int         weatherFontSize = 0;
    NSString * weatherFontName  = @"";
    NSString * weatherFontColor = @"";
    
    if ( weatherDic ) {
        weatherFontSize = (int)([weatherDic.size doubleValue] * 10);
        weatherFontName = weatherDic.name;
        weatherFontColor = weatherDic.color;
    }
    
    normal2Font * basicDic  = widget.param.normal2Fnt;
    NSString * basicFontName  = @"";
    NSString * basicFontColor = @"";
    int        basicFontSize  = 0;
    
    if ( basicDic ) {
        basicFontSize = (int)([basicDic.size doubleValue] * 10);
        basicFontColor = basicDic.color;
        basicFontName  = basicDic.name;
    }

    
//  Middle
    UILabel * title  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [title setText:summary];
    [title setFont:[UIFont systemFontOfSize:18]];
    [title setFont:[UIFont fontWithName: [Command checkFontName:weatherFontName] size:weatherFontSize]];
    [title setTextColor:[Command colorFromHexString: weatherFontColor]];
    title.center  = CGPointMake(m_width/2, m_height/2);
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    [Command setAdjustHeightFrame: title];
    [title setFrame:CGRectMake( 0, m_height - title.frame.size.height - 10, m_width, title.frame.size.height)];
    
    float height  = fminf( m_width/3,  m_height - title.frame.size.height - 20);
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, title.frame.origin.y - height, height, height)];
    [imgView setImage:[UIImage imageNamed:icon]];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imgView];
    imgView.center = CGPointMake(m_width/2, (m_height-title.frame.size.height -10)/2) ;
    
    [title setFrame:CGRectMake(title.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + 5, title.frame.size.width, title.frame.size.height)];
    
//Left
    
    float valSize = fminf(((m_width / 3)-10) *4/6,  imgView.frame.size.height);
    UILabel * val = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, valSize, valSize)];
    [val setFont:[UIFont systemFontOfSize:40]];
    [val setTextColor:[UIColor colorWithRed:0 green:128.f/255.f blue:184.f/255.f alpha:1]];
    [val setText:[NSString stringWithFormat:@"%d", (int)apparent]];
    [self addSubview:val];
    
    
    int font = [Command getFontSize:val];
    [val setFont: [UIFont systemFontOfSize:font]];
    [Command setAdjustWidthFrame: val];
    [Command setAdjustHeightFrame:val];
    
    val.center  = CGPointMake(val.center.x, imgView.center.y);
    
    float offset  = val.frame.origin.x + val.frame.size.width;
    valSize = ((m_width / 3)-10) *2/6;
    UILabel * valO = [[UILabel alloc] initWithFrame:CGRectMake(offset, val.frame.origin.y, valSize, valSize)];
    [valO setFont:[UIFont systemFontOfSize:12]];
    [valO setTextColor:[UIColor colorWithRed:0 green:128.f/255.f blue:184.f/255.f alpha:1]];
    [valO setText:@"o"];
    font = [Command getFontSize:valO];
    if ( font >= 18 ) {
        font = 18;
    }
    [valO setFont:[UIFont systemFontOfSize:font]];
    [self addSubview:valO];
    
    
    UILabel * valF = [[UILabel alloc] initWithFrame:CGRectMake(offset, val.frame.origin.y + val.frame.size.height, valSize, valSize)];
    [valF setFont:[UIFont systemFontOfSize:font]];
    [valF setTextColor:[UIColor lightGrayColor]];
    [valF setText:@"F"];
    [self addSubview:valF];
    
    
    float fLeftMoveX  = (m_width/3 - valF.frame.origin.x - valF.frame.size.width)/2;

    
    val.center  = CGPointMake( val.center.x + fLeftMoveX, val.center.y);
    valO.center  = CGPointMake( valO.center.x + fLeftMoveX, valO.center.y );
    valF.center  = CGPointMake( valF.center.x + fLeftMoveX, valF.center.y );
    
// Right
    
    offset = m_width * 2/ 3;
    
    valSize  = val.frame.size.width - 5;
    
    UILabel * windVal = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, valSize, valSize)];
    [windVal setFont:[UIFont systemFontOfSize:40]];
    [windVal setText:[NSString stringWithFormat:@"%.1f", wind]];
    [windVal setTextColor:[UIColor lightGrayColor]];
    [self addSubview:windVal];
    
    font = [Command getFontSize:windVal];
    [windVal setFont: [UIFont systemFontOfSize:font]];
    [Command setAdjustWidthFrame: windVal];
    [Command setAdjustHeightFrame:windVal];
    
    [windVal setFrame:CGRectMake(windVal.frame.origin.x, val.frame.origin.y + val.frame.size.height - windVal.frame.size.height, windVal.frame.size.width, windVal.frame.size.height)];

    UILabel * windValMark = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, windVal.frame.size.width, windVal.frame.size.width)];
    [windValMark setText:@"WIND"];
    [windValMark setTextColor:[UIColor blueColor]];
    [self addSubview:windValMark];
    font  = [Command getFontSize: windValMark];
    [windValMark setFont: [UIFont systemFontOfSize:font]];
    [Command setAdjustHeightFrame:windValMark];
    [Command setAdjustWidthFrame:windValMark];
    
    [windValMark setFrame:CGRectMake(offset, windVal.frame.origin.y - windValMark.frame.size.height, windValMark.frame.size.width
                                     , windValMark.frame.size.height)];
    
    float deltaY  = windVal.frame.origin.y + windVal.frame.size.height - windValMark.frame.origin.y;
    UIImageView * imgArrow  = [[UIImageView alloc] initWithFrame:CGRectMake( windVal.frame.origin.x + windVal.frame.size.width + 5, windValMark.frame.origin.y, deltaY/2, deltaY/2)];
    [imgArrow setImage:[UIImage imageNamed:[self GetArrowImagePath:windBearing]]];
    [self addSubview: imgArrow];
    
    float deltaX = windVal.frame.size.width * 2/3;
    UILabel * mph = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, deltaX, deltaX)];
    [mph setText:@"MPH"];
    [mph setTextColor:[UIColor lightGrayColor]];
    [self addSubview: mph];
    font = [Command getFontSize:mph];
    [mph setFont:[UIFont systemFontOfSize:font]];
    [Command setAdjustHeightFrame:mph];
    [Command setAdjustWidthFrame:mph];
    
    [mph setFrame:CGRectMake(imgArrow.frame.origin.x,windVal.frame.origin.y + windVal.frame.size.height - mph.frame.size.height, mph.frame.size.width, mph.frame.size.height)];
    
    float fRightX = ( self.frame.size.width - mph.frame.origin.x - mph.frame.size.width) / 2;
    
    windVal.center = CGPointMake(windVal.center.x + fRightX, windVal.center.y );
    windValMark.center = CGPointMake(windValMark.center.x + fRightX, windValMark.center.y );
    imgArrow.center = CGPointMake(imgArrow.center.x + fRightX, imgArrow.center.y );
    mph.center = CGPointMake(mph.center.x + fRightX, mph.center.y );
    
    
    valO.center = CGPointMake(valO.center.x, windValMark.center.y);
    valF.center = CGPointMake(valF.center.x, mph.center.y);
    
    
    if ( ![titleContent isEqualToString:@""]) {
        UILabel * topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 100)];
        [topLabel setBackgroundColor: [Command colorFromHexString: titleBgClr]];
        [topLabel setText: titleContent];
        [topLabel setFont: [UIFont fontWithName: [Command checkFontName: titleFontName] size: titleFontSize]];
        [Command setAdjustHeightwithFixedWidth: topLabel];
        float topMoveDelta = topLabel.frame.size.height;
        
        for ( UIView * v in [self subviews]) {
            v.center = CGPointMake( v.center.x, v.center.y + topMoveDelta);
        }
        
        [self addSubview:topLabel];
        
    }
}

- (void) setAdjustDetailFrame
{
    for ( UIView * v in [self subviews]) {
        [v removeFromSuperview];
    }
    
    if ( m_Info == nil ) {
        return;
    }
    
    float delta  = m_height / 3;
    float offsetY  = 10;
    float offsetX  = 5;
    for ( int i = 0;  i < 2; i++ ) {
        UIImageView * imgLine  = [[UIImageView alloc] initWithFrame:CGRectMake( offsetX, offsetY + delta * i, m_width - 2 * offsetX, 1)];
        [imgLine setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview: imgLine];
    }
    
    double apparent  = [m_Info.temperature doubleValue];
    double wind  = [m_Info.windSpeed doubleValue];
    NSString * icon = [NSString stringWithFormat:@"%@.png", m_Info.icon];
    NSString * summary = m_Info.summary;
    int windBearing = [m_Info.windBearing intValue];
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    NSString * bgClr = widget.param.backgroundColor;
    [self setBackgroundColor: [Command colorFromHexString:bgClr]];
    
    headerFont * titleDic  = widget.param.headerFnt;
    
    NSString * titleFontName  = @"";
    NSString * titleFontColor = @"";
    int        titleFontSize  = 0;
    NSString * titleContent  = @"";
    NSString * titleBgClr    = @"";
    
    if ( titleDic ) {
        
        titleFontName = titleDic.name;
        titleFontColor= titleDic.color;
        titleFontSize = (int)([titleDic.size doubleValue] * 10);
        
        titleContent  = @"";
        if ( ![titleDic.content isKindOfClass:[NSNull class]] ) {
            titleContent  = titleDic.content;
        }
    }
    
    primaryColor * titleBgClrDic  = widget.param.primaryClr;
    if ( titleBgClrDic ) {
        titleBgClr = titleBgClrDic.color;
    }
    
    normal1Font * weatherDic  = widget.param.normal1Fnt;
    int         weatherFontSize = 0;
    NSString * weatherFontName  = @"";
    NSString * weatherFontColor = @"";
    
    if ( weatherDic ) {
        weatherFontSize = (int)([weatherDic.size doubleValue] * 10);
        weatherFontName = weatherDic.name;
        weatherFontColor = weatherDic.color;
    }
    
    normal2Font * basicDic  = widget.param.normal2Fnt;
    NSString * basicFontName  = @"";
    NSString * basicFontColor = @"";
    int        basicFontSize  = 0;
    
    if ( basicDic ) {
        basicFontSize = (int)([basicDic.size doubleValue] * 10);
        basicFontColor = basicDic.color;
        basicFontName  = basicDic.name;
    }

// Top
    UIImageView * img  = [[UIImageView alloc] initWithFrame: CGRectMake( offsetX, offsetY , delta * 2/ 3, delta * 2/ 3)];
    [img setImage:[UIImage imageNamed:icon]];
    [self addSubview:img];
    
    UILabel * title  = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY + delta  * 2/3, m_width/2, delta/3)];
    [title setText:summary];
    [title setFont:[UIFont fontWithName:[Command checkFontName:titleFontName] size:titleFontSize]];
    [Command setAdjustHeightFrame:title]; [Command setAdjustWidthFrame:title];
    [self addSubview:title];
    
    
    float move  = (offsetY + delta - title.frame.origin.y - title.frame.size.height)/2;
    img.center = CGPointMake( img.center.x, img.center.y + move);
    title.center  = CGPointMake( title.center.x, title.center.y + move);
    
    offsetX = self.frame.size.width/2;
    
    WeatherDataInfo * data = [m_Info.data objectAtIndex:0];
    double min  = [data.temperatureMin doubleValue];
    
    
    UILabel * val  = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, delta , delta*2/3)];
    [self addSubview:val];

    [val setTextColor:[UIColor colorWithRed:0 green:128.f/255.f blue:184.f/255.f alpha:1]];
    [val setText:[NSString stringWithFormat:@"%d", (int)apparent]];
    int font  = [Command getFontSize:val];
    [val setFont:[UIFont systemFontOfSize:font]];
    [Command setAdjustWidthFrame:val];
    [Command setAdjustHeightFrame:val];
    
    float sizeX = val.frame.size.width/2;
    UILabel * upNum = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, sizeX, sizeX)];
    [upNum setText:[NSString stringWithFormat:@"%d", (int)min]];
    [upNum setTextColor:[UIColor lightGrayColor]];
    [self addSubview:upNum];
    font  = [Command getFontSize:upNum];
    if (font >= 18 ) {
        font  = 18;
    }
    [upNum setFont:[UIFont systemFontOfSize:font]];
    [Command setAdjustWidthFrame:upNum];
    [Command setAdjustHeightFrame:upNum];
    
    
     double temperature  = [data.temperatureMax doubleValue];
    
    UILabel * downNum  = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, sizeX, sizeX)];
    [downNum setText:[NSString stringWithFormat:@"%d", (int)temperature]];
    [downNum setFont:[UIFont systemFontOfSize:font]];
    [downNum setTextColor:[UIColor lightGrayColor]];
    [self addSubview:downNum];
    [Command setAdjustWidthFrame:downNum];
    [Command setAdjustHeightFrame:downNum];
    

    UILabel * valo = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, sizeX, sizeX)];
    [valo setText:@"o"];
    [valo setFont:[UIFont systemFontOfSize:font]];
    [valo setTextColor:[UIColor colorWithRed:0 green:128.f/255.f blue:184.f/255.f alpha:1]];
    [self addSubview:valo];
    [Command setAdjustWidthFrame:valo];
    [Command setAdjustHeightFrame:valo];

    UILabel * valF = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, sizeX, sizeX)];
    [valF setText:@"F"];
    [valF setFont:[UIFont systemFontOfSize:font]];
    [valF setTextColor:[UIColor lightGrayColor]];
    [self addSubview:valF];
    [Command setAdjustWidthFrame:valF];
    [Command setAdjustHeightFrame:valF];

    
    [upNum setFrame:CGRectMake(val.frame.origin.x - upNum.frame.size.width, offsetY, upNum.frame.size.width, upNum.frame.size.height)];
    [valo setFrame:CGRectMake(val.frame.origin.x + val.frame.size.width, offsetY, valo.frame.size.width, valo.frame.size.height)];
  
    
    [downNum setFrame:CGRectMake(val.frame.origin.x - upNum.frame.size.width,val.frame.origin.y+val.frame.size.height-downNum.frame.size.height, downNum.frame.size.width, downNum.frame.size.height)];
    [valF setFrame:CGRectMake(val.frame.origin.x + val.frame.size.width, downNum.frame.origin.y, valF.frame.size.width, valF.frame.size.height)];
    
    
    move  = (offsetY + delta - valF.frame.origin.y - valF.frame.size.height)/2;
    
    
    val.center  = CGPointMake( val.center.x, val.center.y + move);
    upNum.center = CGPointMake( upNum.center.x, upNum.center.y + move);
    downNum.center = CGPointMake( downNum.center.x, downNum.center.y + move);
    
    valo.center = CGPointMake( valo.center.x, valo.center.y + move);
    valF.center = CGPointMake( valF.center.x, valF.center.y + move);
    
    
    float topMove  = (m_width - valF.frame.size.width - valF.frame.origin.x) / 2;
    
    img.center = CGPointMake( img.center.x + topMove, img.center.y);
    title.center  = CGPointMake( title.center.x + topMove, title.center.y);
    upNum.center  = CGPointMake( upNum.center.x + topMove, upNum.center.y);
    downNum.center  = CGPointMake( downNum.center.x + topMove, downNum.center.y);
    val.center  = CGPointMake( val.center.x + topMove, val.center.y);
    valo.center = CGPointMake( valo.center.x + topMove, valo.center.y);
    valF.center = CGPointMake( valF.center.x + topMove, valF.center.y);
    
//Middle
    offsetX = 5;
    float deltaX  = (m_width - 2 * offsetX) / 4;
    float fontVal = 0;
    float fontUnit = 0;
    float fontMark = 0;

    //wind
    
    UILabel * windVal = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY + delta, deltaX*2/3, (delta-2*offsetX)/2)];
    [windVal setText:[NSString stringWithFormat:@"%.2f", [m_Info.windSpeed doubleValue]]];
    [windVal setTextColor:[UIColor blackColor]];
    [self addSubview:windVal];
    fontVal = [Command getFontSize:windVal];
    [windVal setFont:[UIFont systemFontOfSize:fontVal]];
    [Command setAdjustHeightFrame:windVal];
    [Command setAdjustWidthFrame:windVal];
    
    
    UIImageView * imgWind  = [[UIImageView alloc] initWithFrame:CGRectMake( windVal.frame.origin.x + windVal.frame.size.width,
                                                                           windVal.frame.origin.y, windVal.frame.size.height/2, windVal.frame.size.height/2) ];
    [imgWind setImage:[UIImage imageNamed:[self GetArrowImagePath:windBearing]]];
    
    [self addSubview: imgWind];
    
    UILabel * mph = [[UILabel alloc] initWithFrame: CGRectMake( imgWind.frame.origin.x, imgWind.frame.origin.y + imgWind.frame.size.height, imgWind.frame.size.width + 10, imgWind.frame.size.width)];
    [mph setText:@"MPH"];
    [mph setTextColor:[UIColor lightGrayColor]];
    [self addSubview:mph];
    [Command setAdjustHeightFrame:mph];
    [Command setAdjustWidthFrame: mph];
    
    UILabel * windMark  = [[UILabel alloc] initWithFrame: CGRectMake(offsetX, mph.frame.origin.y + mph.frame.size.height , windVal.frame.size.width, delta/2)];
    [windMark setText:@"PRESSURE"];
    [self addSubview: windMark];
    fontMark = [Command getFontSize: windMark];
    [windMark setFont: [UIFont fontWithName:[Command checkFontName:basicFontName] size:basicFontSize]];
    [windMark setTextColor:[Command colorFromHexString:basicFontColor]];
    
    [Command setAdjustWidthFrame:windMark];
    [Command setAdjustHeightFrame:windMark];
    [windMark setText:@"WIND"];
    
    [mph setFont:[UIFont systemFontOfSize: fminf( fontMark, [Command  getFontSize:mph])]];
    
    
    float divideMove  = ((offsetX + deltaX) - mph.frame.origin.x - mph.frame.size.width)/2;
    if( divideMove > 0 )
    {
        windVal.center = CGPointMake( windVal.center.x + divideMove, windVal.center.y);
        imgWind.center = CGPointMake( imgWind.center.x + divideMove, imgWind.center.y);
        mph.center     = CGPointMake( mph.center.x + divideMove, mph.center.y);
        windMark.center = CGPointMake( windMark.center.x + divideMove, windMark.center.y);
    }
    
    //Humidity
    UILabel * humiVal  = [[UILabel alloc] initWithFrame:CGRectMake(offsetX + deltaX, windVal.frame.origin.y, windVal.frame.size.width, windVal.frame.size.height)];
    [humiVal setText: [NSString stringWithFormat:@"%d", (int)[m_Info.humidity doubleValue]]];
    [humiVal setFont:[UIFont systemFontOfSize: fontVal]];
    [humiVal setTextColor:[UIColor blackColor]];
    [self addSubview:humiVal];
    [Command setAdjustWidthFrame:humiVal];
    

    UILabel * humiUnity  = [[UILabel alloc] initWithFrame:CGRectMake(humiVal.frame.origin.x + humiVal.frame.size.width, windVal.frame.origin.y, deltaX/3, deltaX/3)];
    [humiUnity setText:@"%"];
    [humiUnity setFont: [UIFont systemFontOfSize:fontMark]];
    [humiUnity setTextColor:[UIColor lightGrayColor]];
    [Command setAdjustWidthFrame:humiUnity];
    [Command setAdjustHeightFrame:humiUnity];
    [self addSubview:humiUnity];
    
    float unitY  = windVal.frame.origin.y + windVal.frame.size.height - humiUnity.frame.size.height;
    
    [humiUnity setFrame:CGRectMake(humiUnity.frame.origin.x, unitY, humiUnity.frame.size.width, humiUnity.frame.size.height)];
    
    
    UILabel * humiMark = [[UILabel alloc] initWithFrame:CGRectMake(humiVal.frame.origin.x, windMark.frame.origin.y, deltaX, windMark.frame.size.height)];
    [humiMark setText:@"HUMIDITY"];
    [humiMark setFont:[UIFont systemFontOfSize:fontMark]];
    [humiMark setFont:[UIFont fontWithName: [Command checkFontName:basicFontName] size:basicFontSize]];
    [humiMark setTextColor:[Command colorFromHexString:basicFontColor]];
    [self addSubview: humiMark];
    [Command setAdjustHeightFrame:humiMark];
    [Command setAdjustWidthFrame:humiMark];
    
    
//    divideMove  = (offsetX + 2 * deltaX - fmaxf( humiUnity.frame.origin.x+humiUnity.frame.size.width, humiMark.frame.origin.x + humiMark.frame.size.width))/2;
//    if ( divideMove > 0 ) {
//        humiVal.center  = CGPointMake( humiVal.center.x + divideMove, humiVal.center.y);
//        humiUnity.center = CGPointMake( humiUnity.center.x + divideMove, humiUnity.center.y);
//        humiMark.center = CGPointMake( humiMark.center.x + divideMove, humiMark.center.y);
//    }
    
    //Visibility
    
    UILabel * visibleVal  = [[UILabel alloc] initWithFrame:CGRectMake(offsetX + 2 * deltaX, windVal.frame.origin.y, windVal.frame.size.width, windVal.frame.size.height)];
    [visibleVal setText: [NSString stringWithFormat:@"%d", [m_Info.visibility intValue]]];
    [visibleVal setFont:[UIFont systemFontOfSize: fontVal]];
    [visibleVal setTextColor:[UIColor blackColor]];
    [self addSubview:visibleVal];
    [Command setAdjustWidthFrame:visibleVal];
    
    UILabel * visibleUnity  = [[UILabel alloc] initWithFrame:CGRectMake(visibleVal.frame.origin.x + visibleVal.frame.size.width, unitY, deltaX/3, deltaX/3)];
    [visibleUnity setText:@"mi"];
    [visibleUnity setFont: [UIFont systemFontOfSize:fontMark]];
    [visibleUnity setTextColor:[UIColor lightGrayColor]];
    [Command setAdjustWidthFrame:visibleUnity];
    [Command setAdjustHeightFrame:visibleUnity];
    [self addSubview:visibleUnity];
    
    UILabel * visibleMark = [[UILabel alloc] initWithFrame:CGRectMake(visibleVal.frame.origin.x, windMark.frame.origin.y, deltaX, windMark.frame.size.height)];
    [visibleMark setText:@"VISIBILITY"];
    [visibleMark setFont:[UIFont systemFontOfSize:fontMark]];
    [visibleMark setFont: [UIFont fontWithName:[Command checkFontName:basicFontName] size:basicFontSize]];
    [visibleMark setTextColor:[Command colorFromHexString:basicFontColor]];
    [self addSubview: visibleMark];
    [Command setAdjustHeightFrame:visibleMark];
    [Command setAdjustWidthFrame:visibleMark];
    
    divideMove  = (offsetX + 3 * deltaX - fmaxf( visibleUnity.frame.origin.x+visibleUnity.frame.size.width, visibleMark.frame.origin.x + visibleMark.frame.size.width))/2;
    if ( divideMove > 0 ) {
        visibleVal.center  = CGPointMake( visibleVal.center.x + divideMove, visibleVal.center.y);
        visibleUnity.center = CGPointMake( visibleUnity.center.x + divideMove, visibleUnity.center.y);
        visibleMark.center = CGPointMake( visibleMark.center.x + divideMove, visibleMark.center.y);
        
    }

    
    //Pressure
    UILabel * pressureVal  = [[UILabel alloc] initWithFrame:CGRectMake(offsetX + 3 * deltaX, windVal.frame.origin.y, windVal.frame.size.width, windVal.frame.size.height)];
    [pressureVal setText: [NSString stringWithFormat:@"%.1f", [m_Info.pressure doubleValue]]];
    [pressureVal setFont:[UIFont systemFontOfSize: fontVal]];
    [pressureVal setTextColor:[UIColor blackColor]];
    [self addSubview:pressureVal];
    [Command setAdjustWidthFrame:pressureVal];
    
    UILabel * pressureUnity  = [[UILabel alloc] initWithFrame:CGRectMake(pressureVal.frame.origin.x + pressureVal.frame.size.width, unitY, deltaX/3, deltaX/3)];
    [pressureUnity setText:@"in"];
    [pressureUnity setFont: [UIFont systemFontOfSize:fontMark]];
    [pressureUnity setTextColor:[UIColor lightGrayColor]];
    [Command setAdjustWidthFrame:pressureUnity];
    [Command setAdjustHeightFrame:pressureUnity];
    [self addSubview:pressureUnity];
    
    UILabel * pressureMark = [[UILabel alloc] initWithFrame:CGRectMake(pressureVal.frame.origin.x, windMark.frame.origin.y, deltaX, humiMark.frame.size.height)];
    [pressureMark setText:@"PRESSURE"];
    [pressureMark setFont:[UIFont systemFontOfSize:fontMark]];
    [pressureMark setFont:[UIFont fontWithName:[Command checkFontName:basicFontName] size:basicFontSize]];
    [pressureMark setTextColor:[Command colorFromHexString:basicFontColor]];
    [self addSubview: pressureMark];
    [Command setAdjustHeightFrame:pressureMark];
    [Command setAdjustWidthFrame:pressureMark];
    
    
//    divideMove  = (offsetX + 3 * deltaX - fmaxf( pressureUnity.frame.origin.x+pressureUnity.frame.size.width, pressureMark.frame.origin.x + pressureMark.frame.size.width))/2;
//    if ( divideMove ) {
//        pressureVal.center  = CGPointMake( pressureVal.center.x + divideMove, pressureVal.center.y);
//        pressureUnity.center = CGPointMake( pressureUnity.center.x + divideMove, pressureUnity.center.y);
//        pressureMark.center = CGPointMake( pressureMark.center.x + divideMove, pressureMark.center.y);
//    }

    
    float middleMove  = (offsetY + 2 * delta - pressureMark.frame.origin.y - pressureMark.frame.size.height)/2;
    float middleMoveX = (m_width-10 -  fmaxf( pressureUnity.frame.origin.x+pressureUnity.frame.size.width, pressureMark.frame.origin.x + pressureMark.frame.size.width))/2;

    windVal.center  = CGPointMake( windVal.center.x + middleMoveX, windVal.center.y + middleMove);
    imgWind.center  = CGPointMake( imgWind.center.x + middleMoveX, imgWind.center.y + middleMove);
    mph.center  = CGPointMake( mph.center.x + middleMoveX, mph.center.y + middleMove);
    windMark.center  = CGPointMake( windMark.center.x + middleMoveX, windMark.center.y + middleMove);
    
    humiVal.center  = CGPointMake( humiVal.center.x + middleMoveX, humiVal.center.y + middleMove);
    humiUnity.center  = CGPointMake( humiUnity.center.x + middleMoveX, humiUnity.center.y + middleMove);
    humiMark.center  = CGPointMake( humiMark.center.x + middleMoveX, humiMark.center.y + middleMove);
    
    visibleVal.center  = CGPointMake( visibleVal.center.x + middleMoveX, visibleVal.center.y + middleMove);
    visibleUnity.center  = CGPointMake( visibleUnity.center.x + middleMoveX, visibleUnity.center.y + middleMove);
    visibleMark.center  = CGPointMake( visibleMark.center.x + middleMoveX, visibleMark.center.y + middleMove);
    
    pressureVal.center  = CGPointMake( pressureVal.center.x + middleMoveX, pressureVal.center.y + middleMove);
    pressureUnity.center  = CGPointMake( pressureUnity.center.x + middleMoveX, pressureUnity.center.y + middleMove);
    pressureMark.center   = CGPointMake( pressureMark.center.x + middleMoveX, pressureMark.center.y + middleMove );
    
//Bottom
    UIImageView * tempView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY + delta * 2, m_width, delta)];
    [tempView setBackgroundColor:[Command colorFromHexString:titleBgClr]];
    [self addSubview:tempView];

    float dayDelta  = m_width/6;
    float dayHeight = tempView.frame.size.height;
    for ( int i = 0; i < 6; i++ ) {
        WeatherDataInfo * data = [m_Info.data objectAtIndex:i];

        double time  = [data.currentTime doubleValue];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];

        NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSString *stringFromDate = [dateFormatter stringFromDate:myDate];

        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake( dayDelta * i, 0.05f * dayHeight, dayDelta * 0.7f, 0.15f * dayHeight)];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:  [NSString stringWithFormat:@"%@.", [stringFromDate substringToIndex:3]] ];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:[Command getFontSize:label]]];
        [tempView addSubview:label];
        
        [Command setAdjustHeightFrame:label];
        [Command setAdjustWidthFrame:label];
        
        float dayLabelMove  = (dayDelta * (i+1) - label.frame.size.width - label.frame.origin.x)/2;
        label.center  = CGPointMake( label.center.x + dayLabelMove, label.center.y);
        

        UIImageView * image  = [[UIImageView alloc] initWithFrame:CGRectMake(dayDelta * i + dayDelta * 0.15f, 0.2f * dayHeight, 0.35f * dayHeight, 0.35f * dayHeight)];

        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", data.icon]]];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [tempView addSubview: image];
        
        image.center  = CGPointMake( dayDelta * i + dayDelta /2, image.center.y);


        double max = [data.temperatureMax doubleValue];
        double min = [data.temperatureMin doubleValue];


        UILabel * dayVal  = [[UILabel alloc] initWithFrame:CGRectMake( dayDelta * i, 0.58f * dayHeight, dayDelta*0.7f, 0.4f * dayHeight)];
        [dayVal setTextColor:[UIColor whiteColor]];
        [dayVal setText:[NSString stringWithFormat:@"%d", (int)((max + min)/2)]];
        dayVal.textAlignment  = NSTextAlignmentCenter;
        int dayFont = [Command getFontSize:dayVal];
        [dayVal setFont:[UIFont systemFontOfSize:dayFont]];
        [tempView addSubview: dayVal];
        
        [Command setAdjustWidthFrame:dayVal];
        [Command setAdjustHeightFrame:dayVal];

        float x = dayVal.frame.size.width + dayVal.frame.origin.x;

        UILabel * mark = [[UILabel alloc] initWithFrame:CGRectMake(x , dayVal.frame.origin.y, dayVal.frame.size.width / 2, dayVal.frame.size.width / 2)];
        [mark setTextColor:[UIColor whiteColor]];
         mark.textAlignment = NSTextAlignmentCenter;
        [mark setText:@"o"];
        [mark setFont:[UIFont systemFontOfSize:[Command getFontSize:mark]]];
        [tempView addSubview: mark];
        [Command setAdjustHeightFrame:mark];
        [Command setAdjustWidthFrame:mark];

        UILabel * f = [[UILabel alloc] initWithFrame: CGRectMake( x, dayVal.frame.origin.y + dayVal.frame.size.height-mark.frame.size.height, dayVal.frame.size.width / 2, dayVal.frame.size.width / 2)];
        [f setTextColor:[UIColor whiteColor]];
        [f setText: @"F"];
         f.textAlignment  = NSTextAlignmentCenter;
        [f setFont:[UIFont systemFontOfSize:[Command getFontSize:mark]]];
        [tempView addSubview: f];
        
        [Command setAdjustWidthFrame:f];
        [Command setAdjustHeightFrame:f];
        
        float dayValMove  = (dayDelta * (i+1) - f.frame.size.width - f.frame.origin.x)/2;
        f.center  = CGPointMake( f.center.x + dayValMove, f.center.y);
        dayVal.center  = CGPointMake(dayVal.center.x + dayValMove, dayVal.center.y);
        mark.center  = CGPointMake( mark.center.x + dayValMove, mark.center.y);


        if( i != 0 )
        {
            UIImageView * line  = [[UIImageView alloc] initWithFrame: CGRectMake(dayDelta * i, 0, 1,  dayHeight)];
            [line setBackgroundColor:[UIColor blueColor]];
            [tempView addSubview: line];
        }
    }
    
    if ( ![titleContent isEqualToString:@""]) {
        UILabel * topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 100)];
        [topLabel setBackgroundColor: [Command colorFromHexString: titleBgClr]];
        [topLabel setText: titleContent];
        [topLabel setFont: [UIFont fontWithName: [Command checkFontName: titleFontName] size: titleFontSize]];
        [Command setAdjustHeightwithFixedWidth: topLabel];
        float topMoveDelta = topLabel.frame.size.height;
        
        for ( UIView * v in [self subviews]) {
            v.center = CGPointMake( v.center.x, v.center.y + topMoveDelta);
        }
        
        [self addSubview:topLabel];
        
    }
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
