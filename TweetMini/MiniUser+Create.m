//
//  MiniUser+Create.m
//  TweetMini
//
//  Created by Ayush on 09/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "MiniUser+Create.h"

@implementation MiniUser (Create)

+ (MiniUser *)createUserWithInfo:(id)info inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MiniUser"];
    request.predicate = [NSPredicate predicateWithFormat:@"userID == %@", [info objectForKey:@"id_str"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    MiniUser *miniUser = nil;
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"More than one matches when inserting MiniUser!");
        miniUser = [matches lastObject];
    } else if ([matches count] == 1) {
        miniUser = [matches lastObject];
    } else {
        miniUser = [NSEntityDescription insertNewObjectForEntityForName:@"MiniUser" inManagedObjectContext:context];
        miniUser.userID = [info objectForKey:@"id_str"];
        miniUser.name = [info objectForKey:@"name"];
        miniUser.screenName = [info objectForKey:@"screen_name"];
        miniUser.profileImageURL = [info objectForKey:@"profile_image_url"];
    }
    return miniUser;
}

+ (MiniUser *)createMiniUserWithInfo:(id)info inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MiniUser"];
    request.predicate = [NSPredicate predicateWithFormat:@"userID == %@", [NSString stringWithFormat:@"%@", [info objectForKey:@"id"]]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    MiniUser *miniUser = nil;
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"More than one matches when inserting MiniUser!");
        miniUser = [matches lastObject];
    } else if ([matches count] == 1) {
        miniUser = [matches lastObject];
    } else {
        miniUser = [NSEntityDescription insertNewObjectForEntityForName:@"MiniUser" inManagedObjectContext:context];
        miniUser.userID = [NSString stringWithFormat:@"%@", [info objectForKey:@"id"]];
        miniUser.name = [info objectForKey:@"name"];
        miniUser.screenName = [info objectForKey:@"screen_name"];
        miniUser.profileImageURL = [info objectForKey:@"profile_image_url"];
    }
    return miniUser;

}

- (void)addImageData:(NSData *)data forUserID:(NSString *)userID inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MiniUser"];
    request.predicate = [NSPredicate predicateWithFormat:@"userID == %@", userID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    __block NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    MiniUser *miniUser = nil;

    if (!matches) {
        NSLog(@"No matches array!");
    } else if ([matches count]>1) {
        NSLog(@"More than one photo with same ID: %@ %@", userID, [[matches lastObject] name]);
    } else if ([matches count] == 1) {
        miniUser = [matches lastObject];
        miniUser.smallImage = data;
        [context performBlock:^{
            [context save:&error];            
        }];
    } else {
        NSLog(@"What is this? Please check!");
    }
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"ID: %@ Name: %@ Handle: %@ ImageURL: %@", self.userID, self.name, self.screenName, self.profileImageURL];
}

@end
