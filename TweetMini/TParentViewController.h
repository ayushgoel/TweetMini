//
//  TParentViewController.h
//  TweetMini
//
//  Created by Ayush on 9/21/12.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "TwitterAccessAPI.h"
#import "Tweet+Create.h"
#import "MiniUser+Create.h"


@interface TParentViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *twitterDatabase;
@property (nonatomic, strong) TwitterAccessAPI *TapiObject;

- (NSString *)getCellIdentifier;
- (NSFetchRequest *)getFetchRequest;
- (SLRequest *)getTwitterRequest;
- (NSNumber *)isForSelf;

- (void)setManagedDocument;

@end
