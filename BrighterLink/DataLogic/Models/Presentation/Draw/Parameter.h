//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Parameter.h"
#import "fifthColor.h"
#import "fourthColor.h"
#import "headerFont.h"
#import "normal1Font.h"
#import "normal2Font.h"
#import "primaryColor.h"
#import "secondaryColor.h"
#import "seventhColor.h"
#import "sixthColor.h"
#import "subHeaderFont.h"
#import "tertiaryColor.h"


@interface Parameter : NSObject
{

}
@property (nonatomic, strong) NSString * backgroundColor;
@property (nonatomic, strong) NSString * backgroundColorLabel;
@property (nonatomic, strong) NSNumber * backgroundColorVisible;
@property (nonatomic, strong) NSString * backgroundImage;
@property (nonatomic, strong) NSString * backgroundImageLabel;
@property (nonatomic, strong) NSNumber * backgroundImageVisible;
@property (nonatomic, strong) NSNumber * colCount;
@property (nonatomic, strong) NSNumber * colPosition;
@property (nonatomic, strong) NSNumber * duration;
@property (nonatomic, strong) NSString * endDate;
@property (nonatomic, strong) fifthColor *    fifthClr;
@property (nonatomic, strong) fourthColor *    fourthClr;
@property (nonatomic, strong) headerFont *    headerFnt;
@property (nonatomic, strong) NSNumber  * minimumCols;
@property (nonatomic, strong) NSNumber  * minimumRows;
@property (nonatomic, strong) normal1Font   * normal1Fnt;
@property (nonatomic, strong) normal2Font   * normal2Fnt;
@property (nonatomic, strong) NSNumber *    previousTimelineRowPosition;
@property (nonatomic, strong) primaryColor *    primaryClr;
@property (nonatomic, strong) NSNumber *    resizedOnTimeline;
@property (nonatomic, strong) NSNumber *    rowCount;
@property (nonatomic, strong) NSNumber *    rowPosition;
@property (nonatomic, strong) secondaryColor      * secondaryClr;
@property (nonatomic, strong) seventhColor      * seventhClr;
@property (nonatomic, strong) sixthColor      * sixthClr;
@property (nonatomic, strong) NSString      * startDate;
@property (nonatomic, strong) subHeaderFont      * subHeaderFnt;
@property (nonatomic, strong) tertiaryColor      * tertiaryClr;
@property (nonatomic, strong) NSNumber      * timelineRowPosition;
@property (nonatomic, strong) NSString      * transitionIn;
@property (nonatomic, strong) NSString      * transitionOut;

@property (nonatomic, strong) NSString      * wIdgetGraphTemperatureChartType;
@property (nonatomic, strong) NSString      * widgetBorderColor;
@property (nonatomic, strong) NSNumber      * widgetEnergyCO2Kilograms;
@property (nonatomic, strong) NSNumber      * widgetEnergyCombineInverters;
@property (nonatomic, strong) NSString      * widgetEnergyDateRange;
@property (nonatomic, strong) NSString      * widgetEnergyEndDate;
@property (nonatomic, strong) NSNumber      * widgetEnergyGreenhouseKilograms;
@property (nonatomic, strong) NSString      * widgetEnergyInverter;
@property (nonatomic, strong) NSString      * widgetEnergyOrientation;
@property (nonatomic, strong) NSString      * widgetEnergyStartDate;
@property (nonatomic, strong) NSString      * widgetEnergyType;
@property (nonatomic, strong) NSString      * widgetGraphBlockLabel;
@property (nonatomic, strong) NSNumber      * widgetGraphCombineInverters;
@property (nonatomic, strong) NSNumber      * widgetGraphCurrentPower;
@property (nonatomic, strong) NSString      * widgetGraphCurrentPowerChartType;
@property (nonatomic, strong) NSString      * widgetGraphDateRange;
@property (nonatomic, strong) NSString      * widgetGraphEndDate;
@property (nonatomic, strong) NSNumber      * widgetGraphGeneration;
@property (nonatomic, strong) NSString      * widgetGraphGenerationChartType;
@property (nonatomic, strong) NSNumber      * widgetGraphHumidity;
@property (nonatomic, strong) NSString      * widgetGraphHumidityChartType;
@property (nonatomic, strong) NSString      * widgetGraphInterval;
@property (nonatomic, strong) NSString      * widgetGraphInverter;
@property (nonatomic, strong) NSNumber      * widgetGraphIrradiance;
@property (nonatomic, strong) NSString      * widgetGraphIrradianceChartType;
@property (nonatomic, strong) NSNumber      * widgetGraphMaxPower;
@property (nonatomic, strong) NSString      * widgetGraphMaxPowerChartType;
@property (nonatomic, strong) NSString      * widgetGraphStartDate;
@property (nonatomic, strong) NSNumber      * widgetGraphTemperature;
@property (nonatomic, strong) NSNumber      * widgetGraphWeather;
@property (nonatomic, strong) NSNumber      * widgetHowDoesSolarWorkOverallDuration;
@property (nonatomic, strong) NSNumber      * widgetHowDoesSolarWorkStepFourDuration;
@property (nonatomic, strong) NSString      * widgetHowDoesSolarWorkStepFourText;
@property (nonatomic, strong) NSNumber      * widgetHowDoesSolarWorkStepOneDuration;
@property (nonatomic, strong) NSString      * widgetHowDoesSolarWorkStepOneText;
@property (nonatomic, strong) NSNumber      * widgetHowDoesSolarWorkStepThreeDuration;
@property (nonatomic, strong) NSString      * widgetHowDoesSolarWorkStepThreeText;
@property (nonatomic, strong) NSNumber      * widgetHowDoesSolarWorkStepTwoDuration;
@property (nonatomic, strong) NSString      * widgetHowDoesSolarWorkStepTwoText;
@property (nonatomic, strong) NSString      * widgetIFrameUrl;
@property (nonatomic, strong) NSString      * widgetRandomColor;
@property (nonatomic, strong) NSNumber      * widgetSolarGenerationCombineInverters;
@property (nonatomic, strong) NSNumber      * widgetSolarGenerationCurrent;
@property (nonatomic, strong) NSString      * widgetSolarGenerationDateRange;
@property (nonatomic, strong) NSString      * widgetSolarGenerationEndDate;
@property (nonatomic, strong) NSString      * widgetSolarGenerationInverter;
@property (nonatomic, strong) NSString      * widgetSolarGenerationOrientation;
@property (nonatomic, strong) NSNumber      * widgetSolarGenerationReimbursement;
@property (nonatomic, strong) NSString      * widgetSolarGenerationStartDate;
@property (nonatomic, strong) NSNumber      * widgetSolarGenerationkWh;
@property (nonatomic, strong) NSString      * widgetTextareaContent;
@property (nonatomic, strong) NSString      * widgetTotalCO2OffsetinTrees;
@property (nonatomic, strong) NSString      * widgetTotalEGin60WattBulbs;
@property (nonatomic, strong) NSString      * widgetTotalEGinFewerVehicles;
@property (nonatomic, strong) NSString      * widgetTotalEGinGasSaved;
@property (nonatomic, strong) NSString      * widgetURL;
@property (nonatomic, strong) NSString      * widgetWeatherType;


- (UIColor *) colorFromHexString:(NSString *)hexString;
- (NSDictionary * ) GetParamDic;
@end
