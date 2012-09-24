//
//  SearchTwitterViewControllerViewController.m
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchTwitterViewControllerViewController.h"
#import "tweet.h"
#import "Twitter/Twitter.h"
#import "AFNetworking/AFNetworking.h"

@interface SearchTwitterViewControllerViewController ()
@end

@implementation SearchTwitterViewControllerViewController
@synthesize searchBar;
@synthesize tweetTable;

-(UITableView *) getTableViewObject
{
    return self.tweetTable;
}

-(NSString *) getCellIdentifier
{
    return @"tweetCell";
}

-(void) populateTweetWithSearch: (NSString *) searchTerm
{
    NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:searchTerm, @"mixed", @"false", @"20", nil] forKeys:[[NSArray alloc] initWithObjects:@"q", @"result_type", @"include_entities", @"rpp", nil]];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://search.twitter.com/search.json"] parameters:param requestMethod:TWRequestMethodGET];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(responseData){
            NSError *jsonError;
            NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
            if(JSON){
                id results = [JSON valueForKey:@"results"];
                [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    tweet *tempTweet = [[tweet alloc] init];
                    tempTweet.text = [obj valueForKey:@"text"];
                    tempTweet.tweetId = [obj valueForKey:@"id"];

                    tempTweet.user.name = tempTweet.user.screenName = [obj valueForKey:@"from_user"];
                    tempTweet.user.userId = [[obj valueForKey:@"from_user_id"] intValue]; 
                    tempTweet.user.profileImageURL = [NSURL URLWithString:[obj valueForKey:@"profile_image_url"]];
                    
                    [self.TTimeline addObject:tempTweet];
                }];
                
                [self.tweetTable reloadData];
                [self.tweetTable setNeedsDisplay];
            }
            else {
                NSLog(@"%@", error);
                UIAlertView *alert = [self getAlertViewWithMessage:@"Error retrieving tweet"];
                [alert show];
            }
        }
        else {
            NSLog(@"%@", error);
            UIAlertView *alert = [self getAlertViewWithMessage:@"No response for the search Query"];
            [alert show];
        }
    }];
    [searchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBari
{
    [self populateTweetWithSearch:searchBari.text];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBari{
    [searchBari resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tweetTable setDataSource:self];
    self.searchBar.delegate = self;
    self.tweetTable.delegate = self;
    self.TTimeline = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setTweetTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
