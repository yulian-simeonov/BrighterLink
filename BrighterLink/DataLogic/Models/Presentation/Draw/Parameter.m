//
//  UserInfo.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "Parameter.h"
#import "SharedMembers.h"


@implementation Parameter


- (id) init{

    _backgroundColor = @"";
    _backgroundColorLabel = @"";
    _backgroundColorVisible = [NSNumber numberWithBool:false];
    _backgroundImage = @"";
    _backgroundImageLabel = @"";
    _backgroundImageVisible = [NSNumber numberWithBool:false];
    _colCount = [NSNumber numberWithInt:0];
    _colPosition = [NSNumber numberWithInt:0];
    _duration = [NSNumber numberWithInt:0];
    _endDate = @"";
    _fifthClr =  [[fifthColor alloc] init];
    _fourthClr = [[fourthColor alloc] init];
    _headerFnt =  [[headerFont alloc] init];
    _minimumCols = [NSNumber numberWithInt:0];
    _minimumRows = [NSNumber numberWithInt:0];
    _normal1Fnt =  [[normal1Font alloc] init];
    _normal2Fnt = [[normal2Font alloc] init];
    _previousTimelineRowPosition = [NSNumber numberWithInt:0];
    _primaryClr = [[primaryColor alloc] init];
    _resizedOnTimeline = [NSNumber numberWithInt:0];
    _rowCount = [NSNumber numberWithInt: 0];
    _rowPosition = [NSNumber numberWithInt:0];
    _secondaryClr = [[secondaryColor alloc] init];
    _seventhClr = [[seventhColor alloc] init];
    _sixthClr = [[sixthColor alloc] init];
    _startDate = @"";
    _subHeaderFnt = [[subHeaderFont alloc] init];
    _tertiaryClr =  [[tertiaryColor alloc] init];
    
    _timelineRowPosition = [NSNumber numberWithInt:0];
    _transitionIn = @"";
    _transitionOut = @"";

    _wIdgetGraphTemperatureChartType = @"";
    _widgetBorderColor = @"";
    _widgetEnergyCO2Kilograms = [NSNumber numberWithInt:0];
    _widgetEnergyCombineInverters = [NSNumber numberWithInt:0];
    _widgetEnergyDateRange = @"";
    _widgetEnergyEndDate = @"";
    _widgetEnergyGreenhouseKilograms = [NSNumber numberWithInt:0];
    _widgetEnergyInverter = @"";
    _widgetEnergyOrientation = @"";
    _widgetEnergyStartDate = @"";
    _widgetEnergyType = @"";
    _widgetGraphBlockLabel = @"";
    _widgetGraphCombineInverters = [NSNumber numberWithInt:0];
    _widgetGraphCurrentPower = [NSNumber numberWithInt:0];
    _widgetGraphCurrentPowerChartType = @"";
    _widgetGraphDateRange = @"";
    _widgetGraphEndDate = @"";
    _widgetGraphGeneration = [NSNumber numberWithInt:0];
    _widgetGraphGenerationChartType = @"";
    _widgetGraphHumidity = [NSNumber numberWithInt:0];
    _widgetGraphHumidityChartType = @"";
    _widgetGraphInterval = @"";
    _widgetGraphInverter = @"";
    _widgetGraphIrradiance = [NSNumber numberWithInt:0];
    _widgetGraphIrradianceChartType = @"";
    _widgetGraphMaxPower = [NSNumber numberWithInt:0];
    _widgetGraphMaxPowerChartType = @"";
    _widgetGraphStartDate = @"";
    _widgetGraphTemperature = [NSNumber numberWithInt:0];
    _widgetGraphWeather = [NSNumber numberWithInt:0];
    _widgetHowDoesSolarWorkOverallDuration = [NSNumber numberWithInt:0];
    _widgetHowDoesSolarWorkStepFourDuration = [NSNumber numberWithInt:0];
    _widgetHowDoesSolarWorkStepFourText = @"";
    _widgetHowDoesSolarWorkStepOneDuration = [NSNumber numberWithInt:0];
    _widgetHowDoesSolarWorkStepOneText = @"";
    _widgetHowDoesSolarWorkStepThreeDuration = [NSNumber numberWithInt:0];
    _widgetHowDoesSolarWorkStepThreeText = @"";
    _widgetHowDoesSolarWorkStepTwoDuration = [NSNumber numberWithInt:0];
    _widgetHowDoesSolarWorkStepTwoText = @"";
    _widgetIFrameUrl = @"";
    _widgetRandomColor  = @"";
    _widgetSolarGenerationCombineInverters = [NSNumber numberWithInt:0];
    _widgetSolarGenerationCurrent = [NSNumber numberWithInt:0];
    _widgetSolarGenerationDateRange = @"";
    _widgetSolarGenerationEndDate  = @"";
    _widgetSolarGenerationInverter = @"";
    _widgetSolarGenerationOrientation = @"";
    _widgetSolarGenerationReimbursement  = [NSNumber numberWithInt:0];
    _widgetSolarGenerationStartDate = @"";
    _widgetSolarGenerationkWh = [NSNumber numberWithInt:0];
    _widgetTextareaContent = @"";
    _widgetTotalCO2OffsetinTrees = @"";
    _widgetTotalEGin60WattBulbs = @"";
    _widgetTotalEGinFewerVehicles = @"";
    _widgetTotalEGinGasSaved = @"";
    _widgetURL = @"";
    _widgetWeatherType = @"";
    
    
    return  self;
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


- (NSDictionary * ) GetParamDic
{
    
    NSDictionary * fifthColorDic = [_fifthClr getDictionary];
    NSDictionary * fourthColorDic = [_fourthClr getDictionary];
    NSDictionary * headerFontDic = [_headerFnt getDictionary];
    NSDictionary * normal1FontDic = [_normal1Fnt getDictionary];
    NSDictionary * normal2FontDic =  [_normal2Fnt getDictionary];
    NSDictionary * primaryColorDic = [_primaryClr getDictionary];
    NSDictionary * secondaryColorDic = [_secondaryClr getDictionary];
    NSDictionary * seventhColorDic =  [_seventhClr getDictionary];
    NSDictionary * sixthColorDic = [_sixthClr getDictionary];
    NSDictionary * subHeaderFontDic = [_subHeaderFnt getDictionary];
    NSDictionary * tertiaryColorDic = [_tertiaryClr getDictionary];
    
    NSDictionary * dic = @{
        
    @"backgroundColor": _backgroundColor,
    @"backgroundColorLabel":  _backgroundColorLabel,
    @"backgroundColorVisible": _backgroundColorVisible,
    @"backgroundImage": _backgroundImage,
    @"backgroundImageLabel": _backgroundImageLabel,
    @"backgroundImageVisible" : _backgroundImageVisible,
    @"colCount": _colCount,
    @"colPosition":  _colPosition,
        @"duration" : _duration,
    @"endDate":  _endDate,
    @"fifthColor":  fifthColorDic,
    @"fourthColor": fourthColorDic,
    @"headerFont":   headerFontDic,
    @"minimumCols": _minimumCols,
    @"minimumRows": _minimumRows,
    @"normal1Font": normal1FontDic,
    @"normal2Font": normal2FontDic,
    @"previousTimelineRowPosition": _previousTimelineRowPosition,
    @"primaryColor": primaryColorDic,
    @"resizedOnTimeline": _resizedOnTimeline,
        @"rowCount" :_rowCount,
    @"rowPosition": _rowPosition,
    @"secondaryColor": secondaryColorDic,
    @"seventhColor": seventhColorDic,
    @"sixthColor": sixthColorDic,
    @"startDate": _startDate,
    @"subHeaderFont": subHeaderFontDic,
    @"tertiaryColor": tertiaryColorDic,
    
    @"timelineRowPosition": _timelineRowPosition,
    @"transitionIn": _transitionIn,
    @"transitionOut": _transitionOut,
    
    @"wIdgetGraphTemperatureChartType": _wIdgetGraphTemperatureChartType,
    @"widgetBorderColor": _widgetBorderColor,
    @"widgetEnergyCO2Kilograms": _widgetEnergyCO2Kilograms,
    @"widgetEnergyCombineInverters": _widgetEnergyCombineInverters,
    @"widgetEnergyDateRange": _widgetEnergyDateRange,
    @"widgetEnergyEndDate": _widgetEnergyEndDate,
    @"widgetEnergyGreenhouseKilograms" : _widgetEnergyGreenhouseKilograms,
    @"widgetEnergyInverter": _widgetEnergyInverter,
    @"widgetEnergyOrientation": _widgetEnergyOrientation,
    @"widgetEnergyStartDate": _widgetEnergyStartDate,
    @"widgetEnergyType" : _widgetEnergyType,
    @"widgetGraphBlockLabel" : _widgetGraphBlockLabel,
    @"widgetGraphCombineInverters" : _widgetGraphCombineInverters,
    @"widgetGraphCurrentPower": _widgetGraphCurrentPower,
    @"widgetGraphCurrentPowerChartType" : _widgetGraphCurrentPowerChartType,
    @"widgetGraphDateRange" : _widgetGraphDateRange,
    @"widgetGraphEndDate" : _widgetGraphEndDate,
    @"widgetGraphGeneration" : _widgetGraphGeneration,
    @"widgetGraphGenerationChartType" : _widgetGraphGenerationChartType,
    @"widgetGraphHumidity" : _widgetGraphHumidity,
    @"widgetGraphHumidityChartType" : _widgetGraphHumidityChartType,
    @"widgetGraphInterval": _widgetGraphInterval,
    @"widgetGraphInverter" : _widgetGraphInverter,
    @"widgetGraphIrradiance" : _widgetGraphIrradiance,
    @"widgetGraphIrradianceChartType" : _widgetGraphIrradianceChartType,
    @"widgetGraphMaxPower" : _widgetGraphMaxPower,
    @"widgetGraphMaxPowerChartType" : _widgetGraphMaxPowerChartType,
    @"widgetGraphStartDate" : _widgetGraphStartDate,
    @"widgetGraphTemperature" : _widgetGraphTemperature,
    @"widgetGraphWeather" : _widgetGraphWeather,
    @"widgetHowDoesSolarWorkOverallDuration" : _widgetHowDoesSolarWorkOverallDuration,
    @"widgetHowDoesSolarWorkStepFourDuration" : _widgetHowDoesSolarWorkStepFourDuration,
    @"widgetHowDoesSolarWorkStepFourText" : _widgetHowDoesSolarWorkStepFourText,
    @"widgetHowDoesSolarWorkStepOneDuration" : _widgetHowDoesSolarWorkStepOneDuration,
    @"widgetHowDoesSolarWorkStepOneText" : _widgetHowDoesSolarWorkStepOneText,
    @"widgetHowDoesSolarWorkStepThreeDuration" : _widgetHowDoesSolarWorkStepThreeDuration,
    @"widgetHowDoesSolarWorkStepThreeText" : _widgetHowDoesSolarWorkStepThreeText,
    @"widgetHowDoesSolarWorkStepTwoDuration" : _widgetHowDoesSolarWorkStepTwoDuration,
    @"widgetHowDoesSolarWorkStepTwoText" :  _widgetHowDoesSolarWorkStepTwoText,
    @"widgetIFrameUrl" : _widgetIFrameUrl,
    @"widgetRandomColor" : _widgetRandomColor,
    @"widgetSolarGenerationCombineInverters" : _widgetSolarGenerationCombineInverters,
    @"widgetSolarGenerationCurrent" : _widgetSolarGenerationCurrent,
    @"widgetSolarGenerationDateRange" : _widgetSolarGenerationDateRange,
    @"widgetSolarGenerationEndDate" : _widgetSolarGenerationEndDate,
    @"widgetSolarGenerationInverter" :  _widgetSolarGenerationInverter,
    @"widgetSolarGenerationOrientation" : _widgetSolarGenerationOrientation,
    @"widgetSolarGenerationReimbursement" : _widgetSolarGenerationReimbursement,
    @"widgetSolarGenerationStartDate" : _widgetSolarGenerationStartDate,
    @"widgetSolarGenerationkWh" :  _widgetSolarGenerationkWh,
    @"widgetTextareaContent" : _widgetTextareaContent,
    @"widgetTotalCO2OffsetinTrees" : _widgetTotalCO2OffsetinTrees,
    @"widgetTotalEGin60WattBulbs" : _widgetTotalEGin60WattBulbs,
    @"widgetTotalEGinFewerVehicles" : _widgetTotalEGinFewerVehicles,
    @"widgetTotalEGinGasSaved" : _widgetTotalEGinGasSaved,
    @"widgetURL" : _widgetURL,
    @"widgetWeatherType" : _widgetWeatherType,
    
    };
    
    return dic;
}


@end
