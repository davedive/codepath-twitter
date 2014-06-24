//
//  ComposeViewController.h
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController <UITextFieldDelegate>

- (id)initWithReply:(NSString*)username;

@end
