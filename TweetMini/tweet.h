//
//  tweet.h
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "miniUser.h"

@interface tweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) miniUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic) CGFloat rowHeight;

@end
