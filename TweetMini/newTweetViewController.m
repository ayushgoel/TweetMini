//
//  newTweetViewController.m
//  TweetMini
//
//  Created by Ayush on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "newTweetViewController.h"

#define TweetURL @"http://api.twitter.com/1/statuses/update.json"

@interface newTweetViewController ()
@property (nonatomic, strong) TwitterAccessAPI *TapiObject;
@end

@implementation newTweetViewController
@synthesize tweetText = _tweetText;
@synthesize TapiObject = _TapiObject;

-(void) destroySelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tweetSend {
    ACAccount *tAccount = [[self.TapiObject.accountStore
                            accountsWithAccountType:self.TapiObject.accountType] lastObject];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"1" forKey:@"include_entities"];
    [param setObject:self.tweetText.text forKey:@"status"];
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:TweetURL]
                                             parameters:param
                                          requestMethod:TWRequestMethodPOST];
    [request setAccount:tAccount];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *output = [NSString stringWithFormat:@"Status code: %i", urlResponse.statusCode];
        NSLog(@"%@", output);
    }];
    
    [self performSelectorOnMainThread:@selector(destroySelf) withObject:self waitUntilDone:NO];
}

- (IBAction)tweetButtonPressed:(id)sender {
    self.TapiObject = [[TwitterAccessAPI alloc] init];
    [self.TapiObject withTwitterCallSelector:@selector(tweetSend) withObject:self];
}

- (void)textViewDidChange:(UITextView *) textView {
    int charsLeft = 140-self.tweetText.text.length;
    self.title = [NSString stringWithFormat:@"%d left", charsLeft];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self destroySelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tweetText becomeFirstResponder];
    self.tweetText.delegate = self;
    self.title = @"140 left";
}

- (void)viewDidUnload {
    [self setTweetText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
