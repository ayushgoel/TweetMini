//
//  miniUser.m
//  TweetMini
//
//  Created by Ayush on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "miniUser.h"

@implementation miniUser

@synthesize userId, name, screenName, profileImageURL;

- (NSString *)description
{
    return [NSString stringWithFormat:@"ID: %i Name: %@ Handle: %@ ImageURL: %@", userId, name, screenName, profileImageURL];
}

@end
