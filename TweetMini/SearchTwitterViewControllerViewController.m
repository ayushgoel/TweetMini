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
@property (nonatomic, strong) NSMutableArray *searchResult;
@end

@implementation SearchTwitterViewControllerViewController
@synthesize searchBar;
@synthesize tweetTable;
@synthesize searchResult;

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Search Results: %i", [self.searchResult count]);
    return [self.searchResult count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.searchResult objectAtIndex:[indexPath row]] rowHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"tweetCell";
    UITableViewCell * cell = nil;
    
    tweet *resTweet = [self.searchResult objectAtIndex:[indexPath row]];
    cell = [self.tweetTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [[cell detailTextLabel] setText:resTweet.text];
    [[cell textLabel] setText:resTweet.user.name];
    [cell.imageView setImageWithURL: resTweet.user.profileImageURL placeholderImage:[UIImage imageWithContentsOfFile:@"/Users/Goel/Desktop/iOSDev/TweetMini/TweetMini/profile.gif"]];
    return cell;
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
                    
                    [self.searchResult addObject:tempTweet];
                }];
                
                [self.tweetTable reloadData];
                [self.tweetTable setNeedsDisplay];
            }
            else {
                NSLog(@"%@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retrieving tweet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
            }
        }
        else {
            NSLog(@"No response");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No response for the search Query" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tweetTable setDataSource:self];
    self.searchBar.delegate = self;
    self.tweetTable.delegate = self;
    self.searchResult = [[NSMutableArray alloc] init];
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
