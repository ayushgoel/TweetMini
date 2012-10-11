//
//  SearchTwitterViewControllerViewController.h
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TParentViewController.h"

@interface SearchTwitterViewControllerViewController : TParentViewController<UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UITableView *tweetTable;
@end

@interface tweet : NSObject

@property (nonatomic, strong) NSString *tweetID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSURL *userProfileImageURL;
@property (nonatomic) CGFloat rowHeight;

@end
