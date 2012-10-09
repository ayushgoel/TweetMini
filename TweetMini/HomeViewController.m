//
//  HomeViewController.m
//  TweetMini
//
//  Created by Ayush on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "Twitter/Twitter.h"

@interface HomeViewController ()
@end

@implementation HomeViewController

-(NSString *) getCellIdentifier
{
    return @"homeTweetCell";
}

- (void)requestForTimelineusing:(UIManagedDocument *)document
{
    NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"0", @"true", @"0", @"20", nil] forKeys:[[NSArray alloc] initWithObjects:@"include_entities", @"exclude_replies", @"trim_user", @"count", nil]];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"] parameters:param requestMethod:TWRequestMethodGET];
    
    [self getTimelineWithParam:param usingRequest:request inDocument:document];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setManagedDocument];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
