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
@synthesize tweetCharsLeft;
@synthesize tweetText;

-(void) textViewDidChange:(UITextView *)textView{
    int charsLeft = 140-tweetText.text.length;
    if(charsLeft <0){
        [tweetCharsLeft setTextColor:[UIColor colorWithRed:0.5 green:0.2 blue:0.3 alpha:0.9]];
    }
    else {
        [tweetCharsLeft setTextColor:[UIColor lightTextColor]];
    }
    tweetCharsLeft.text = [NSString stringWithFormat:@"%d left", charsLeft];
}

-(void) destroySelf
{
    [self dismissModalViewControllerAnimated:YES];    
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self destroySelf];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tweetText becomeFirstResponder];
//    tweetViewDelegate *viewDelegate = [[tweetViewDelegate alloc] init];
    tweetText.delegate = self;
    
    // Do any additional setup after loading the view.
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
