//
//  EquivalenceSegmentView.m
//  BrighterLink
//
//  Created by Andriy on 1/6/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import "EquivalenceSegmentView.h"

#import "SharedMembers.h"

#define EQUIVALENCE_ICON_WIDTH 60
#define EQUIVALENCE_CONTROLS_GAP 10

#define EQUIVALENCE_SEG_VIEW_MAX_WIDTH 280
#define EQUIVALENCE_SEG_VIEW_MIN_WIDTH 180

@interface EquivalenceSegmentView()

@property (nonatomic, assign) IBOutlet UIImageView *ivIcon;

@property (nonatomic, assign) IBOutlet UILabel *lblMainValue;

@property (nonatomic, assign) IBOutlet UILabel *lblDesciption;
@property (nonatomic, assign) IBOutlet UILabel *lblUnit;

@property (nonatomic, assign) IBOutlet UILabel *lblCOAvoided;
@property (nonatomic, assign) IBOutlet UILabel *lblGreenhouse;

@property (nonatomic, retain) NSDictionary *data;

@property (nonatomic, assign) BOOL showCO;
@property (nonatomic, assign) BOOL showGreen;

@property (nonatomic, assign) int segIndex;

@property (nonatomic, retain) NSDictionary *staticEquivalenceData;

@end

@implementation EquivalenceSegmentView

- (id) init
{
    if (self = [super init])
    {

    }
    return self;
}

- (void) setEquivalenceSegmentData:(NSDictionary *)data type:(NSString *)type co:(BOOL)showCO green:(BOOL)showGreen index:(int)index
{
    NSLog(@"%@", data);
    
    if(self.staticEquivalenceData == nil) [self initStaticEquivalceData];
    
    self.data = [data objectForKey:@"data"];
    
    self.showCO = showCO;
    self.showGreen = showGreen;
    
    self.segIndex = index;
    
    self.ivIcon.image = [UIImage imageNamed:[self getIconImageName:type index:index]];
    
    self.lblMainValue.text = [self getShowableValueString:[self getFieldName:type]];
    
    self.lblCOAvoided.text = [NSString stringWithFormat:@"CO2 Avoided: %@ pounds", [self getShowableObserverValueString:@"co2AvoidedInKilograms"]];
    self.lblCOAvoided.hidden = !showCO;
    
    self.lblGreenhouse.text = [NSString stringWithFormat:@"Greenhouse Emissions: %@ pounds", [self getShowableObserverValueString:@"greenhouseEmissionsInKilograms"]];
    self.lblGreenhouse.hidden = !showGreen;
    
    if(!showCO && showGreen)
    {
        self.lblGreenhouse.center = self.lblCOAvoided.center;
    }
    
    self.lblDesciption.text = [self getDescription:type];
    self.lblUnit.text = [self getUnit:type];
    
    UIColor *color = [[SharedMembers sharedInstance] getSegmentColorWithIndex:index];
    
    self.lblMainValue.textColor = color;
    self.lblDesciption.textColor = color;
    self.lblUnit.textColor = color;
    self.lblCOAvoided.textColor = color;
    self.lblGreenhouse.textColor = color;
    
    [self repositionControls];
}

- (void) repositionControls
{
    float width = MAX(EQUIVALENCE_SEG_VIEW_MIN_WIDTH, MIN(EQUIVALENCE_SEG_VIEW_MAX_WIDTH, self.frame.size.width));
    float height = EQUIVALENCE_ICON_WIDTH;
    
    [self.ivIcon sizeToFit];
    self.ivIcon.frame = CGRectMake(0, 0, CGRectGetWidth(self.ivIcon.frame) * 0.8, CGRectGetHeight(self.ivIcon.frame) * 0.8);
    
    self.ivIcon.center = CGPointMake(CGRectGetWidth(self.ivIcon.frame) / 2, EQUIVALENCE_ICON_WIDTH / 2);
    
    [self.lblMainValue sizeToFit];
    self.lblMainValue.center = CGPointMake(CGRectGetMaxX(self.ivIcon.frame) + EQUIVALENCE_CONTROLS_GAP + self.lblMainValue.frame.size.width / 2, EQUIVALENCE_ICON_WIDTH / 2);
    
    float pos = self.lblMainValue.frame.origin.x + self.lblMainValue.frame.size.width + EQUIVALENCE_CONTROLS_GAP;
    
    self.lblDesciption.frame = CGRectMake(0,0,width - (pos + EQUIVALENCE_CONTROLS_GAP),20);
    self.lblUnit.frame = CGRectMake(0,0,width - (pos + EQUIVALENCE_CONTROLS_GAP),EQUIVALENCE_ICON_WIDTH - 20);
    
    [self.lblDesciption sizeToFit];
    [self.lblUnit sizeToFit];
    
    float height1 = CGRectGetHeight(self.lblDesciption.frame);
    float height2 = CGRectGetHeight(self.lblUnit.frame);
    
    float heightText = height1 + height2;
    
    self.lblDesciption.frame = CGRectMake(pos,
                                          self.lblMainValue.center.y - heightText / 2,
                                          CGRectGetWidth(self.lblDesciption.frame),
                                          CGRectGetHeight(self.lblDesciption.frame));
    
    self.lblUnit.frame = CGRectMake(pos,
                                    self.lblMainValue.center.y - heightText / 2 + CGRectGetHeight(self.lblDesciption.frame),
                                    CGRectGetWidth(self.lblUnit.frame),
                                    CGRectGetHeight(self.lblUnit.frame));
    
    if(self.showCO)
    {
        self.lblCOAvoided.frame = CGRectMake(0, EQUIVALENCE_ICON_WIDTH, width , 20);
        
        height += self.lblCOAvoided.frame.size.height;
    }
    
    if(self.showCO)
    {
        self.lblGreenhouse.frame = CGRectMake(0, self.lblCOAvoided.frame.origin.y + self.lblCOAvoided.frame.size.height, width , 20);
        
        height += self.lblGreenhouse.frame.size.height;
    }
    
    height += 20;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
}

- (NSString *) getShowableValueString:(NSString *)keyword
{
    NSString *value = [self.data objectForKey:keyword];
    
    if(value == nil) return @"";
    
    float value_ = [value floatValue];
    
    NSString *showableValueString = [NSString stringWithFormat:@"%.2f", value_];
    
    return showableValueString;
}

- (NSString *) getShowableObserverValueString:(NSString *)keyword
{
    NSString *value = [self.data objectForKey:keyword];
    
    if(value == nil) return @"";
    
    float value_ = [value floatValue];
    
    NSString *showableValueString = [NSString stringWithFormat:@"%.3f", value_];
    
    return showableValueString;
}

- (NSString *) getFieldName:(NSString *)type
{
    NSString *field = [[self.staticEquivalenceData objectForKey:type] objectForKey:@"field"];
    
    if(field == nil) field = @"";
    
    return field;
}

- (NSString *) getDescription:(NSString *)type
{
    NSString *description = [[self.staticEquivalenceData objectForKey:type] objectForKey:@"description"];
    
    if(description == nil) description = @"";
    
    return description;
}

- (NSString *) getUnit:(NSString *)type
{
    NSString *unit = [[self.staticEquivalenceData objectForKey:type] objectForKey:@"unit"];
    
    if(unit == nil) unit = @"";
    
    return unit;
}

- (NSString *) getIconImageName:(NSString *)type index:(NSInteger)index
{
    NSString *iconName = [[self.staticEquivalenceData objectForKey:type] objectForKey:@"icon"];
    
    if(iconName == nil) return @"";
    
    NSString *fileName = [NSString stringWithFormat:@"equi_icon_%@_%d", iconName, (int)index];
    
    return fileName;
}

- (void) initStaticEquivalceData
{
    self.staticEquivalenceData = @{
                                   @"Electricity Homes Generated":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"building",
                                            @"class"    : @"blue",
                                            @"description" : @"Generated",
                                            @"unit"     : @"for Homes Electricity",
                                            @"field"    : @"homeElectricityUse"},
                                   
                                   @"Seedling Grown":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"hand-leaf",
                                            @"class"    : @"green-dark",
                                            @"description" : @"Tree seeding",
                                            @"unit"     : @"for 10 Years",
                                            @"field"     : @"numberOfTreeSeedlingsGrownFor10Years"
                                            },
                                   
                                   @"Gallons Gas Saved":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"stander",
                                            @"class"    : @"green",
                                            @"description" : @"Saved",
                                            @"unit"     : @"Gallons of Gas",
                                            @"field"     : @"gallonsOfGasoline"
                                            },
                                   
                                   @"Forests Conversion Prevented":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"leaf",
                                            @"class"    : @"purple-dark",
                                            @"description" : @"Prevented",
                                            @"unit"     : @"acres of foreset from conversion to cropland",
                                            @"field"     : @"acresOfUSForestsStoringCarbonForOneYear"
                                            },
                                   
                                   @"Cars Removed":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"car",
                                            @"class"    : @"purple",
                                            @"description" : @"Removed",
                                            @"unit"     : @"Cars",
                                            @"field"     : @"passengerVehiclesPerYear"
                                            },
                                   
                                   @"Waste Recycled":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"recycled",
                                            @"class"    : @"blue-dark",
                                            @"description" : @"Recycled",
                                            @"unit"     : @"Tons of Waste",
                                            @"field"     : @"tonsOfWasteRecycledInsteadOfLandfilled"
                                            },
                                   
                                   @"Forests Preserved":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"forests",
                                            @"class"    : @"yellow",
                                            @"description" : @"Preserved",
                                            @"unit"     : @"Acres of US forests",
                                            @"field"     : @"acresOfUSForestPreservedFromConversionToCropland"
                                            },
                                   
                                   @"Plants Idled":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"factory",
                                            @"class"    : @"grey-dark",
                                            @"description" : @"Idled",
                                            @"unit"     : @"Coal Fired Power Plants",
                                            @"field"     : @"coalFiredPowerPlantEmissionsForOneYear"
                                            },
                                   
                                   @"Coal Eliminated":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"railcar",
                                            @"class"    : @"grey",
                                            @"description" : @"Eliminated",
                                            @"unit"     : @"Railcars of coal",
                                            @"field"     : @"railcarsOfCoalburned"
                                            },
                                   
                                   @"Energy Homes Generated":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"house",
                                            @"class"    : @"red-dark",
                                            @"description" : @"Generated",
                                            @"unit"     : @"Energy for homes",
                                            @"field"     : @"homeEnergyUse"
                                            },
                                   
                                   @"Oil Unneeded":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"oil-drum",
                                            @"class"    : @"red",
                                            @"description" : @"Unneeded",
                                            @"unit"     : @"Barrels of Oil",
                                            @"field"     : @"barrelsOfOilConsumed"
                                            },
                                   
                                   @"Propane Cylinders":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"propane-cylinder",
                                            @"class"    : @"yellow-dark",
                                            @"description" : @"Unburned",
                                            @"unit"     : @"Propane cylinders",
                                            @"field"     : @"propaneCylindersUsedForHomeBarbecues"
                                            },
                                   
                                   @"Tanker Gas Saved":
                                       @{   @"title"    : @"Reduced greenhouse emissions over the past 30 days",
                                            @"icon"     : @"truck",
                                            @"class"    : @"grey-light",
                                            @"description" : @"Saved",
                                            @"unit"     : @"Tanker Trucks of Gas",
                                            @"field"     : @"tankerTrucksFilledWithGasoline"
                                            }
                                   };
}

@end
