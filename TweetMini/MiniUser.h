//
//  MiniUser.h
//  TweetMini
//
//  Created by Ayush on 09/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tweet, User;

@interface MiniUser : NSManagedObject

@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSString * profileImageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSData * smallImage;
@property (nonatomic, retain) User *userData;
@property (nonatomic, retain) NSSet *tweets;
@end

@interface MiniUser (CoreDataGeneratedAccessors)

- (void)addTweetsObject:(Tweet *)value;
- (void)removeTweetsObject:(Tweet *)value;
- (void)addTweets:(NSSet *)values;
- (void)removeTweets:(NSSet *)values;

@end
