//
//  newTweetViewController.m
//  TweetMini
//
//  Created by Ayush on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "newTweetViewController.h"
#import "Accounts/Accounts.h"

@interface newTweetViewController ()
@end

@implementation newTweetViewController
@synthesize tweetCharsLeft = _tweetCharsLeft;
@synthesize tweetText = _tweetText;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

- (IBAction)tweetButtonPressed:(id)sender {

    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if([TWTweetComposeViewController canSendTweet]){
    
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler: ^(BOOL granted, NSError *error){
            if(granted){

                ACAccount *tAccount = [[ACAccount alloc] init];;
                tAccount = [[accountStore accountsWithAccountType:accountType] lastObject];

                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setObject:@"1" forKey:@"include_entities"];
                [param setObject:self.tweetText.text forKey:@"status"];
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:param requestMethod:TWRequestMethodPOST];
                [request setAccount:tAccount];
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"Status code: %i", urlResponse.statusCode];
                    NSLog(@"%@", output);
                }];
                
                [self performSelectorOnMainThread:@selector(destroySelf) withObject:self waitUntilDone:NO];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:@"Please give permission to access your twitter account in the Settings, then try again!" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:@"Please log into Twitter in the Settings, then try again!" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
        [alert show];
    }
}

-(void) textViewDidChange:(UITextView *)textView{
    int charsLeft = 140-self.tweetText.text.length;
    if(charsLeft <0){
        [self.tweetCharsLeft setTextColor:[UIColor colorWithRed:0.5 green:0.2 blue:0.3 alpha:0.9]];
    }
    else {
        [self.tweetCharsLeft setTextColor:[UIColor lightTextColor]];
    }
    self.tweetCharsLeft.text = [NSString stringWithFormat:@"%d left", charsLeft];
}

-(void) destroySelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self destroySelf];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tweetText becomeFirstResponder];
    self.tweetText.delegate = self;

    [self.tweetCharsLeft setTextColor:[UIColor lightTextColor]];
    self.tweetCharsLeft.text = @"140 left";
}

- (void)viewDidUnload
{
    [self setTweetText:nil];
    [self setTweetCharsLeft:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
