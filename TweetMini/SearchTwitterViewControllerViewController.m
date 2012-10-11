//
//  SearchTwitterViewControllerViewController.m
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchTwitterViewControllerViewController.h"
#import "Twitter/Twitter.h"
#import "AFNetworking.h"

@implementation tweet
@synthesize tweetID, text, rowHeight, userName, userProfileImageURL;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_TITLE_HEIGHT 30.0f
#define CELL_IMAGE_WIDTH 60.0f

- (CGFloat)rowHeight
{
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - CELL_IMAGE_WIDTH, 20000.0f);
    CGSize size;
    
    size = [self.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height;
    
    return height + (CELL_CONTENT_MARGIN) + CELL_TITLE_HEIGHT;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"Text:%@", text];
}
@end

@implementation SearchTwitterViewControllerViewController
@synthesize searchBar = _searchBar;
@synthesize searchResults = _searchResults;
@synthesize tweetTable = _tweetTable;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.searchResults objectAtIndex:[indexPath row]] rowHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"tweetCell";
    UITableViewCell * cell = nil;
    
    tweet *resTweet = [self.searchResults objectAtIndex:[indexPath row]];
    cell = [self.tweetTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = resTweet.userName;
    cell.detailTextLabel.text = resTweet.text;
    [cell.imageView setImageWithURL: resTweet.userProfileImageURL placeholderImage:[UIImage imageNamed:@"profile.gif"]];
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
                    tempTweet.text = [obj objectForKey:@"text"];
                    tempTweet.tweetID = [obj objectForKey:@"id"];
                    tempTweet.userName = [obj objectForKey:@"from_user"];
                    tempTweet.userProfileImageURL = [obj objectForKey:@"profile_image_url"];
                    
                    [self.searchResults addObject:tempTweet];
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
    [self.searchBar resignFirstResponder];
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
    self.searchBar.delegate = self;
    self.tweetTable.dataSource = self;
    self.tweetTable.delegate = self;
    self.searchResults = [[NSMutableArray alloc] init];
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
