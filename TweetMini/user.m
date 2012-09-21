//
//  user.m
//  TweetMini
//
//  Created by Ayush on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "user.h"

@implementation user
@synthesize mUser;
@synthesize followersCount, favoritesCount, friendsCount, statusCount, creationDate, userDescription, lang, location, url;
@synthesize bigImageURL;

-(NSURL *) bigImageURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image?screen_name=%@&size=bigger", self.mUser.screenName]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"User: %@  followers: %i favorites: %i friends: %i status: %i date: %@ description: %@ lang: %@ location: %@ url: %@", mUser, followersCount, favoritesCount, friendsCount, statusCount, creationDate, userDescription, lang, location, url];
}

- (id)init {
    self = [super init];
    if (self) {
            // Initialize self.
        self.mUser = [[miniUser alloc] init];
    }
    return self;
}

@end
