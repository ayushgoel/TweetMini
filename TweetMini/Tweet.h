//
//  Tweet.h
//  TweetMini
//
//  Created by Ayush on 09/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MiniUser;

@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * tweetID;
@property (nonatomic, retain) NSNumber * isForSelf;
@property (nonatomic, retain) MiniUser *user;

@end
