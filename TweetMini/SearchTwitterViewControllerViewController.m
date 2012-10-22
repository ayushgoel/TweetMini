//
//  SearchTwitterViewControllerViewController.m
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchTwitterViewControllerViewController.h"

@implementation SearchTwitterViewControllerViewController
@synthesize searchBar = _searchBar;
@synthesize searchResults = _searchResults;
@synthesize tweetTable = _tweetTable;
@synthesize cache = _cache;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg {
    return [[UIAlertView alloc] initWithTitle:@"Twitter Response Error" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Results in array: %i", [self.searchResults count]);
    return [self.searchResults count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.searchResults objectAtIndex:[indexPath row]] rowHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Creating cell");
    NSString * cellIdentifier = @"tweetCell";
    UITableViewCell * cell = nil;
    
    __block searchTweet *resTweet = [self.searchResults objectAtIndex:[indexPath row]];
    cell = [self.tweetTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = resTweet.userName;
    cell.detailTextLabel.text = resTweet.text;
    cell.imageView.image = [UIImage imageNamed:@"profile.gif"];
    if ([self.cache objectForKey:resTweet.userName]) {
        NSLog(@"Image in cache");
        cell.imageView.image = [UIImage imageWithData:[self.cache objectForKey:resTweet.userName]];
    } else {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            NSLog(@"Setting image to cache %@", resTweet.userName);
            NSData *data = [NSData dataWithContentsOfURL:resTweet.userProfileImageURL];
            [self.cache setObject:data forKey:resTweet.userName];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                cell.imageView.image = [UIImage imageWithData:[self.cache objectForKey:resTweet.userName]];
            }];
        }];
    }
    return cell;
}

-(void) populateTweetWithSearch: (NSString *) searchTerm {
    NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:searchTerm, @"mixed", @"false", @"20", nil] forKeys:[[NSArray alloc] initWithObjects:@"q", @"result_type", @"include_entities", @"rpp", nil]];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://search.twitter.com/search.json"] parameters:param requestMethod:TWRequestMethodGET];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(responseData){
            NSLog(@"Data recieved");
            NSError *jsonError;
            NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
            if(JSON){
                id results = [JSON valueForKey:@"results"];
                NSLog(@"Results: %i", [results count]);
                self.tableView.scrollEnabled = NO;
                self.searchResults = [[NSMutableArray alloc] init];
                [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    searchTweet *tempTweet = [[searchTweet alloc] init];
                    tempTweet.text = [obj objectForKey:@"text"];
                    tempTweet.tweetID = [obj objectForKey:@"id_str"];
                    tempTweet.userName = [obj objectForKey:@"from_user_name"];
                    tempTweet.userProfileImageURL = [NSURL URLWithString:[obj objectForKey:@"profile_image_url"]];
                    NSLog(@"Tweet created");
                    [self.searchResults addObject:tempTweet];
                }];
                NSLog(@"All tweets created");
                [self.tweetTable reloadData];
                [self.tweetTable setNeedsDisplay];
                self.tweetTable.scrollEnabled = YES;
                NSLog(@"tableView set needs display");
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
    [self.searchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBari {
    NSLog(@"Got search: %@", searchBari.text);
    [self populateTweetWithSearch:searchBari.text];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBari {
    [searchBari resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tweetTable.dataSource = self;
    self.tweetTable.delegate = self;
    self.searchResults = [[NSMutableArray alloc] init];
    self.cache = [[NSCache alloc] init];
    NSLog(@"VC set");
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [self setTweetTable:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
