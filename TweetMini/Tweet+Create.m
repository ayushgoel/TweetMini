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

+ (Tweet *)createTweetWithInfo:(id)info isForSelf:(NSNumber *)isForSelf inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tweet *tempTweet = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"tweetID == %@", [info objectForKey:@"id_str"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"tweetID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"More than one matches when inserting tweet!");
        tempTweet = [matches lastObject];
    } else if ([matches count] == 1) {
        NSLog(@"Found Same");
        tempTweet = [matches lastObject];
    } else {
        tempTweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:context];
        tempTweet.text = [info objectForKey:@"text"];
        tempTweet.tweetID = [info objectForKey:@"id_str"];
        tempTweet.isForSelf = isForSelf;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        tempTweet.createTime = [dateFormatter dateFromString:[info objectForKey:@"created_at"]];

        tempTweet.user = [MiniUser createUserWithInfo:[info objectForKey:@"user"] inManagedObjectContext:context];
        NSLog(@"New Tweet Created");
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"User:%@ Text:%@ ID:%@ CreateTime:%@ ForSelf:%@", self.user, self.text, self.tweetID, self.createTime, self.isForSelf];

}
@end
