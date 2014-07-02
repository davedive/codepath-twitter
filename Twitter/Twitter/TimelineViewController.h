//
//  TimelineViewController.h
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    mentionsMode,
    homeMode
} TweetSource;

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(id) initWithMode:(TweetSource)source;

@end
