//
//  TwitterAccessAPI.m
//  TweetMini
//
//  Created by Ayush on 19/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "TwitterAccessAPI.h"

@interface TwitterAccessAPI ()
@property (nonatomic, strong) id obj;
@end

@implementation TwitterAccessAPI
@synthesize accountStore = _accountStore;
@synthesize accountType = _accountType;
@synthesize obj = _obj;

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
- (UIAlertView *)getAlertViewWithMessage:(NSString *)msg andDelegate:(id)obj {
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation"
                                      message:msg
                                     delegate:obj
                            cancelButtonTitle:@"Exit"
                            otherButtonTitles: nil];
}

- (void)showAlertWithMessage:(NSString *)msg {
    UIAlertView *alert = [self getAlertViewWithMessage:msg andDelegate:self.obj];
    [alert show];
}

- (void)withTwitterCallSelector:(SEL)willCallSelector withObject:(id)obj
{
    self.obj = obj;
    
    if([TWTweetComposeViewController canSendTweet]){
        [self.accountStore requestAccessToAccountsWithType:self.accountType
                                                   options:nil
                                                completion:^(BOOL granted, NSError *error) {
            if(granted){
                
                [obj performSelector:willCallSelector];
                
            }
            else {
                NSString *msg = @"Please give permission to access your twitter account in the Settings, then try again!";
                [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:msg waitUntilDone:YES];
            }
        }];
    }
    else {
        NSString *msg = @"Please log into Twitter in the Settings, then try again!";
        [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:msg waitUntilDone:YES];
    }
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //Need something better to exit application
    NSLog(@"wer");
    exit(1);
}

@end
