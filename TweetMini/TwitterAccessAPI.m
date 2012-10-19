//
//  TwitterAccessAPI.m
//  TweetMini
//
//  Created by Ayush on 19/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "TwitterAccessAPI.h"

@implementation TwitterAccessAPI

- (void)withTwitterCallSelector:(SEL)willCallSelector
{
    [self performSelector:willCallSelector];
}

@end
