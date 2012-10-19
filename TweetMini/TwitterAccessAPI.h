//
//  TwitterAccessAPI.h
//  TweetMini
//
//  Created by Ayush on 19/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Twitter/Twitter.h"
#import "Accounts/Accounts.h"

@interface TwitterAccessAPI : NSObject

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccountType *accountType;

-(UIAlertView *) getAlertViewWithMessage: (NSString *) msg;
- (void)withTwitterCallSelector:(SEL)willCallSelector withObject:(id)obj;
@end
