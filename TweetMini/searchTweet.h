//
//  searchTweet.h
//  TweetMini
//
//  Created by Ayush on 11/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface searchTweet : NSObject
@property (nonatomic, strong) NSString *tweetID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSURL *userProfileImageURL;
@end
