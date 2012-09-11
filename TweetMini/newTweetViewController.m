//
//  newTweetViewController.m
//  TweetMini
//
//  Created by Ayush on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "newTweetViewController.h"

@interface newTweetViewController ()
@end

@implementation newTweetViewController
-(void) destroySelf
{
    [self dismissModalViewControllerAnimated:YES];    
}


- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self destroySelf];
    }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
