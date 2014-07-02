//
//  TwitterClient.m
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString* twitterAPIURL = @"https://api.twitter.com";

@implementation TwitterClient

+ (TwitterClient*)getInstance
{
    static TwitterClient* instance;
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:twitterAPIURL] consumerKey:@"rSaG4MchpHBpsWAu4DsvJVeLF" consumerSecret:@"qXQqxTh4LGKQc8aNEIiNPNy20UmX8EaQQMafj8sZHjEoms5Ceb"];
    });
    
    return instance;
}

- (void)getTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:nil success:success failure:failure];
}

- (void)getMentionsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

- (void)getUserFeedWithSuccess:(NSString*)screenName success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:screenName forKey:@"screen_name"];
    [self GET:@"1.1/statuses/user_timeline.json" parameters:parameters success:success failure:failure];
}

- (void)getUserWithSuccess:(NSString*)screenName success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:screenName forKey:@"screen_name"];
    [self GET:@"1.1/users/show.json" parameters:parameters success:success failure:failure];
}

- (void)getAccountWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (void)createTweetWithSuccess:(NSString*)tweet success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:tweet forKey:@"status"];
    [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}

- (void)retweetWithSuccess:(NSString*)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId] parameters:nil success:success failure:failure];
}

- (void)favoriteWithSuccess:(NSString*)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:tweetId forKey:@"id"];
    [self POST:@"1.1/favorites/create.json" parameters:parameters success:success failure:failure];
}

- (void)login
{
    [self deauthorize];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cptwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Request token recieved!");
        NSURL* authURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/authorize?oauth_token=%@", twitterAPIURL, requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"fail");
    }];
}



@end
