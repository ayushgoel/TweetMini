//
//  SearchTwitterViewControllerViewController.h
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Twitter/Twitter.h"
#import "searchTweet.h"

@interface SearchTwitterViewControllerViewController : UITableViewController<UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UITableView *tweetTable;
@end

