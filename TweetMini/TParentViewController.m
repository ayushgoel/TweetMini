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

-(UITableView *) getTableViewObject
{
    return [[UITableView alloc] init];
}

- (void)setupFetchedResultsController
{
    //    NSLog(@"Setting up FRC");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
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
            [self fetchFlickrDataIntoDocument:self.twitterDatabase];
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

-(NSString *) getCellIdentifier
{
    return [[NSString alloc] init];
}

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.TTimeline count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.TTimeline objectAtIndex:[indexPath row]] rowHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = [self getCellIdentifier];
    UITableViewCell * cell = nil;
    
    Tweet *resTweet = [self.TTimeline objectAtIndex:[indexPath row]];
    cell = [self.getTableViewObject dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = resTweet.user.name;
    cell.detailTextLabel.text = resTweet.text;

    [cell.imageView setImageWithURL:[NSURL URLWithString:resTweet.user.profileImageURL] placeholderImage:[UIImage imageNamed:@"profile.gif"]];
    return cell;
}

-(void) getTimelineWithParam: (NSDictionary *) param usingRequest: (TWRequest *) request
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
                                
                                [self.TTimeline addObject:tempTweet];
                                
                            }];
                            
                            [[self getTableViewObject] reloadData];
                            [[self getTableViewObject] setNeedsDisplay];
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
