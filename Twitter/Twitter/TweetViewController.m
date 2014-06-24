//
//  TweetViewController.m
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (strong, nonatomic) Tweet *currentTweet;

@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTweet:(Tweet *)tweet
{
    self = [super initWithNibName:@"TweetViewController" bundle:nil];
    if (self) {
        self.currentTweet = tweet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *profileURL = [NSURL URLWithString:self.currentTweet.profileURL];
    [self.profileImageView setImageWithURL:profileURL];
    self.nameLabel.text = self.currentTweet.name;
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", self.currentTweet.username];
    self.tweetLabel.text = self.currentTweet.tweet;
    self.timestampLabel.text = [self.currentTweet timestampToString];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%@", self.currentTweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%@", self.currentTweet.favoriteCount];
    //TODO Set views
    [self.replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.retweetButton addTarget:self action:@selector(retweetButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.favoriteButton addTarget:self action:@selector(favoriteButtonClicked:) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.title = @"Tweet";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) replyButtonClicked:(id)sender
{
    ComposeViewController *composeVC = [[ComposeViewController alloc] initWithReply:self.currentTweet.username];
    [self.navigationController pushViewController:composeVC animated:YES];
}

-(void) retweetButtonClicked:(id)sender
{
    [[TwitterClient getInstance] retweetWithSuccess:self.currentTweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to retweet");
    }];
}

-(void) favoriteButtonClicked:(id)sender
{
    [[TwitterClient getInstance] favoriteWithSuccess:self.currentTweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to favorite");
    }];
}

@end
