//
//  TParentViewController.h
//  TweetMini
//
//  Created by Ayush on 9/21/12.
//
//

#import <UIKit/UIKit.h>
#import "Twitter/Twitter.h"

#import "CoreDataTableViewController.h"

@interface TParentViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *twitterDatabase;

- (NSString *)getCellIdentifier;
- (NSFetchRequest *)getFetchRequest;

- (void)setManagedDocument;

- (void)requestForTimelineusing:(UIManagedDocument *)document;
- (void)getTimelineWithParam:(NSDictionary *)param usingRequest:(TWRequest *)request inDocument:(UIManagedDocument *)document isForSelf:(NSNumber *)isForSelf;
@end
