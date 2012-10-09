//
//  Tweet+Create.h
//  TweetMini
//
//  Created by Ayush on 09/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "Tweet.h"
#import "MiniUser.h"

@interface Tweet (Create)

+ (Tweet *)createTweetWithInfo:(id)info inManagedObjectCOntext:(NSManagedObjectContext *)context;

@end
