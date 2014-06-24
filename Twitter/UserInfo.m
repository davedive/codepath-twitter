//
//  UserInfo.m
//  Twitter
//
//  Created by David Bernthal on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"username": @"screen_name",
             @"profileImageURL": @"profile_image_url"
             };
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.profileImageURL forKey:@"profileImageURL"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.profileImageURL = [decoder decodeObjectForKey:@"profileImageURL"];
    }
    return self;
}

+ (void)saveUserInfo:(UserInfo *)info key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:info];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

+ (UserInfo *)loadUserInfoWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    UserInfo *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

+ (void)saveAuthToken:(BDBOAuthToken *)token key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:token];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

+ (BDBOAuthToken *)loadAuthTokenWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    BDBOAuthToken *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
