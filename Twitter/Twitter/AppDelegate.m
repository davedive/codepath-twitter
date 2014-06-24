//
//  AppDelegate.m
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "Mantle.h"

@implementation NSURL (dictionaryFromQueryString)
-(NSDictionary *) dictionaryFromQueryString{
    
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BDBOAuthToken* accessToken = [UserInfo loadAuthTokenWithKey:@"twitterAccessToken"];
    CGFloat nRed=0.0/255.0;
    CGFloat nGreen=172.0/255.0;
    CGFloat nBlue=237.0/255.0;
    if (accessToken == nil)
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:loginVC];
        nvc.navigationBar.translucent = NO;
        nvc.navigationBar.barTintColor = [[UIColor alloc]initWithRed:nRed green:nGreen blue:nBlue alpha:0.0];
        nvc.navigationBar.tintColor = [UIColor whiteColor];
        self.window.rootViewController = nvc;
    } else
    {
        //Load user state from previous session
        [[TwitterClient getInstance].requestSerializer saveAccessToken:accessToken];
        TimelineViewController *timelineVC = [[TimelineViewController alloc] init];
        UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:timelineVC];
        nvc.navigationBar.translucent = NO;
        nvc.navigationBar.barTintColor = [[UIColor alloc]initWithRed:nRed green:nGreen blue:nBlue alpha:0.0];
        nvc.navigationBar.tintColor = [UIColor whiteColor];
        self.window.rootViewController = nvc;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"cptwitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"])
                [[TwitterClient getInstance] fetchAccessTokenWithPath:@"/oauth/access_token"
                                                       method:@"POST"
                                                 requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                                                      success:^(BDBOAuthToken *accessToken) {
                                                          NSLog(@"Access token recieved!");
                                                          [[TwitterClient getInstance].requestSerializer saveAccessToken:accessToken];
                                                          
                                                          //Set current user
                                                          [[TwitterClient getInstance] getAccountWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
                                                              NSLog(@"%@", response);
                                                              UserInfo *info = [MTLJSONAdapter modelOfClass:UserInfo.class fromJSONDictionary:response error:nil];
                                                              [UserInfo saveUserInfo:info key:@"twitterUserInfo"];
                                                              [UserInfo saveAuthToken:accessToken key:@"twitterAccessToken"];
                                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                              NSLog(@"failed to get timeline!");
                                                            }];
                                                          
                                                          CGFloat nRed=0.0/255.0;
                                                          CGFloat nGreen=172.0/255.0;
                                                          CGFloat nBlue=237.0/255.0;
                                                          TimelineViewController *timelineVC = [[TimelineViewController alloc] init];
                                                          UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:timelineVC];
                                                          nvc.navigationBar.translucent = NO;
                                                          nvc.navigationBar.barTintColor = [[UIColor alloc]initWithRed:nRed green:nGreen blue:nBlue alpha:0.0];
                                                          nvc.navigationBar.tintColor = [UIColor whiteColor];
                                                          self.window.rootViewController = nvc;
                                                      }
                                                      failure:^(NSError *error) {
                                                          NSLog(@"Error getting access token!");
                                                      }];
        }
        return YES;
    }
    return NO;
}

@end