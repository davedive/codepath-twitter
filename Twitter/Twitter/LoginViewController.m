//
//  LoginViewController.m
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()

- (IBAction)onLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *twitterLogoImageView;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (IBAction)onLogin:(id)sender
{
    [[TwitterClient getInstance] login];
}

@end
