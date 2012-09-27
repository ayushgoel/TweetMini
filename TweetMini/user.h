//
//  User.h
//  TweetMini
//
//  Created by Ayush on 9/27/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MiniUser;

@interface User : NSManagedObject

@property (nonatomic, retain) NSData * bigImage;
@property (nonatomic, retain) NSString * bigImageURL;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * favoritesCount;
@property (nonatomic, retain) NSNumber * followersCount;
@property (nonatomic, retain) NSNumber * friendsCount;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * statusCount;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * userDescription;
@property (nonatomic, retain) MiniUser *miniUser;

@end
