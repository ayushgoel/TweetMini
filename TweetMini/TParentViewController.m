//
//  TParentViewController.m
//  TweetMini
//
//  Created by Ayush on 9/21/12.
//
//

#import "TParentViewController.h"
#import "tweet.h"
#import "AFNetworking.h"
#import "Twitter/Twitter.h"
#import "Accounts/Accounts.h"

@interface TParentViewController ()
@end

@implementation TParentViewController

-(UITableView *) getTableViewObject
{
    return [[UITableView alloc] init];
}

-(NSString *) getCellIdentifier
{
    return [[NSString alloc] init];
}

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.TTimeline count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.TTimeline objectAtIndex:[indexPath row]] rowHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = [self getCellIdentifier];
    UITableViewCell * cell = nil;
    
    tweet *resTweet = [self.TTimeline objectAtIndex:[indexPath row]];
    cell = [self.getTableViewObject dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [[cell detailTextLabel] setText:resTweet.text];
    [[cell textLabel] setText:resTweet.user.name];
    [cell.imageView setImageWithURL: resTweet.user.profileImageURL placeholderImage:[UIImage imageWithContentsOfFile:@"/Users/Goel/Desktop/iOSDev/TweetMini/TweetMini/profile.gif"]];
    return cell;
}

-(void) getTimelineWithParam: (NSDictionary *) param usingRequest: (TWRequest *) request
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if([TWTweetComposeViewController canSendTweet]){
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler: ^(BOOL granted, NSError *error){
            
            if(granted){
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
                                
                                [self.TTimeline addObject:tempTweet];
                                
                            }];
                            
                            [[self getTableViewObject] reloadData];
                            [[self getTableViewObject] setNeedsDisplay];
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

@end
