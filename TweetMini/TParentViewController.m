//
//  TParentViewController.m
//  TweetMini
//
//  Created by Ayush on 9/21/12.
//
//

#import "TParentViewController.h"
#import "AFNetworking.h"
#import "Twitter/Twitter.h"
#import "Accounts/Accounts.h"
#import "Tweet.h"
#import "MiniUser.h"

@interface TParentViewController ()
@end

@implementation TParentViewController

-(NSString *) getCellIdentifier
{
    return [[NSString alloc] init];
}

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

#pragma Document functions

- (void)setupFetchedResultsController
{
    //    NSLog(@"Setting up FRC");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO selector:nil]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.twitterDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    //    NSLog(@"Set up");
}

- (void)useDocument
{
//    NSLog(@"useDoc");
    if (![[NSFileManager defaultManager] fileExistsAtPath: [self.twitterDatabase.fileURL path]]) {
        [self.twitterDatabase saveToURL:self.twitterDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            NSLog(@"Document Created");
            [self setupFetchedResultsController];
            [self requestForTimelineusing:self.twitterDatabase];
        }];
    } else if (self.twitterDatabase.documentState == UIDocumentStateClosed) {
        [self.twitterDatabase openWithCompletionHandler:^(BOOL success) {
            NSLog(@"Open");
            [self setupFetchedResultsController];
        }];
    } else if (self.twitterDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setTwitterDatabase:(UIManagedDocument *)twitterDatabase
{
//    NSLog(@"Setting Twitterdatabase");
    if (_twitterDatabase != twitterDatabase) {
        _twitterDatabase = twitterDatabase;
        [self useDocument];
    }
}

- (void)setManagedDocument
{
    if (!self.twitterDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Twitter Database"];
        self.twitterDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}

#pragma TVC methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = [self getCellIdentifier];
    UITableViewCell * cell = nil;
    
    Tweet *resTweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = resTweet.user.name;
    cell.detailTextLabel.text = resTweet.text;

    [cell.imageView setImageWithURL:[NSURL URLWithString:resTweet.user.profileImageURL] placeholderImage:[UIImage imageNamed:@"profile.gif"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.fetchedResultsController objectAtIndexPath:indexPath] getRowHeight];
}

#pragma Network Data Methods

- (void)requestForTimelineusing:(UIManagedDocument *)document
{}

- (void)getTimelineWithParam: (NSDictionary *) param usingRequest: (TWRequest *) request inDocument:(UIManagedDocument *)document
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if([TWTweetComposeViewController canSendTweet]){
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if(granted){
                [request setAccount:[[accountStore accountsWithAccountType:accountType] lastObject]];
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if(responseData){
                        NSError *jsonError;
                        NSArray *results = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                        
                        if(results){
                            [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                
                                Tweet *tempTweet = [[Tweet alloc] init];
                                tempTweet.text = [obj valueForKey:@"text"];
                                tempTweet.tweetID = [obj valueForKey:@"id"];
                                
                                id userDetails = [obj valueForKey:@"user"];
                                tempTweet.user.userID = [userDetails valueForKey:@"id"];
                                tempTweet.user.name = [userDetails valueForKey:@"name"];
                                tempTweet.user.screenName = [userDetails valueForKey:@"screen_name"];
                                tempTweet.user.profileImageURL = [NSURL URLWithString:[userDetails valueForKey:@"profile_image_url"]];
                                
                            }];
                            
                        }
                        else {
                            NSLog(@"%@", error);
                            UIAlertView *alert = [self getAlertViewWithMessage:@"Error retrieving tweet"];
                            [alert show];
                        }
                    }
                    else {
                        NSLog(@"No response");
                        UIAlertView *alert = [self getAlertViewWithMessage: @"No response for the search Query"];
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

@end
