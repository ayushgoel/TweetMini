//
//  TwitterAccessAPI.h
//  TweetMini
//
//  Created by Ayush on 19/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Twitter/Twitter.h"

@interface TwitterAccessAPI : NSObject
- (void)withTwitterCallSelector:(SEL)willCallSelector;
@end
