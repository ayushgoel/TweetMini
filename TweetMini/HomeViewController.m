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

@interface HomeViewController ()
@property (nonatomic, strong) NSMutableArray *homeTimeline;
@end

@implementation HomeViewController
@synthesize homeTable;
@synthesize homeTimeline;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.homeTimeline count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.homeTimeline objectAtIndex:[indexPath row]] rowHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"homeTweetCell";
    UITableViewCell * cell = nil;
    
    tweet *resTweet = [self.homeTimeline objectAtIndex:[indexPath row]];
    cell = [self.homeTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [[cell detailTextLabel] setText:resTweet.text];
    [[cell textLabel] setText:resTweet.user.name];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:resTweet.user.profileImageURL]];   
    return cell;
}

-(void) getTimeline
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    if([TWTweetComposeViewController canSendTweet]){
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler: ^(BOOL granted, NSError *error){
            if(granted){
                NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"0", @"true", @"0", @"20", nil] forKeys:[[NSArray alloc] initWithObjects:@"include_entities", @"exclude_replies", @"trim_user", @"count", nil]];
                
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"] parameters:param requestMethod:TWRequestMethodGET];
                [request setAccount:[[accountStore accountsWithAccountType:accountType] lastObject]];
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if(responseData){
                        NSError *jsonError;
                        NSArray *results = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];

                        if(results){
                            [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

                                tweet *tempTweet = [[tweet alloc] init];
                                tempTweet.text = [obj valueForKey:@"text"];
                                tempTweet.tweetId = [obj valueForKey:@"id"];
                                
                                id userDetails = [obj valueForKey:@"user"];
                                tempTweet.user.userId = [[userDetails valueForKey:@"id"] intValue];
                                tempTweet.user.name = [userDetails valueForKey:@"name"];
                                tempTweet.user.screenName = [userDetails valueForKey:@"screen_name"];
                                tempTweet.user.profileImageURL = [NSURL URLWithString:[userDetails valueForKey:@"profile_image_url"]];

                                [self.homeTimeline addObject:tempTweet];

                            }];
                            
                            [self.homeTable reloadData];
                            [self.homeTable setNeedsDisplay];
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
    [self.homeTable setDataSource:self];
    [self.homeTable setDelegate:self];
    self.homeTimeline = [[NSMutableArray alloc] init];
    [self getTimeline];
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
