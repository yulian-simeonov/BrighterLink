//
//  CISnapshotVC.m
//  CarIQ
//
//  Created by Ping Ahn on 9/26/14.
//  Copyright (c) 2014 Ping Ahn. All rights reserved.
//

#import "SharePresentView.h"
#import "SharedMembers.h"

@interface SharePresentView ()

@property (weak, nonatomic) IBOutlet UIImageView *snapshotIV;

@end

@implementation SharePresentView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _snapshotImage = nil;
//        http://localhost:3000/presentation?id=5470cb9d354f301004c12a56
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString * link  = [SharedMembers sharedInstance].curPresent._id;
    NSString * presentLink = [ NSString stringWithFormat:@"%@/presentation?id=%@", HostAddress, link];
    [_m_lPresentLink setText: presentLink];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _snapshotIV.image = nil;
}

- (IBAction)closeBtnPressed:(id)sender {
    id<SharePresentViewDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(SharePresentViewDidCloseButtonPressed:)]) {
        [strongDelegate SharePresentViewDidCloseButtonPressed:self];
    }
}

- (IBAction) onSend:(id)sender
{
    if ( [_m_lEmail.text isEqualToString:@""] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please fill Email Address"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    NSString * email  = _m_lEmail.text;
    NSString * link   = _m_lPresentLink.text;
    
    NSDictionary * dic  = @{ @"email": email,  @"message": @"Presentation ID", @"link" : link };
    
    [[SharedMembers sharedInstance].webManager CreatePresentationLinkEmail:dic success:^(MKNetworkOperation *networkOperation) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SUCESS !!!"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        NSLog(@"failed");
    }];
}

@end
