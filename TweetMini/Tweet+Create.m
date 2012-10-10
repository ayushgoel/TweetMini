//
//  Tweet+Create.m
//  TweetMini
//
//  Created by Ayush on 09/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "Tweet+Create.h"
#import "MiniUser+Create.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_TITLE_HEIGHT 30.0f
#define CELL_IMAGE_WIDTH 60.0f

@implementation Tweet (Create)

+ (Tweet *)createTweetWithInfo:(id)info inManagedObjectContext:(NSManagedObjectContext *)context
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
        tempTweet.text = [info valueForKey:@"text"];
        tempTweet.tweetID = [info valueForKey:@"id"];
        
        //todo: date-time and isFOrSelf
        tempTweet.user = [MiniUser createUserWithInfo:[info valueForKey:@"user"] inManagedObjectContext:context];
    }
    return tempTweet;
}

- (CGFloat)getRowHeight
{
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - CELL_IMAGE_WIDTH, 20000.0f);
    CGSize size;
    
    size = [self.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height;
    
    return height + (CELL_CONTENT_MARGIN) + CELL_TITLE_HEIGHT;
}
@end
