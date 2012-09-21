//
//  ProfileViewController.m
//  TweetMini
//
//  Created by Ayush on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "Accounts/Accounts.h"
#import "Twitter/Twitter.h"
#import "user.h"

@interface ProfileViewController ()
@property (atomic, strong) user *tUser;
@end

@implementation ProfileViewController
@synthesize tUser;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userScrollView.contentSize = CGSizeMake(320.0, 750.0);
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    if([TWTweetComposeViewController canSendTweet]){
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler: ^(BOOL granted, NSError *error){
            if(granted){
//                NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"0", @"0", @"20", nil] forKeys:[[NSArray alloc] initWithObjects:@"include_entities", @"trim_user", @"count", nil]];
                NSDictionary *param = [[NSDictionary alloc] init];
                
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"] parameters:param requestMethod:TWRequestMethodGET];
                [request setAccount:[[accountStore accountsWithAccountType:accountType] lastObject]];
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if(responseData){
                        NSError *jsonError;
                        NSArray *results = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                        if(results){
                            NSLog(@"%@", results);
                            
                            tUser.mUser.userId = [[results valueForKey:@"id"] integerValue];
                            tUser.mUser.name = [results valueForKey:@"name"];
                            tUser.mUser.screenName = [results valueForKey:@"screen_name"];
                            tUser.mUser.profileImageURL = [results valueForKey:@"profile_image_url"];
                            
                            tUser.favoritesCount = [[results valueForKey:@"favourites_count"] integerValue];
                            tUser.followersCount = [[results valueForKey:@"followers_count"] integerValue];
                            tUser.friendsCount = [[results valueForKey:@"friends_count"] integerValue];
                            tUser.statusCount = [[results valueForKey:@"statuses_count"] integerValue];
                            
                            tUser.creationDate = [results valueForKey:@"created_at"];
                            tUser.description = [results valueForKey:@"description"];
                            tUser.lang = [results valueForKey:@"lang"];
                            tUser.location = [results valueForKey:@"location"];
                            tUser.url = [NSURL URLWithString:[results valueForKey:@"url"]];
                        }
                        else {
                            NSLog(@"%@", error);
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retrieving tweet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                    else {
                        NSLog(@"No response");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No response for the search Query" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        [alert show];
                    }
                }];
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

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUserScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}


@end
