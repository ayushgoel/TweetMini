//
//  ConnectViewController.h
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TParentViewController.h"

@interface ConnectViewController : TParentViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *connectTable;
@end
