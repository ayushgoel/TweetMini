//
//  ConnectViewController.m
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConnectViewController.h"

@interface ConnectViewController ()
@end

@implementation ConnectViewController

-(NSString *) getCellIdentifier {
    return @"connectTweetCell";
}

- (NSFetchRequest *)getFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"isForSelf = %@", [NSNumber numberWithBool:YES]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createTime"
                                                                                     ascending:NO
                                                                                      selector:nil]];
    return request;
}

- (TWRequest *)getTwitterRequest {
    NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"0", @"0", @"30", nil]
                                                         forKeys:[[NSArray alloc] initWithObjects:@"include_entities", @"trim_user", @"count", nil]];
    
    return [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/mentions.json"]
                               parameters:param
                            requestMethod:TWRequestMethodGET];
}

- (NSNumber *)isForSelf {
    return [NSNumber numberWithBool:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setManagedDocument];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
