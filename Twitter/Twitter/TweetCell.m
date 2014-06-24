
//
//  TweetCell.m
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithTweet:(Tweet*)tweet
{
    
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.username];
    self.nameLabel.text = tweet.name;
    self.timestampLabel.text = tweet.timestamp.shortTimeAgoSinceNow;
    self.tweetTextLabel.text = tweet.tweet;
    [self.tweetTextLabel sizeToFit];
    
    NSURL *imageURL = [NSURL URLWithString:tweet.profileURL];
    //CHANGE
    
    [self.profileImageView setImageWithURL:imageURL];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
}

@end
