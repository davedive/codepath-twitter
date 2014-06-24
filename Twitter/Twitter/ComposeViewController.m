//
//  ComposeViewController.m
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ComposeViewController.h"
#import "UserInfo.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *composeTextField;

@property (strong, nonatomic) NSString *replyUserName;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithReply:(NSString*)username
{
    self = [self initWithNibName:@"ComposeViewController" bundle:nil];
    self.replyUserName = username;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.composeTextField.delegate = self;
    
    UserInfo* info = [UserInfo loadUserInfoWithKey:@"twitterUserInfo"];
    
    NSURL* profileURL = [NSURL URLWithString:info.profileImageURL];
    [self.profileImageView setImageWithURL:profileURL];
    self.nameLabel.text = info.name;
    self.userNameLabel.text = info.username;
    if (self.replyUserName != nil)
        self.composeTextField.text = [NSString stringWithFormat:@"%@", self.replyUserName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [[TwitterClient getInstance] createTweetWithSuccess:self.composeTextField.text success:^(AFHTTPRequestOperation *operation, id response) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Faliure to tweet");
    }];
    return YES;
}

@end
