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
@property (nonatomic, strong) NSMutableArray *connectTimeline;
@end

@implementation ConnectViewController
@synthesize connectTable;
@synthesize connectTimeline;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.connectTimeline count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.connectTimeline objectAtIndex:[indexPath row]] rowHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"connectTweetCell";
    UITableViewCell * cell = nil;
    
    tweet *resTweet = [self.connectTimeline objectAtIndex:[indexPath row]];
    cell = [self.connectTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [[cell detailTextLabel] setText:resTweet.text];
    [[cell textLabel] setText:resTweet.user.name];
    [cell.imageView setImageWithURL: resTweet.user.profileImageURL placeholderImage:[UIImage imageWithContentsOfFile:@"/Users/Goel/Desktop/iOSDev/TweetMini/TweetMini/profile.gif"]];
    return cell;
}

-(void) getTimeline
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    if([TWTweetComposeViewController canSendTweet]){
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler: ^(BOOL granted, NSError *error){
            if(granted){
                NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"0", @"0", @"20", nil] forKeys:[[NSArray alloc] initWithObjects:@"include_entities", @"trim_user", @"count", nil]];
                
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/mentions.json"] parameters:param requestMethod:TWRequestMethodGET];
                [request setAccount:[[accountStore accountsWithAccountType:accountType] lastObject]];
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if(responseData){
                        NSError *jsonError;
                        NSArray *results = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                        if(results){
                            [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                tweet *tempTweet = [[tweet alloc] init];
                                tempTweet.user.name = [[obj valueForKey:@"user"] valueForKey:@"name"];
                                tempTweet.text = [obj valueForKey:@"text"];
                                tempTweet.user.profileImageURL = [NSURL URLWithString:[[obj valueForKey:@"user"] valueForKey:@"profile_image_url"]];
                                
                                [self.connectTimeline addObject:tempTweet];
                            }];
                            
                            [self.connectTable reloadData];
                            [self.connectTable setNeedsDisplay];
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
            }
            else {
                
                UIAlertView *alert = [self getAlertViewWithMessage: @"Please give permission to access your twitter account in the Settings, then try again!"];
                [alert show];
            }
        }];
    }
    else {
        UIAlertView *alert = [self getAlertViewWithMessage:@"Please log into Twitter in the Settings, then try again!"];
        [alert show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.connectTable setDataSource:self];
    [self.connectTable setDelegate:self];
    self.connectTimeline = [[NSMutableArray alloc] init];
    [self getTimeline];
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
