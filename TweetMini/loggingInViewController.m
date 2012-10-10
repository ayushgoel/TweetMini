//
//  loggingInViewController.m
//  TweetMini
//
//  Created by Ayush on 08/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "loggingInViewController.h"
#import "Accounts/Accounts.h"
#import "Twitter/Twitter.h"

@interface loggingInViewController ()

@end

@implementation loggingInViewController
@synthesize statusLabel = _statusLabel;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.statusLabel.text = @"Getting your timeline..";
}

-(void) viewDidAppear:(BOOL)animated
{
    self.statusLabel.text = @"Trying to get your twitter credentials";
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    if([TWTweetComposeViewController canSendTweet]){
        
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if(granted){
                self.statusLabel.text = @"Twitter Account verified";
//                NSLog(@"Going to segue");
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
