//
//  tweet.h
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic) CGFloat rowHeight;

@end
