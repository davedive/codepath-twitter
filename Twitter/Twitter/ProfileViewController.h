//
//  ProfileViewController.h
//  Twitter
//
//  Created by David Bernthal on 6/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(id) initWithUser:(UserInfo*)user;

@end
