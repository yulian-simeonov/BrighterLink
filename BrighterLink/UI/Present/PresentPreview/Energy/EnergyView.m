//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EnergyView.h"

#import "SharedMembers.h"
#import "Command.h"
#import "SDWebImageManager.h"

@interface EnergyView()

@end

@implementation EnergyView

NSString * dataEnergyType[] =  {
    @"Cars Removed", @"Waste Recycled", @"Gallons Gas Saved", @"Tanker Gas Saved", @"Energy Homes Generated", @"Electricity Homes Generated", @"Coal Elimanated", @"Oil Unneeded", @"Propane Cylinders", @"Plants Idled", @"Seedling Grown", @"Forests Preserved", @"Forests Conversion Prevented"
};


- (void) awakeFromNib
{
    
}

- (void) setRefresh:(EnergyInfo*) info
{
    m_Info = info;
}
    
//21. 34. 25.14.
- (void) resizeAllSubview:(CGRect) frame
{
    width  = frame.size.width;
    height = frame.size.height;
    
    [self setAdjustFrame];
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

- (void) setAdjustFrame
{
    for ( UIView * v in [self subviews]) {
        [v removeFromSuperview];
    }
    
    if ( m_Info == nil ) {
        return;
    }
    
    self.layer.cornerRadius = 5.f;
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    NSString * titleContent  = @"";
    int        titleInchFont = 0;
    NSString * titleColor    = @"";
    NSString * titleFontName = @"";
    NSArray  * arr;
    int        max   = 0;

    headerFont * title  = widget.param.headerFnt;
    if ( title ) {
        titleInchFont = [title.size doubleValue] * 10;
        titleContent  = title.content;
        titleFontName = [Command checkFontName: title.name];
        titleColor    = title.color;
        
        if ( ![titleContent isKindOfClass:[NSNull class]] ) {
            
            arr  = [titleContent componentsSeparatedByString:@" "];
            max = 0;
            
            if ( [arr count] > 1 ) {
                for ( int i=1; i< [arr count]; i++ ) {
                    int ori  = ((NSString*)[arr objectAtIndex:max]).length;
                    int cur  = ((NSString*)[arr objectAtIndex:i]).length;
                    
                    if ( ori < cur ) {
                        max  = i;
                    }
                }
            }
        }
    }
    
    primaryColor * titleBgClr  = widget.param.primaryClr;

    UIImageView * titleBg  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width/3, height)];
    if ( titleBgClr ) {
        [titleBg setBackgroundColor:[Command colorFromHexString: titleBgClr.color]];
    }
    
    titleBg.layer.cornerRadius = 5.f;
    [self addSubview:titleBg];
    
    
    UIImageView * tempBg  = [[UIImageView alloc] initWithFrame:CGRectMake(width/3 + 5, 0, (width*2/3)-5, height)];
    if ( widget.param.backgroundColor) {
        [tempBg setBackgroundColor:[Command colorFromHexString: widget.param.backgroundColor]];
        
    }else{
        [tempBg setBackgroundColor:[UIColor whiteColor]];
    }
    
    tempBg.layer.cornerRadius = 5.f;
    [self addSubview:tempBg];
    

    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width/3-20, 100)];
    [temp setText:[arr objectAtIndex:max]];
    [temp setFont:[UIFont fontWithName: titleFontName size:titleInchFont]];
    [Command setAdjustHeightFrame:temp];
    float titleHeight  = temp.frame.size.height;
    

    UITextView * lTitle = [[UITextView alloc] initWithFrame:CGRectMake( 10, 10, width/3-20, height)];
    [lTitle setText: titleContent ];
    [lTitle setFont:[UIFont fontWithName:titleFontName size:titleInchFont]];
    [lTitle setTextColor:[Command colorFromHexString:titleColor]];
    [lTitle setUserInteractionEnabled:false];
    [lTitle setBackgroundColor:[UIColor clearColor]];
    [Command setAdjust_TextView_HeightwithFixedWidth:lTitle];
    [self addSubview: lTitle];
    
    float offsetY  = lTitle.frame.size.height + 10;
    
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

    UILabel * greenhouse = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width/3-20, titleHeight)];
    [greenhouse setText:@"Greenhouse Emissions :"];
//    int subTitleFont = [Command getFontSize: greenhouse];
//    [greenhouse setFont:[UIFont systemFontOfSize:subTitleFont]];
    [greenhouse setFont:[UIFont fontWithName:suppFontName size:suppFontSize]];
    [greenhouse setTextColor:[Command colorFromHexString:suppFontColor]];
    [self addSubview: greenhouse];
    [Command setAdjustHeightFrame:greenhouse];

    UILabel * pounds = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width/3-20, titleHeight)];
    [pounds setText:[NSString stringWithFormat:@"%f pounds", m_Info.greenhouseEmissionsInKilograms]];
    [pounds setTextColor:[Command colorFromHexString:suppFontColor]];
    [pounds setFont:[UIFont fontWithName:suppFontName size:suppFontSize]];
    [self addSubview: pounds];
    [Command setAdjustHeightFrame:pounds];

    UILabel * co2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width/3-20, titleHeight)];
    [co2 setText:@"CO2 Avoided :"];
    [co2 setTextColor:[Command colorFromHexString:suppFontColor]];
    [co2 setFont:[UIFont fontWithName:suppFontName size:suppFontSize]];
    [self addSubview: co2];
    [Command setAdjustHeightFrame:co2];
    

    UILabel * co2Pounds = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width/3-20, titleHeight)];
    [co2Pounds setText:[NSString stringWithFormat:@"%f pounds", m_Info.co2AvoidedInKilograms]];
    [co2Pounds setTextColor:[Command colorFromHexString:suppFontColor]];
    [co2Pounds setFont:[UIFont fontWithName:suppFontName size:suppFontSize]];
    [self addSubview: co2Pounds];
    [Command setAdjustHeightFrame:co2Pounds];
    
    
    if ( ![widget.param.widgetEnergyCO2Kilograms boolValue] ) {
        [co2 setHidden: true];
        [co2Pounds setHidden:true];
    }
    
    if ( ![widget.param.widgetEnergyGreenhouseKilograms boolValue]){
        [greenhouse setHidden:true];
        [pounds setHidden:true];
    }
    
    float subTitleHeight  = co2.frame.size.height;
    [co2 setFrame:CGRectMake(10,  offsetY, co2.frame.size.width, subTitleHeight)]; offsetY += subTitleHeight;
    [co2Pounds setFrame:CGRectMake(10,  offsetY, co2Pounds.frame.size.width, subTitleHeight)]; offsetY += subTitleHeight;
    [greenhouse setFrame:CGRectMake(10,  offsetY, greenhouse.frame.size.width, subTitleHeight)]; offsetY += subTitleHeight;
    [pounds setFrame:CGRectMake(10,  offsetY, pounds.frame.size.width, subTitleHeight)];


    UIImageView * spaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width/7, width/7)];
    spaceImage.center = CGPointMake( titleBg.frame.size.width, self.frame.size.height/2);
    [spaceImage setImage:[UIImage imageNamed:@"energy_mark.png"]];
    [spaceImage setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview: spaceImage];

// Bottom
    UIImageView * bg  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.4, width/2, height * 0.6f)];
    [bg setImage:[UIImage imageNamed:@"login_background.jpg"]];
    [self addSubview:bg];
    
    if ( widget.param.backgroundImage ) {
        
     
        if ([widget.param.backgroundImage containsString:@"http"]) {

            UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];

            [JSWaiter ShowWaiter:self title: @"" type:0];
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: widget.param.backgroundImage] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (!image)
                    return;
                [icon setImage: image];
                [JSWaiter HideWaiter];
            }];

            [icon setContentMode:UIViewContentModeScaleAspectFit];
            [self addSubview:icon];
            
        } else {
        NSArray * arr = [widget.param.backgroundImage componentsSeparatedByString:@"/"];
        NSString * imgName  = [arr objectAtIndex:[arr count]-1];

            UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
            [icon setImage: [UIImage imageNamed:imgName]];
            [icon setContentMode:UIViewContentModeScaleAspectFit];
            [self addSubview:icon];
    }
    
        
    }else{
        
    }
    
///////////
    
    float levelY  = height/12;
    float levelHeight = height/7;
    
            
    NSString * type  = widget.param.widgetEnergyType;
    if ( [type isEqualToString:@"Cars Removed"] ){
    
  
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText:[NSString stringWithFormat:@"%.1f", m_Info.passengerVehiclesPerYear]];
//        [val setFont:[UIFont systemFontOfSize:[Command getFontSize:val]]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
    
        UILabel * cars = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.size.width + val.frame.origin.x,  0, width*2/3, val.frame.size.height/3)];
        [cars setText:@"cars"];
        [cars setFont:[UIFont systemFontOfSize: [Command getFontSize:cars]]];
        [cars setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustHeightFrame:cars];
        [Command setAdjustWidthFrame:cars];
        [self addSubview: cars];
        
        [cars setFrame: CGRectMake( val.frame.size.width + val.frame.origin.x, val.frame.origin.y + val.frame.size.height - cars.frame.size.height, cars.frame.size.width, cars.frame.size.height)];
    
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y + val.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"REMOVED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];
        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"vertical-cars.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];
        
    }else if ( [type isEqualToString:@"Waste Recycled"] ){
        
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText:[NSString stringWithFormat:@"%.1f", m_Info.tonsOfWasteRecycledInsteadOfLandfilled]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
    
    
        UITextView * tons = [[UITextView alloc] initWithFrame: CGRectMake( val.frame.size.width + val.frame.origin.x,  val.frame.origin.y, width*2/3, val.frame.size.height)];
        [tons setText:@"tons\nof waste"];
        [tons setUserInteractionEnabled:false];
        [tons setBackgroundColor:[UIColor clearColor]];
        [tons setTextColor: [UIColor lightGrayColor]];
        [tons setFont:[UIFont systemFontOfSize: [Command getTextViewFontSize:tons]]];
        [self addSubview: tons];
       
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y + val.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"REMOVED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];
        
        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"tons.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];
        
    }else if ( [type isEqualToString:@"Gallons Gas Saved"]){
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText:[NSString stringWithFormat:@"%.1f", m_Info.gallonsOfGasoline]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UITextView * tons = [[UITextView alloc] initWithFrame: CGRectMake( val.frame.size.width + val.frame.origin.x,  val.frame.origin.y, width*2/3, val.frame.size.height)];
        [tons setText:@"gallons\nof gas"];
        [tons setBackgroundColor:[UIColor clearColor]];
        [tons setTextColor: [UIColor lightGrayColor]];
        [tons setUserInteractionEnabled:false];
        [tons setFont:[UIFont systemFontOfSize: [Command getTextViewFontSize:tons]]];
        [self addSubview: tons];
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y + val.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"SAVED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];

        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"gallons.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];

    }else if ( [type isEqualToString:@"Tanker Gas Saved"] ){

        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText:[NSString stringWithFormat:@"%.1f", m_Info.tankerTrucksFilledWithGasoline]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UILabel * cars = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x ,  val.frame.origin.y + val.frame.size.height, width*2/3, val.frame.size.height/3)];
        [cars setText:@"tranker trucks of gas"];
        [cars setFont:[UIFont systemFontOfSize: [Command getFontSize:cars]]];
        [cars setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustHeightFrame:cars];
        [Command setAdjustWidthFrame:cars];
        [self addSubview: cars];
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, cars.frame.origin.y + cars.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"SAVED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];

        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"tanker.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];

        
    }else if ( [type isEqualToString:@"Energy Homes Generated"]){
        
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText:[NSString stringWithFormat:@"%.1f", m_Info.homeEnergyUse]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UILabel * cars = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.size.width + val.frame.origin.x,  val.frame.origin.y, width*2/3, val.frame.size.height/3)];
        [cars setText:@"homes"];
        [cars setFont:[UIFont systemFontOfSize: [Command getFontSize:cars]]];
        [cars setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustHeightFrame:cars];
        [Command setAdjustWidthFrame:cars];
        [self addSubview: cars];
        
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y + val.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"GENERATED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];

        
        UILabel * energy = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y - removed.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [energy setText:@"Energy for"];
        [energy setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [energy setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:energy];
        [Command setAdjustHeightFrame:energy];
        [self addSubview: energy];

        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"energy-home.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];


    }else if ( [type isEqualToString:@"Electricity Homes Generated"]){
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText:[NSString stringWithFormat:@"%.1f", m_Info.homeElectricityUse]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UILabel * cars = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.size.width + val.frame.origin.x,  val.frame.origin.y, width*2/3, val.frame.size.height/3)];
        [cars setText:@"homes"];
        [cars setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustHeightFrame:cars];
        [Command setAdjustWidthFrame:cars];
        [self addSubview: cars];
        
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y + val.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"GENERATED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];
        
        
        UILabel * energy = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y - removed.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [energy setText:@"Electricity for"];
        [energy setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [energy setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:energy];
        [Command setAdjustHeightFrame:energy];
        [self addSubview: energy];

        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"electricity-home.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];

        
    }else if ( [type isEqualToString:@"Coal Elimanated"]) {
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText: [NSString stringWithFormat:@"%.1f", m_Info.railcarsOfCoalburned]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UILabel * cars = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x ,  val.frame.origin.y + val.frame.size.height, width*2/3, val.frame.size.height/3)];
        [cars setText:@"railcars of coal"];
        [cars setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustHeightFrame:cars];
        [Command setAdjustWidthFrame:cars];
        [self addSubview: cars];
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, cars.frame.origin.y + cars.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"ELIMINATED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];

        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"railcars.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];
        

    }else if ( [type isEqualToString:@"Oil Unneeded"]) {
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText: [NSString stringWithFormat:@"%.1f", m_Info.barrelsOfOilConsumed]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UITextView * tons = [[UITextView alloc] initWithFrame: CGRectMake( val.frame.size.width + val.frame.origin.x,  val.frame.origin.y, width*2/3, val.frame.size.height)];
        [tons setText:@"barrels\nof Oil"];
        [tons setBackgroundColor:[UIColor clearColor]];
        [tons setTextColor:[UIColor lightGrayColor]];
        [tons setUserInteractionEnabled:false];
        [tons setFont:[UIFont systemFontOfSize: [Command getTextViewFontSize:tons]]];
        [self addSubview: tons];
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y + val.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"UNNEEDED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];

        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"barrels.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];
        
        
    }else if ( [type isEqualToString:@"Propane Cylinders"]) {
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText: [NSString stringWithFormat:@"%.1f", m_Info.propaneCylindersUsedForHomeBarbecues]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UITextView * tons = [[UITextView alloc] initWithFrame: CGRectMake( val.frame.size.width + val.frame.origin.x,  val.frame.origin.y, width*2/3, val.frame.size.height)];
        [tons setText:@"propane\ncylinders"];
        [tons setUserInteractionEnabled:false];
        [tons setBackgroundColor: [UIColor clearColor]];
        [tons setTextColor:[UIColor lightGrayColor]];
        [tons setFont:[UIFont systemFontOfSize: [Command getTextViewFontSize:tons]]];
        [self addSubview: tons];
        
        UILabel * bardeques = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y + val.frame.size.height, width * 2/3, val.frame.size.height/3 )];
        [bardeques setText:@"for home bardeques"];
        [bardeques setFont: [UIFont systemFontOfSize:fmaxf(3,  [Command getFontSize:bardeques]) ]];
        [bardeques setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:bardeques];
        [Command setAdjustHeightFrame:bardeques];
        [self addSubview: bardeques];

        
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, bardeques.frame.origin.y + bardeques.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"UNBURNED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];

        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"propane.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];

    }else if ( [type isEqualToString:@"Plants Idled"]) {
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText:@"0"];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UILabel * cars = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x ,  val.frame.origin.y + val.frame.size.height, width*2/3, val.frame.size.height/3)];
        [cars setText:@"coal fired power plants"];
        [cars setFont:[UIFont systemFontOfSize: [Command getFontSize:cars]]];
        [cars setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustHeightFrame:cars];
        [Command setAdjustWidthFrame:cars];
        [self addSubview: cars];
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, cars.frame.origin.y + cars.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"IDLED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];

        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"coal.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];
//

    }else if ( [type isEqualToString:@"Seedling Grown"]) {
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText:[NSString stringWithFormat:@"%.1f", m_Info.numberOfTreeSeedlingsGrownFor10Years]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];

        UILabel * trees = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x + val.frame.size.width,  val.frame.origin.y + val.frame.size.height, width*2/3, val.frame.size.height/3)];
        [trees setText:@"tree seedlings "];
        [trees setFont:[UIFont systemFontOfSize: [Command getFontSize:trees]]];
        [trees setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustHeightFrame:trees];
        [Command setAdjustWidthFrame:trees];
        [self addSubview: trees];

        [trees setFrame: CGRectMake( trees.frame.origin.x, val.frame.origin.y + val.frame.size.height - trees.frame.size.height, trees.frame.size.width, trees.frame.size.height)];

        UILabel * grown = [[UILabel alloc] initWithFrame: CGRectMake( trees.frame.origin.x + trees.frame.size.width ,  val.frame.origin.y + val.frame.size.height, width*2/3, val.frame.size.height/2)];
        [grown setText:@"GROWN"];
        [grown setFont:[UIFont systemFontOfSize: [Command getFontSize:grown]]];
        [grown setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustHeightFrame:grown];
        [Command setAdjustWidthFrame:grown];
        [self addSubview: grown];
        
        [grown setFrame: CGRectMake( grown.frame.origin.x, val.frame.origin.y + val.frame.size.height - grown.frame.size.height, grown.frame.size.width, grown.frame.size.height)];

        
        UILabel * years = [[UILabel alloc] initWithFrame: CGRectMake( grown.frame.origin.x + grown.frame.size.width ,  val.frame.origin.y + val.frame.size.height, width*2/3, val.frame.size.height/3)];
        [years setText:@"   for 10 years"];
        [years setFont:[UIFont systemFontOfSize: [Command getFontSize:years]]];
        [years setTextColor:[UIColor lightGrayColor]];
        [Command setAdjustHeightFrame:years];
        [Command setAdjustWidthFrame:years];
        [self addSubview: years];
        
        [years setFrame: CGRectMake( years.frame.origin.x, val.frame.origin.y + val.frame.size.height - years.frame.size.height, years.frame.size.width, years.frame.size.height)];
        
        
        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"tree.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];
        
        
    }else if ( [type isEqualToString:@"Forests Preserved"]){
        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, levelY, width*2/3, levelHeight)];
        [val setText:[NSString stringWithFormat:@"%.1f", m_Info.acresOfUSForestsStoringCarbonForOneYear]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UITextView * tons = [[UITextView alloc] initWithFrame: CGRectMake( val.frame.size.width + val.frame.origin.x,  val.frame.origin.y, width*2/3, val.frame.size.height)];
        [tons setText:@"acres of U.S.\nforests"];
        [tons setUserInteractionEnabled:false];
        [tons setBackgroundColor:[UIColor clearColor]];
        [tons setTextColor:[UIColor lightGrayColor]];
        [tons setFont:[UIFont systemFontOfSize: [Command getTextViewFontSize:tons]]];
        [self addSubview: tons];
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, val.frame.origin.y + val.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"PRESERVED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];

        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"acres.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];
        

    }else if ( [type isEqualToString:@"Forests Conversion Prevented"]){

        
        UILabel * val = [[UILabel alloc] initWithFrame:CGRectMake( spaceImage.frame.origin.x + spaceImage.frame.size.width, height/10, width*2/3, levelHeight)];
        [val setText:[NSString stringWithFormat:@"%.1f", m_Info.acresOfUSForestPreservedFromConversionToCropland]];
        [val setFont:[UIFont fontWithName:calcFontName size:calcFontSize]];
        [val setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustWidthFrame:val];
        [Command setAdjustHeightFrame:val];
        [self addSubview: val];
        
        
        UILabel * cars = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x ,  val.frame.origin.y + val.frame.size.height, width*2/3, val.frame.size.height/3)];
        [cars setText:@"acres of U.S. forests"];
        [cars setFont:[UIFont systemFontOfSize: [Command getFontSize:cars]]];
        [cars setTextColor:[Command colorFromHexString:calcFontColor]];
        [Command setAdjustHeightFrame:cars];
        [Command setAdjustWidthFrame:cars];
        [self addSubview: cars];
        
        UILabel * removed = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x, cars.frame.origin.y + cars.frame.size.height, width * 2/3, val.frame.size.height * 4 /5 )];
        [removed setText:@"PREVENTED"];
        [removed setFont:[UIFont fontWithName:basicFontName size:basicFontSize]];
        [removed setTextColor:[Command colorFromHexString:basicFontColor]];
        [Command setAdjustWidthFrame:removed];
        [Command setAdjustHeightFrame:removed];
        [self addSubview: removed];
        
        UILabel * conversion = [[UILabel alloc] initWithFrame: CGRectMake( val.frame.origin.x ,  removed.frame.origin.y + removed.frame.size.height, width*2/3, val.frame.size.height/3)];
        [conversion setText:@"from conversion"];
        [conversion setFont:[UIFont systemFontOfSize: [Command getFontSize:conversion]]];
        [conversion setTextColor:[UIColor lightGrayColor]];
        [Command setAdjustHeightFrame:conversion];
        [Command setAdjustWidthFrame:conversion];
        [self addSubview: conversion];


        
//        UIImageView * icon  = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, height * 0.5, width/2, height * 0.5f)];
//        [icon setImage: [UIImage imageNamed:@"acres-corpland.png"]];
//        [icon setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:icon];
        
    }
//////////////////////////
}

@end
