//
//  MiniUser.h
//  TweetMini
//
//  Created by Ayush on 9/27/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tweet, User;

@interface MiniUser : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profileImageURL;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSData * smallImage;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSSet *tweets;
@property (nonatomic, retain) User *userData;
@end

@interface MiniUser (CoreDataGeneratedAccessors)

- (void)addTweetsObject:(Tweet *)value;
- (void)removeTweetsObject:(Tweet *)value;
- (void)addTweets:(NSSet *)values;
- (void)removeTweets:(NSSet *)values;

@end
