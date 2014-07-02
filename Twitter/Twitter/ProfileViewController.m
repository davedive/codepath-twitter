//
//  ProfileViewController.m
//  Twitter
//
//  Created by David Bernthal on 6/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderCell.h"
#import "TweetCell.h"
#import "ProfileStatsCell.h"
#import "TwitterClient.h"
#import "TweetViewController.h"
#import "UIView+SuperView.h"
#import "ComposeViewController.h"


@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (nonatomic, strong) NSArray* tweets;
@property (strong, nonatomic) TweetCell* stubCell;
@property (strong, nonatomic) UserInfo* user;

@end

@implementation ProfileViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithUser:(UserInfo*)user
{
    self = [super initWithNibName:@"ProfileViewController" bundle:nil];
    if (self) {
        self.user = user;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profileTableView.dataSource = self;
    self.profileTableView.delegate = self;
    [self.profileTableView registerNib:[UINib nibWithNibName:@"ProfileHeaderCell" bundle:nil] forCellReuseIdentifier:@"ProfileHeaderCell"];
    [self.profileTableView registerNib:[UINib nibWithNibName:@"ProfileStatsCell" bundle:nil] forCellReuseIdentifier:@"ProfileStatsCell"];
    [self.profileTableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.stubCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    self.navigationItem.title = @"Profile";
    
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
    [[TwitterClient getInstance] getUserFeedWithSuccess:self.user.username success:^(AFHTTPRequestOperation *operation, id response) {
        self.tweets = [Tweet tweetsWithArray:response];
        NSLog(@"%@", response);
        [self.profileTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to get user feed!");
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        return 210;
    } else if (indexPath.row == 1)
    {
        return 65;
    } else
    {
        [self.stubCell initWithTweet:self.tweets[indexPath.row - 2]];
        [self.stubCell layoutSubviews];
        
        CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        ProfileHeaderCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderCell"];
        [headerCell initWithUser:self.user];
    
        CGRect firstFrame;
        headerCell.pageView.frame = CGRectMake(0, 0, 320, 210);
        firstFrame.origin.x = 0;
        firstFrame.origin.y = 0;
        firstFrame.size = headerCell.pageView.frame.size;
        
        headerCell.firstView.frame = firstFrame;
        [headerCell.pageView addSubview:headerCell.firstView];
        
        CGRect secondFrame;
        secondFrame.origin.x = headerCell.pageView.frame.size.width;
        secondFrame.origin.y = 0;
        secondFrame.size = headerCell.pageView.frame.size;
        
        headerCell.secondView.frame = secondFrame;
        [headerCell.pageView addSubview:headerCell.secondView];
        
        headerCell.pageView.contentSize = CGSizeMake(headerCell.pageView.frame.size.width * 2, headerCell.pageView.frame.size.height);
        
        return headerCell;
        
    } else if (indexPath.row == 1)
    {
        ProfileStatsCell* statsCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileStatsCell"];
        [statsCell initWithUser:self.user];
        return statsCell;
        
    } else
    {
        TweetCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        [cell initWithTweet:self.tweets[indexPath.row - 2]];
    
        [cell.replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [cell.retweetButton addTarget:self action:@selector(retweetButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [cell.favoriteButton addTarget:self action:@selector(favoriteButtonClicked:) forControlEvents:UIControlEventTouchDown];
    
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 1)
    {
        TweetViewController *tweetvc = [[TweetViewController alloc] initWithTweet:self.tweets[indexPath.row - 2]];
        [self.navigationController pushViewController:tweetvc animated:YES];
    }
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
    NSIndexPath *indexPath = [self.profileTableView indexPathForCell: cell];
    Tweet* tweet = self.tweets[indexPath.row - 2];
    
    [[TwitterClient getInstance] retweetWithSuccess:tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        [self loadEntries];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to retweet");
    }];
}

-(void) favoriteButtonClicked:(id)sender
{
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.profileTableView indexPathForCell: cell];
    Tweet* tweet = self.tweets[indexPath.row - 2];
    
    [[TwitterClient getInstance] favoriteWithSuccess:tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        [self loadEntries];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to favorite");
    }];
}


@end
