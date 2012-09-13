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
@synthesize tabBar;
@synthesize tAccount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", [tabBar items]);    
	// Do any additional setup after loading the view.
    
//    NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"Twitter Api", @"mixed", nil] forKeys:[[NSArray alloc] initWithObjects:@"q", @"result_type", nil]];
//
//    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://search.twitter.com/search.json"] parameters:param requestMethod:TWRequestMethodGET];
//    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//        if(responseData){
//            NSError *jsonError;
//            NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
//            if(timeline){
////                NSLog(@"id: %@", [[timeline valueForKey:@"results"] valueForKey:@"id"]);
////                NSLog(@"%@", timeline);
//            }
//            else {
//                NSLog(@"%@", error);
//            }
//        }
//        else {
//            NSLog(@"No response");
//        }
//    }];
//    
//    param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"1", nil] forKeys:[[NSArray alloc] initWithObjects:@"include_entities", nil]];
//    
//    request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"] parameters:param requestMethod:TWRequestMethodGET];
//    [request setAccount:self.tAccount];
//    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//        if(responseData){
//            NSError *jsonError;
//            NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
//            if(timeline){
////                NSLog(@"Starts here ---- %@", timeline);
//            }
//            else {
//                NSLog(@"%@", error);
//            }
//        }
//        else {
//            NSLog(@"No response");
//        }
//    }];

}

- (void)viewDidUnload
{
    [self setTabBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
