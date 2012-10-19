//
//  HomeViewController.m
//  TweetMini
//
//  Created by Ayush on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@end

@implementation HomeViewController

-(NSString *) getCellIdentifier
{
    return @"homeTweetCell";
}

- (NSFetchRequest *)getFetchRequest
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"isForSelf = %@", [NSNumber numberWithBool:NO]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO selector:nil]];
    return request;    
}

- (TWRequest *)getTwitterRequest
{
    NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"0", @"true", @"0", @"50", nil] forKeys:[[NSArray alloc] initWithObjects:@"include_entities", @"exclude_replies", @"trim_user", @"count", nil]];
    return [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"] parameters:param requestMethod:TWRequestMethodGET];
}

- (NSNumber *)isForSelf
{
    return [NSNumber numberWithBool:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setManagedDocument];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
