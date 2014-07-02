//
//  MenuViewController.m
//  Twitter
//
//  Created by David Bernthal on 6/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MenuViewController.h"
#import "TimelineViewController.h"
#import "ProfileViewController.h"

@interface MenuViewController ()

- (IBAction)profileButton:(id)sender;
- (IBAction)homeButton:(id)sender;
- (IBAction)mentionsButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSArray* viewControllers;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (strong, nonatomic) NSNumber* menuShift;
@property (strong, nonatomic) NSNumber* contentShift;
@property (nonatomic) BOOL hidden;
@property (strong, nonatomic) UINavigationController* nvc;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.nvc = [[UINavigationController alloc] init];
        self.viewControllers = @[[[TimelineViewController alloc] initWithMode:mentionsMode], [[TimelineViewController alloc] initWithMode:homeMode],
                                 [[ProfileViewController alloc] initWithUser:[UserInfo loadUserInfoWithKey:@"twitterUserInfo"]]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidden = YES;
    
    [self.contentView addSubview:self.nvc.view];
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    UIPanGestureRecognizer* panHideRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanHide:)];
    [self.contentView addGestureRecognizer:panRecognizer];
    [self.menuView addGestureRecognizer:panHideRecognizer];
    
    self.menuView.frame = CGRectMake(0 - self.menuView.frame.size.width / 2, 0, self.menuView.frame.size.width, self.menuView.frame.size.height);
    [self.nvc setViewControllers:@[(UIViewController*)self.viewControllers[0]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)profileButton:(id)sender {
    [self.nvc setViewControllers:@[(UIViewController*)self.viewControllers[2]]];
}

- (IBAction)homeButton:(id)sender {
    [self.nvc setViewControllers:@[(UIViewController*)self.viewControllers[0]]];
}

- (IBAction)mentionsButton:(id)sender {
    [self.nvc setViewControllers:@[(UIViewController*)self.viewControllers[1]]];
}

- (void)onPan:(UIPanGestureRecognizer*)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.hidden)
        {
            self.menuShift = [NSNumber numberWithFloat:point.x + self.menuView.frame.size.width];
            self.contentShift = [NSNumber numberWithFloat:point.x];
        }
        else
        {
            self.menuShift = [NSNumber numberWithFloat:point.x];
            self.contentShift = [NSNumber numberWithFloat:point.x - self.menuView.frame.size.width];
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if (self.menuView.frame.origin.x <= 0)
        {
            self.menuView.frame = CGRectMake(point.x - self.menuShift.floatValue, 0, self.menuView.frame.size.width, self.menuView.frame.size.height);
            self.contentView.frame = CGRectMake(point.x - self.contentShift.floatValue, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint hidden = CGPointMake(0 - self.menuView.frame.size.width, 0);
            CGPoint shown = CGPointMake(0, 0);
            CGPoint hiddenContent = CGPointMake(0, 0);
            CGPoint shownContent = CGPointMake(self.menuView.frame.size.width, 0);
            if (velocity.x >= 0) {
                self.menuView.frame = CGRectMake(shown.x, shown.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                self.contentView.frame = CGRectMake(shownContent.x, shownContent.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
                self.hidden = NO;
            } else {
                self.menuView.frame = CGRectMake(hidden.x, hidden.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                self.contentView.frame = CGRectMake(hiddenContent.x, hiddenContent.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
                self.hidden = YES;
            }
                
        }];
    }
}

//Repeated code, fix this
- (void)onPanHide:(UIPanGestureRecognizer*)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.menuShift = [NSNumber numberWithFloat:point.x];
        self.contentShift = [NSNumber numberWithFloat:point.x - self.menuView.frame.size.width];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if (self.menuView.frame.origin.x <= 0)
        {
            self.menuView.frame = CGRectMake(point.x - self.menuShift.floatValue, 0, self.menuView.frame.size.width, self.menuView.frame.size.height);
            self.contentView.frame = CGRectMake(point.x - self.contentShift.floatValue, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint hidden = CGPointMake(0 - self.menuView.frame.size.width, 0);
            CGPoint shown = CGPointMake(0, 0);
            CGPoint hiddenContent = CGPointMake(0, 0);
            CGPoint shownContent = CGPointMake(self.menuView.frame.size.width, 0);
            if (velocity.x >= 0) {
                self.menuView.frame = CGRectMake(shown.x, shown.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                self.contentView.frame = CGRectMake(shownContent.x, shownContent.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
                self.hidden = NO;
            } else {
                self.menuView.frame = CGRectMake(hidden.x, hidden.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                self.contentView.frame = CGRectMake(hiddenContent.x, hiddenContent.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
                self.hidden = YES;
            }
            
        }];
    }
}

@end
