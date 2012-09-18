//
//  miniUser.h
//  TweetMini
//
//  Created by Ayush on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface miniUser : NSObject
@property (nonatomic) NSInteger userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *profileImageURL;

@end
