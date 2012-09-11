//
//  tweetMiniViewController.m
//  TweetMini
//
//  Created by Ayush on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tweetMiniViewController.h"
#import "Twitter/Twitter.h"
#import "Accounts/Accounts.h"

@interface tweetMiniViewController ()

@end

@implementation tweetMiniViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSURL *url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=Twitter%20API&result_type=mixed"];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"Name: %@ %@", [JSON valueForKeyPath:@"max_id"], [JSON valueForKeyPath:@"results"]);
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
//        NSLog(@"Error: %@", error);
//    }];
//    [operation start];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSLog(@"Can Send: %i", [TWTweetComposeViewController canSendTweet]);
    if([TWTweetComposeViewController canSendTweet]){
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler: ^(BOOL granted, NSError *error){
            if(granted){
                ACAccount *account = [[accountStore accountsWithAccountType:accountType] lastObject];
                NSLog(@"User: %@", account);
            }
            else {
                NSLog(@"Not granted %@", error);
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:@"Please give permission to access your twitter account in the Settings, then try again!" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
    else {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:@"Please log into Twitter in the Settings, then try again!" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
        [alert show];
    }
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];
    NSLog(@"called");
        //Need something better to exit application
    exit(1);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
