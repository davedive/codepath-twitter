//
//  UserInfo.h
//  Twitter
//
//  Created by David Bernthal on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
#import "BDBOAuth1RequestOperationManager.h"

@interface UserInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *profileImageURL;

+ (void)saveUserInfo:(UserInfo *)info key:(NSString *)key;
+ (UserInfo *)loadUserInfoWithKey:(NSString *)key;
+ (void)saveAuthToken:(BDBOAuthToken *)token key:(NSString *)key;
+ (BDBOAuthToken *)loadAuthTokenWithKey:(NSString *)key;

@end
