//
//  TimelineViewController.m
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "Tweet.h"
#import "UserInfo.h"
#import "LoginViewController.h"

@interface UIView (SuperView)

- (UIView *)findSuperViewWithClass:(Class)superViewClass;

@end


@implementation UIView (SuperView)

- (UIView *)findSuperViewWithClass:(Class)superViewClass
{
    
    UIView *superView = self.superview;
    UIView *foundSuperView = nil;
    
    while (nil != superView && nil == foundSuperView) {
        if ([superView isKindOfClass:superViewClass]) {
            foundSuperView = superView;
        } else {
            superView = superView.superview;
        }
    }
    return foundSuperView;
}
@end

@interface TimelineViewController ()

@property (nonatomic, strong) NSArray* tweets;
@property (strong, nonatomic) TweetCell* stubCell;

@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (nonatomic, strong) UIRefreshControl* refresh;

@end

@implementation TimelineViewController

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
    
    self.timelineTableView.dataSource = self;
    self.timelineTableView.delegate = self;
    [self.timelineTableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.stubCell = [self.timelineTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    self.refresh = [[UIRefreshControl alloc] init];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.timelineTableView addSubview:self.refresh];
    [self.refresh addTarget:self action:@selector(loadEntries) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOut)];
    self.navigationItem.leftBarButtonItem = signOutButton;
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onCompose)];
    self.navigationItem.rightBarButtonItem = composeButton;
    self.navigationItem.title = @"Home";
    
    [self loadEntries];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadEntries];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadEntries
{
    [[TwitterClient getInstance] getTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        self.tweets = [Tweet tweetsWithArray:response];
        NSLog(@"%@", response);
        [self.timelineTableView reloadData];
        [self.refresh endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to get timeline!");
        [self.refresh endRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.stubCell initWithTweet:self.tweets[indexPath.row]];
    [self.stubCell layoutSubviews];
    
    CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    [cell initWithTweet:self.tweets[indexPath.row]];
    
    [cell.replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [cell.retweetButton addTarget:self action:@selector(retweetButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [cell.favoriteButton addTarget:self action:@selector(favoriteButtonClicked:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetViewController *tweetvc = [[TweetViewController alloc] initWithTweet:self.tweets[indexPath.row]];
    [self.navigationController pushViewController:tweetvc animated:YES];
}

- (void)onSignOut
{
    //Erase current user
    [UserInfo saveAuthToken:nil key:@"twitterAccessToken"];
    [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
}

- (void)onCompose
{
    ComposeViewController *composeVC = [[ComposeViewController alloc] init];
    [self.navigationController pushViewController:composeVC animated:YES];
}

-(void) replyButtonClicked:(id)sender
{
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    ComposeViewController *composeVC = [[ComposeViewController alloc] initWithReply:cell.userNameLabel.text];
    [self.navigationController pushViewController:composeVC animated:YES];
}

-(void) retweetButtonClicked:(id)sender
{
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.timelineTableView indexPathForCell: cell];
    Tweet* tweet = self.tweets[indexPath.row];
    
    [[TwitterClient getInstance] retweetWithSuccess:tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        [self loadEntries];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to retweet");
    }];
}

-(void) favoriteButtonClicked:(id)sender
{
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.timelineTableView indexPathForCell: cell];
    Tweet* tweet = self.tweets[indexPath.row];
    
    [[TwitterClient getInstance] favoriteWithSuccess:tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        [self loadEntries];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to favorite");
    }];
}

@end
