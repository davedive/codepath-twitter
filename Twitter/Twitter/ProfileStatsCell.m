//
//  ProfileStatsCell.m
//  Twitter
//
//  Created by David Bernthal on 7/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ProfileStatsCell.h"

@implementation ProfileStatsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithUser:(UserInfo*)user
{
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%@", user.tweetCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%@", user.followingCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%@", user.followerCount];
}

@end
