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
#import "AFNetworking.h"
#import "user.h"

@interface ProfileViewController ()
@property (atomic, strong) user *tUser;
@end

@implementation ProfileViewController
@synthesize tUser;

@synthesize nameLabel, screenNameLabel, userIDLabel;
@synthesize locationLabel, creationDateLabel, descriptionLabel, tweetsLabel, favoritesLabel, followersLabel, followingLabel, profileImageView;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

-(void) completeUIDetails
{    
    NSLog(@"UI update");
    self.nameLabel.text = self.tUser.mUser.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tUser.mUser.screenName];
    self.userIDLabel.text = [NSString stringWithFormat:@"userID: %i", self.tUser.mUser.userId];

    self.locationLabel.text = self.tUser.location;
    self.creationDateLabel.text = [NSString stringWithFormat:@"Since: %@", self.tUser.creationDate];
    self.descriptionLabel.text = self.tUser.userDescription;
    self.tweetsLabel.text = [NSString stringWithFormat:@"%i", self.tUser.statusCount];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%i", self.tUser.favoritesCount];
    self.followersLabel.text = [NSString stringWithFormat:@"%i", self.tUser.followersCount];
    self.followingLabel.text = [NSString stringWithFormat:@"%i", self.tUser.friendsCount];
    
    self.userScrollView.hidden = FALSE;
    [self.profileImageView setImageWithURL: self.tUser.bigImageURL placeholderImage:[UIImage imageWithContentsOfFile:@"/Users/Goel/Desktop/iOSDev/TweetMini/TweetMini/profile.gif"]];
}

-(void) getUserDetails
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    if([TWTweetComposeViewController canSendTweet]){
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler: ^(BOOL granted, NSError *error){
            if(granted){
                    //                NSDictionary * param = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"0", @"0", @"20", nil] forKeys:[[NSArray alloc] initWithObjects:@"include_entities", @"trim_user", @"count", nil]];
                NSLog(@"granted");
                NSDictionary *param = [[NSDictionary alloc] init];
                
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"] parameters:param requestMethod:TWRequestMethodGET];
                [request setAccount:[[accountStore accountsWithAccountType:accountType] lastObject]];
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if(responseData){
                        NSError *jsonError;
                        NSArray *results = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                        if(results){
                                //                            NSLog(@"%@", results);
                            
                            NSLog(@"results");
                            self.tUser = [[user alloc] init];
                            self.tUser.mUser.userId = [[results valueForKey:@"id"] integerValue];
                            self.tUser.mUser.name = [results valueForKey:@"name"];
                            self.tUser.mUser.screenName = [results valueForKey:@"screen_name"];
                            self.tUser.mUser.profileImageURL = [results valueForKey:@"profile_image_url"];
                            
                            self.tUser.favoritesCount = [[results valueForKey:@"favourites_count"] integerValue];
                            self.tUser.followersCount = [[results valueForKey:@"followers_count"] integerValue];
                            self.tUser.friendsCount = [[results valueForKey:@"friends_count"] integerValue];
                            self.tUser.statusCount = [[results valueForKey:@"statuses_count"] integerValue];
                            
                            self.tUser.creationDate = [results valueForKey:@"created_at"];
                            self.tUser.userDescription = [results valueForKey:@"description"];
                            self.tUser.lang = [results valueForKey:@"lang"];
                            self.tUser.location = [results valueForKey:@"location"];
                            self.tUser.url = [NSURL URLWithString:[results valueForKey:@"url"]];
                            NSLog(@"user: %@", self.tUser);
                            [self completeUIDetails];

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.userScrollView.contentSize = CGSizeMake(320.0, 750.0);
    NSLog(@"view Loaded");
    self.userScrollView.hidden = TRUE;

    [self getUserDetails];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUserScrollView:nil];
    [self setLocationLabel:nil];
    [self setNameLabel:nil];
    [self setScreenNameLabel:nil];
    [self setCreationDateLabel:nil];
    [self setUserIDLabel:nil];
    [self setDescriptionLabel:nil];
    [self setTweetsLabel:nil];
    [self setFollowersLabel:nil];
    [self setFollowingLabel:nil];
    [self setFavoritesLabel:nil];
    [self setProfileImageView:nil];
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
