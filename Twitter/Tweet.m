//
//  Tweet.m
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss '+0000' yyyy";
    return dateFormatter;
}

+ (NSDateFormatter *)returnDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"MM/dd/yy',' HH:mm a";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"profileURL": @"user.profile_image_url",
             @"name": @"user.name",
             @"username": @"user.screen_name",
             @"tweet": @"text",
             @"timestamp": @"created_at",
             @"retweetCount": @"retweet_count",
             @"favoriteCount": @"favorite_count",
             @"tweetId": @"id_str"
             };
}

+ (NSValueTransformer *)timestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

- (NSString *)timestampToString {
    return [[Tweet returnDateFormatter] stringFromDate:self.timestamp];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        Tweet *tweet = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:dictionary error:nil];
        [tweets addObject:tweet];
    }
    
    return tweets;
}

@end
