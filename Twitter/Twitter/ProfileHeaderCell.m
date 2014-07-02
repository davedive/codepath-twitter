//
//  ProfileHeaderCell.m
//  Twitter
//
//  Created by David Bernthal on 7/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ProfileHeaderCell

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
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.username];
    self.nameLabel.text = user.name;
    self.description.text = user.description;
    
    NSURL *profileImageURL = [NSURL URLWithString:user.profileImageURL];
    NSURL *backgroundImageURL = [NSURL URLWithString:user.backgroundImageURL];
    
    [self.profileImageView setImageWithURL:profileImageURL];
    [self.fisrtBackgroundImageView setImageWithURL:backgroundImageURL];
    [self.secondBackgroundImageView setImageWithURL:backgroundImageURL];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.pageView.frame.size.width;
    int page = floor((self.pageView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

@end
