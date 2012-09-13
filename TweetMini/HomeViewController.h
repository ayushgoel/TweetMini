//
//  HomeViewController.h
//  TweetMini
//
//  Created by Ayush on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accounts/Accounts.h"

@interface HomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) ACAccount *tAccount;
@end
