//
//  TParentViewController.m
//  TweetMini
//
//  Created by Ayush on 9/21/12.
//
//

#import "TParentViewController.h"

@interface TParentViewController ()
@end

@implementation TParentViewController
@synthesize twitterDatabase = _twitterDatabase;
@synthesize TapiObject = _TapiObject;

- (TwitterAccessAPI *)TapiObject {
    if (!_TapiObject) {
        _TapiObject = [[TwitterAccessAPI alloc] init];
    }
    return _TapiObject;
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //Need something better to exit application
    exit(1);
}

#pragma Implemented by child classes

-(NSString *) getCellIdentifier {
    NSLog(@"Not implemented getCellIdentifier!");
    return [[NSString alloc] init];
}

- (NSFetchRequest *)getFetchRequest {
    NSLog(@"Not implemented getFetchRequest!");
    return [[NSFetchRequest alloc] init];
}

- (SLRequest *)getTwitterRequest {
    NSLog(@"Twitter request not implemented!");
    return [[SLRequest alloc] init];
}

- (NSNumber *)isForSelf {
    NSLog(@"isForSelf not implemented");
    return [NSNumber numberWithBool:NO];
}

#pragma Document functions

//- (void)documentSet:(UIRefreshControl *)control {
- (void)documentSet{
    [self.TapiObject withTwitterCallSelector:@selector(getTimeline) withObject:self];
    [self.refreshControl endRefreshing];
}

- (void)setupFetchedResultsController {
    NSLog(@"Setting up fetch results controller");
    NSFetchRequest *request = [self getFetchRequest];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.twitterDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    NSLog(@"FRC set up");
}

- (void)useDocument {
    NSLog(@"useDoc");
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.twitterDatabase.fileURL path]]) {
        [self.twitterDatabase saveToURL:self.twitterDatabase.fileURL
                       forSaveOperation:UIDocumentSaveForCreating
                      completionHandler:^(BOOL success) {
            NSLog(@"Document Created");
            [self setupFetchedResultsController];
            [self documentSet];
        }];
    } else if (self.twitterDatabase.documentState == UIDocumentStateClosed) {
        [self.twitterDatabase openWithCompletionHandler:^(BOOL success) {
            NSLog(@"Open");
            [self setupFetchedResultsController];
            [self documentSet];
        }];
    } else if (self.twitterDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setTwitterDatabase:(UIManagedDocument *)twitterDatabase {
    NSLog(@"Setter called database");
    if (_twitterDatabase != twitterDatabase) {
        _twitterDatabase = twitterDatabase;
        [self performSelectorOnMainThread:@selector(useDocument) withObject:self waitUntilDone:YES];
    }
}

- (void)setManagedDocument {
    if (!self.twitterDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"TwitterDatabase"];
        NSLog(@"Setting managed document");
        self.twitterDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    [control addTarget:self action:@selector(documentSet) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = control;
}

#pragma TVC methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellIdentifier = [self getCellIdentifier];
    UITableViewCell * cell = nil;
    
    Tweet *resTweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
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
            NSLog(@"Getting image data %@", resTweet.user.screenName);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:resTweet.user.profileImageURL]];
            UIImage *image = [UIImage imageWithData:data];
            data = UIImageJPEGRepresentation(image, 1);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Putting image data %@", resTweet.user.screenName);
                cell.imageView.image = [UIImage imageWithData:data];
                [resTweet.user addImageData:data forUserID:resTweet.user.userID
                                  inContext:resTweet.user.managedObjectContext];
            }];
        }];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.fetchedResultsController objectAtIndexPath:indexPath] getRowHeight];
}

#pragma Network Data Methods

- (void)getTimeline {
    SLRequest *request = [self getTwitterRequest];
    [request setAccount:[[self.TapiObject.accountStore accountsWithAccountType:self.TapiObject.accountType] lastObject]];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(responseData) {
            NSError *jsonError;
            NSArray *results = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:&jsonError];
            if(results) {
//              NSLog(@"Got results: %@", results);
                NSLog(@"Got Results");
                [self.twitterDatabase.managedObjectContext performBlock:^{
                    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [Tweet createTweetWithInfo:obj
                                         isForSelf:[self isForSelf]
                            inManagedObjectContext:self.twitterDatabase.managedObjectContext];
                    }];
                }];
            }
            else {
                NSLog(@"%@", error);
                UIAlertView *alert = [self.TapiObject getAlertViewWithMessage:@"Error retrieving tweet" andDelegate:self];
                [alert show];
            }
        }
        else {
            NSLog(@"No response");
            UIAlertView *alert = [self.TapiObject getAlertViewWithMessage: @"No response from Server!" andDelegate:self];
            [alert show];
        }
    }];
}

@end
