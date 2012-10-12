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
#import "User+Create.h"

@interface ProfileViewController ()
@end

@implementation ProfileViewController
@synthesize userID = _userID;
@synthesize nameLabel = _nameLabel, screenNameLabel = _screenNameLabel, userIDLabel = _userIDLabel;
@synthesize locationLabel = _locationLabel, creationDateLabel = _creationDateLabel, descriptionLabel = _descriptionLabel, tweetsLabel = _tweetsLabel, favoritesLabel = _favoritesLabel, followersLabel = _followersLabel, followingLabel = _followingLabel;
@synthesize profileImageView = _profileImageView;
@synthesize waitIndicator = _waitIndicator;

- (NSString *)userID
{
    if (!_userID) {
        _userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"selfUserID"];
    }
    return _userID;
}
- (void)setUserID:(NSString *)userID
{
    if (_userID != userID) {
        _userID = userID;
        NSLog(@"Added id to user defaults");
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"selfUserID"];
    }
}

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

-(void) completeUIDetails
{
    NSLog(@"Completing PVC");
    User *user = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@" userID= %@", self.userID];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:NO selector:nil]];
    NSError *error = nil;
    NSArray *match = [self.twitterDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!match || [match count]>1) {
        NSLog(@"Problem with match");
    } else if ([match count] == 0) {
        NSLog(@"No User Details Found!");
        NSLog(@"UserID: %@", self.userID);
    } else {
        NSLog(@"Setting UI");
        user = [match lastObject];
        self.nameLabel.text = user.miniUser.name;
        self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.miniUser.screenName];
        self.userIDLabel.text = user.userID;
        
        self.locationLabel.text = user.location;
        self.creationDateLabel.text = [NSString stringWithFormat:@"Since: %@", user.creationDate];
        self.descriptionLabel.text = user.userDescription;
        self.tweetsLabel.text = [NSString stringWithFormat:@"%@", user.statusCount];
        self.favoritesLabel.text = [NSString stringWithFormat:@"%@", user.favoritesCount];
        self.followersLabel.text = [NSString stringWithFormat:@"%@", user.followersCount];
        self.followingLabel.text = [NSString stringWithFormat:@"%@", user.friendsCount];
        
        [self.profileImageView setImageWithURL: [NSURL URLWithString:user.bigImageURL] placeholderImage:[UIImage imageNamed:@"profile.gif"]];
        [self.waitIndicator stopAnimating];
    }
    
}

-(void) getUserDetails
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    if([TWTweetComposeViewController canSendTweet]){
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {    
            if(granted){
                NSDictionary *param = [[NSDictionary alloc] init];
                
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"] parameters:param requestMethod:TWRequestMethodGET];
                [request setAccount:[[accountStore accountsWithAccountType:accountType] lastObject]];
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if(responseData){
                        NSError *jsonError;
                        NSArray *results = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                        if(results){
                            NSLog(@"Got Results");
                            self.userID = [NSString stringWithFormat:@"%@", [(id)results objectForKey:@"id"]];
                            [self.twitterDatabase.managedObjectContext performBlock:^{
                                [User createUserWithInfo:results inManagedObjectContext:self.twitterDatabase.managedObjectContext];
                            }];
                        }
                        else {
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

- (void)useDocument
{
    NSLog(@"useDoc");
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.twitterDatabase.fileURL path]]) {
        [self.twitterDatabase saveToURL:self.twitterDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            NSLog(@"Document Created");
        }];
    } else if (self.twitterDatabase.documentState == UIDocumentStateClosed) {
        [self.twitterDatabase openWithCompletionHandler:^(BOOL success) {
            NSLog(@"Open");
        }];
    } else if (self.twitterDatabase.documentState == UIDocumentStateNormal) {
        NSLog(@"Normal Document");
    }
}

- (void)setTwitterDatabase:(UIManagedDocument *)twitterDatabase
{
    NSLog(@"Setter called database");
    if (_twitterDatabase != twitterDatabase) {
        _twitterDatabase = twitterDatabase;
        [self performSelectorOnMainThread:@selector(useDocument) withObject:self waitUntilDone:YES];
    }
}

- (void)setManagedDocument
{
    if (!self.twitterDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"TwitterDatabase"];
        NSLog(@"Setting managed document");
        self.twitterDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.waitIndicator startAnimating];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [self setManagedDocument];
        if (!self.userID) {
            [self getUserDetails];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self completeUIDetails];
        }];
//        [self performSelectorOnMainThread:@selector(completeUIDetails) withObject:self waitUntilDone:NO];        
    }];
}

- (void)viewDidUnload
{
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
