//
//  Tweet+Create.m
//  TweetMini
//
//  Created by Ayush on 09/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "Tweet+Create.h"

@implementation Tweet (Create)

+ (Tweet *)createTweetWithInfo:(id)info inManagedObjectCOntext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"tweetID = %@", [info objectForKey:@"id"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"tweetID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    Tweet *tempTweet = nil;
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"More than one matches when inserting tweet!");
        tempTweet = [matches lastObject];
    } else if ([matches count] == 1) {
        tempTweet = [matches lastObject];
    } else {
        tempTweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:context];
        
    }
    
    tempTweet.text = [info valueForKey:@"text"];
    tempTweet.tweetID = [info valueForKey:@"id"];
    
    tempTweet.user = [MiniUser createUserWithInfo:[info valueForKey:@"user"] inManagedObjectContext:context];
    id userDetails = [info valueForKey:@"user"];
    tempTweet.user.userID = [userDetails valueForKey:@"id"];
    tempTweet.user.name = [userDetails valueForKey:@"name"];
    tempTweet.user.screenName = [userDetails valueForKey:@"screen_name"];
    tempTweet.user.profileImageURL = [NSURL URLWithString:[userDetails valueForKey:@"profile_image_url"]];
}

@end
