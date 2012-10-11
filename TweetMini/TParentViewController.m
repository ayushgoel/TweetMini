//
//  TParentViewController.m
//  TweetMini
//
//  Created by Ayush on 9/21/12.
//
//

#import "TParentViewController.h"
#import "Twitter/Twitter.h"
#import "Accounts/Accounts.h"
#import "Tweet+Create.h"
#import "MiniUser+Create.h"

@interface TParentViewController ()
@end

@implementation TParentViewController
@synthesize twitterDatabase = _twitterDatabase;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg{
    return [[UIAlertView alloc] initWithTitle:@"Twitter Authorisation" message:msg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles: nil];
}

#pragma Implemented by child classes

-(NSString *) getCellIdentifier
{
    NSLog(@"Not implemented getCellIdentifier!");
    return [[NSString alloc] init];
}

- (void)requestForTimelineusing:(UIManagedDocument *)document
{
    NSLog(@"Wrong Request for timeline called!");
}

- (NSFetchRequest *)getFetchRequest
{
    NSLog(@"Not implemented getFetchRequest!");
    return [[NSFetchRequest alloc] init];
}

#pragma Document functions

- (void)setupFetchedResultsController
{
    NSLog(@"Setting up fetch results controller");
    NSFetchRequest *request = [self getFetchRequest];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.twitterDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    NSLog(@"FRC set up");
}

- (void)useDocument
{
    NSLog(@"useDoc");
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.twitterDatabase.fileURL path]]) {
        [self.twitterDatabase saveToURL:self.twitterDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            NSLog(@"Document Created");
            [self setupFetchedResultsController];
            [self requestForTimelineusing:self.twitterDatabase];
        }];
    } else if (self.twitterDatabase.documentState == UIDocumentStateClosed) {
        [self.twitterDatabase openWithCompletionHandler:^(BOOL success) {
            NSLog(@"Open");
            [self setupFetchedResultsController];
            [self requestForTimelineusing:self.twitterDatabase];
        }];
    } else if (self.twitterDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
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
    cell.imageView.image = [UIImage imageNamed:@"profile.gif"];
    
    if (resTweet.user.smallImage) {
        cell.imageView.image = [UIImage imageWithData:resTweet.user.smallImage];
    } else {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:resTweet.user.profileImageURL]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                cell.imageView.image = [UIImage imageWithData:data];
            }];
            [resTweet.user addImageData:data forUserID:resTweet.user.userID inContext:resTweet.user.managedObjectContext];
        }];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.fetchedResultsController objectAtIndexPath:indexPath] getRowHeight];
}

#pragma Network Data Methods

- (void)getTimelineWithParam:(NSDictionary *)param usingRequest:(TWRequest *)request inDocument:(UIManagedDocument *)document isForSelf:(NSNumber *)isForSelf
{
    NSLog(@"Getting timeline for %@", isForSelf);
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
//                            NSLog(@"Got results: %@", results);
                            NSLog(@"Got Results");
                            [document.managedObjectContext performBlock:^{
                                [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    [Tweet createTweetWithInfo:obj isForSelf:isForSelf inManagedObjectContext:document.managedObjectContext];
                                }];
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
