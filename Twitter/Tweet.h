//
//  Tweet.h
//  Twitter
//
//  Created by David Bernthal on 6/19/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *profileURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *tweet;
@property (strong, nonatomic) NSDate *timestamp;
@property (strong, nonatomic) NSNumber *retweetCount;
@property (strong, nonatomic) NSNumber *favoriteCount;
@property (strong, nonatomic) NSString *tweetId;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
- (NSString *)timestampToString;

@end
