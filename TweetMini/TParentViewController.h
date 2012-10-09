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

@property (nonatomic, strong) NSMutableArray *TTimeline;

- (UIAlertView *)getAlertViewWithMessage:(NSString *) msg;
- (UITableView *)getTableViewObject;
- (NSString *)getCellIdentifier;
- (void)getTimelineWithParam:(NSDictionary *)param usingRequest:(TWRequest *)request;
@end
