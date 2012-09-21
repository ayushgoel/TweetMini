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
#import "HomeViewController.h"

@interface tweetMiniViewController ()
@end

@implementation tweetMiniViewController
@synthesize statusLabel;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    statusLabel.text = @"Getting your timeline..";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    statusLabel.text = @"Trying to get your twitter credentials";
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    if([TWTweetComposeViewController canSendTweet]){
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler: ^(BOOL granted, NSError *error){
            if(granted){
                statusLabel.text = @"Twitter Account verified";
                [self performSegueWithIdentifier:@"userLoggedIn" sender:self];
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

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        //Need something better to exit application
    exit(1);
}

- (void)viewDidUnload
{
    [self setStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
