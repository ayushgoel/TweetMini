//
//  HomeViewController.m
//  TweetMini
//
//  Created by Ayush on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "Twitter/Twitter.h"
#import "Accounts/Accounts.h"
#import "tweet.h"
#import "AFNetworking.h"

@interface HomeViewController ()
@end

@implementation HomeViewController
@synthesize homeTable;

-(UITableView *) getTableViewObject
{
    return self.homeTable;
}

-(NSString *) getCellIdentifier
{
    return @"homeTweetCell";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.homeTable setDataSource:self];
    [self.homeTable setDelegate:self];
    self.TTimeline = [[NSMutableArray alloc] init];
    
    NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"0", @"true", @"0", @"20", nil] forKeys:[[NSArray alloc] initWithObjects:@"include_entities", @"exclude_replies", @"trim_user", @"count", nil]];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"] parameters:param requestMethod:TWRequestMethodGET];

    [self getTimelineWithParam: param usingRequest: request];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setHomeTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
