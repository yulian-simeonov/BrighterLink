//
//  CreateDashboardView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "CreateDashboardView.h"

#import "SharedMembers.h"

@interface CreateDashboardView()
{
    CGPoint _ptFirstPosition;
}

@property (nonatomic, assign) IBOutlet UIView *mainView;

@property (nonatomic, assign) IBOutlet UIView *viewBlankCanvas;
@property (nonatomic, assign) IBOutlet UIView *viewBlankCanvasSubview;
@property (nonatomic, assign) IBOutlet UILabel *lblBlankCanvas;

@property (nonatomic, assign) IBOutlet UIView *viewStarterDashboard;
@property (nonatomic, assign) IBOutlet UIView *viewStarterDashboardSubview;
@property (nonatomic, assign) IBOutlet UILabel *lblStarterDashboard;

@property (nonatomic, assign) IBOutlet UIView *viewDashboardTitleView;
@property (nonatomic, assign) IBOutlet UITextField *txtDashboardTitle;

@property (nonatomic, assign) IBOutlet UIView *viewCollectionTitleView;
@property (nonatomic, assign) IBOutlet UITextField *txtCollectionTitle;

@property (nonatomic, assign) IBOutlet UIButton *btnAddDashboard;
@property (nonatomic, assign) IBOutlet UIButton *btnCancel;

@property (nonatomic, assign) NSInteger dashboardType;

@end

@implementation CreateDashboardView

- (void) awakeFromNib
{
    self.mainView.layer.cornerRadius = 5.0f;
    self.mainView.layer.borderColor = [UIColor colorWithRed:195.0f / 255.0f green:195.0f / 255.0f blue:195.0f / 255.0f alpha:1.0f].CGColor;
    self.mainView.layer.borderWidth = 1.0f;
    self.mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainView.layer.shadowOpacity = 0.5f;
    self.mainView.layer.shadowRadius = 3.0f;
    self.mainView.layer.shadowOffset = CGSizeMake(-3, 3);
    
    self.viewDashboardTitleView.layer.borderColor = [UIColor colorWithRed:235.0f / 255.0f green:235.0f / 255.0f  blue:235.0f / 255.0f alpha:1.0f].CGColor;
    self.viewDashboardTitleView.layer.borderWidth = 1;
    
    self.viewCollectionTitleView.layer.borderColor = [UIColor colorWithRed:235.0f / 255.0f green:235.0f / 255.0f  blue:235.0f / 255.0f alpha:1.0f].CGColor;
    self.viewCollectionTitleView.layer.borderWidth = 1;
    
    self.btnAddDashboard.layer.borderColor = [UIColor colorWithRed:43.0f / 255.0f green:180.0f / 255.0f  blue:103.0f / 255.0f alpha:1.0f].CGColor;
    self.btnAddDashboard.layer.borderWidth = 1;
    
    self.btnCancel.layer.borderColor = [UIColor colorWithRed:43.0f / 255.0f green:180.0f / 255.0f  blue:103.0f / 255.0f alpha:1.0f].CGColor;
    self.btnCancel.layer.borderWidth = 1;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBlankCanvas)];
    [self.viewBlankCanvas addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapStarterDashboard)];
    [self.viewStarterDashboard addGestureRecognizer:tapGesture1];
    tapGesture1 = nil;
    
    self.dashboardType = DASHBOARD_STARTER;
    
    [self updateUI];
}

- (void) layoutSubviews
{
    if(self.collection)
    {
        self.txtCollectionTitle.text = self.collection.title;
        self.txtCollectionTitle.userInteractionEnabled = NO;
    }
    
    if(self.dashboard)
    {
        self.txtDashboardTitle.text = self.dashboard.title;
        self.txtCollectionTitle.text = self.dashboard.collectionName;
        
        self.dashboardType = self.dashboard.type;
        
        [self.btnAddDashboard setTitle:@"Update Dashboard" forState:UIControlStateNormal];
    }
    
    [self updateUI];
}

- (IBAction)onAddDashboard:(id)sender
{
    NSString *collectionName = self.txtCollectionTitle.text;
    collectionName = [collectionName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    NSString *dashboardName = self.txtDashboardTitle.text;
    dashboardName = [dashboardName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(collectionName.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input a valid collection name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return ;
    }
    
    if(dashboardName.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input a valid dashboard name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return ;
    }
    
    if(self.dashboard)
    {
        self.dashboard.title = dashboardName;
        self.dashboard.collectionName = collectionName;
        
        [self.delegate updateDashboard:self.dashboard];
    }
    else
    {
        DashboardInfo *dashboardInfo = [[DashboardInfo alloc] initWithTitle:dashboardName collection:collectionName type:self.dashboardType];
        
        [self.delegate createNewDashboardWith:dashboardInfo];
    }
    
    [self removeFromSuperview];
}

- (IBAction)onCancel:(id)sender
{
    [self removeFromSuperview];
}

- (void) removeMeFromParent
{
    [self removeFromSuperview];
}

- (void) onTapBlankCanvas
{
    self.dashboardType = DASHBOARD_BLANK;
    
    [self updateUI];
}

- (void) onTapStarterDashboard
{
    self.dashboardType = DASHBOARD_STARTER;
    
    [self updateUI];
}

- (void) updateUI
{
    UIColor *activeColor = [UIColor colorWithRed:19.0f / 255.0f green:168.0f / 255.0f blue:93.0f / 255.0f  alpha:1.0f];
    UIColor *deactiveColor = [UIColor colorWithRed:183.0f / 255.0f green:183.0f / 255.0f blue:183.0f / 255.0f  alpha:1.0f];
    
    UIColor *blankCanvasColor = (self.dashboardType == DASHBOARD_BLANK) ? activeColor : deactiveColor;
    UIColor *starterDashboardColor = (self.dashboardType == DASHBOARD_STARTER) ? activeColor : deactiveColor;
    
    self.viewBlankCanvas.layer.cornerRadius = 5.0f;
    self.viewBlankCanvas.layer.borderColor = blankCanvasColor.CGColor;
    self.viewBlankCanvas.layer.borderWidth = 1;
    
    self.viewBlankCanvasSubview.layer.borderColor = blankCanvasColor.CGColor;
    self.viewBlankCanvasSubview.layer.borderWidth = 2;
    self.viewBlankCanvasSubview.backgroundColor = (self.dashboardType == DASHBOARD_BLANK) ? [UIColor colorWithRed:172.0f / 255.0f green:245.0f / 255.0f blue:189.0f / 255.0f alpha:1.0f] : [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f];
    
    self.lblBlankCanvas.textColor = blankCanvasColor;
    
    self.viewStarterDashboard.layer.cornerRadius = 5.0f;
    self.viewStarterDashboard.layer.borderColor = starterDashboardColor.CGColor;
    self.viewStarterDashboard.layer.borderWidth = 1;
    
    self.viewStarterDashboardSubview.layer.borderColor =activeColor.CGColor;
    self.viewStarterDashboardSubview.layer.borderWidth = 2;
    
    self.lblStarterDashboard.textColor = starterDashboardColor;
}

- (void) moveToUp:(float)duration
{
    [UIView animateWithDuration:duration animations:^{
        
        self.center = CGPointMake(self.center.x, 180);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) moveToDown:(float)duration
{
    float yPosition = CGRectGetHeight(self.superview.frame) / 2;
    
    [UIView animateWithDuration:duration animations:^{
        
        self.center = CGPointMake(self.center.x, yPosition);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.txtDashboardTitle == textField)
    {
        [self.txtCollectionTitle becomeFirstResponder];
    }
    else if(self.txtCollectionTitle == textField)
    {
        [self.txtCollectionTitle resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self moveToUp:0.3f];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(self.txtCollectionTitle == textField)
    {
        [self moveToDown:0.3f];
    }
    
    return YES;
}

@end
