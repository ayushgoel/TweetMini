//
//  loggingInViewController.m
//  TweetMini
//
//  Created by Ayush on 08/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "loggingInViewController.h"

@interface loggingInViewController ()
@end

@implementation loggingInViewController
@synthesize statusLabel = _statusLabel;

- (void)prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    self.statusLabel.text = @"Getting your timeline..";
}

- (void)completeSegue {
    self.statusLabel.text = @"Twitter Account verified";
    //                NSLog(@"Going to segue");
    [self performSegueWithIdentifier:@"userLoggedIn" sender:self];
}

-(void) viewDidAppear:(BOOL)animated
{
    self.statusLabel.text = @"Trying to get your twitter credentials";
    
    TwitterAccessAPI *TapiObject = [[TwitterAccessAPI alloc] init];
    [TapiObject withTwitterCallSelector:@selector(completeSegue) withObject:self];
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
