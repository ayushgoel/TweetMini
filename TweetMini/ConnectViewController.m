//
//  ConnectViewController.m
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConnectViewController.h"
#import "Twitter/Twitter.h"
#import "Accounts/Accounts.h"
#import "tweet.h"
#import "AFNetworking.h"

@interface ConnectViewController ()
@end

@implementation ConnectViewController
@synthesize connectTable;

-(UITableView *) getTableViewObject
{
    return self.connectTable;
}

-(NSString *) getCellIdentifier
{
    return @"connectTweetCell";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.connectTable setDataSource:self];
    [self.connectTable setDelegate:self];
    self.TTimeline = [[NSMutableArray alloc] init];
    
    NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"0", @"0", @"20", nil] forKeys:[[NSArray alloc] initWithObjects:@"include_entities", @"trim_user", @"count", nil]];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/mentions.json"] parameters:param requestMethod:TWRequestMethodGET];

    [self getTimelineWithParam: param usingRequest: request];
}

- (void)viewDidUnload
{
    [self setConnectTable:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
