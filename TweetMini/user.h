//
//  user.h
//  TweetMini
//
//  Created by Ayush on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface user : NSObject

@property (nonatomic) NSInteger favoritesCount;
@property (nonatomic) NSInteger followersCount;
@property (nonatomic) NSInteger friendsCount;
@property (nonatomic) NSInteger statusCount;

@property (nonatomic, strong) NSString *creationDate;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSURL *url;

@end
