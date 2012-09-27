//
//  Tweet.h
//  TweetMini
//
//  Created by Ayush on 9/27/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MiniUser;

@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * tweetId;
@property (nonatomic, retain) MiniUser *user;

@end
