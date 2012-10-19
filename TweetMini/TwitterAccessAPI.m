//
//  TwitterAccessAPI.m
//  TweetMini
//
//  Created by Ayush on 19/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "TwitterAccessAPI.h"

@implementation TwitterAccessAPI
@synthesize accountStore = _accountStore;
@synthesize accountType = _accountType;

- (ACAccountStore *)accountStore {
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

- (ACAccountType *)accountType {
    if (!_accountType) {
        _accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    }
    return _accountType;
}

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation"
                                      message:msg
                                     delegate:self
                            cancelButtonTitle:@"Exit"
                            otherButtonTitles: nil];
}

- (void)withTwitterCallSelector:(SEL)willCallSelector withObject:(id)obj
{    
    if([TWTweetComposeViewController canSendTweet]){
        [self.accountStore requestAccessToAccountsWithType:self.accountType
                                                   options:nil
                                                completion:^(BOOL granted, NSError *error) {
            if(granted){
                
                [obj performSelector:willCallSelector];
                
            }
            else {
                
                UIAlertView *alert = [self getAlertViewWithMessage: @"Please \
                                      give permission to access your twitter \
                                      account in the Settings, then try again!"];
                [alert show];
            }
        }];
    }
    else {
        UIAlertView *alert = [self getAlertViewWithMessage:@"Please log into \
                              Twitter in the Settings, then try again!"];
        [alert show];
    }
            
}

@end
