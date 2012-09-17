//
//  tweet.m
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tweet.h"

@implementation tweet

@synthesize tweetId, user, userId, text, profileImageURL, rowHeight;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_TITLE_HEIGHT 30.0f

-(CGFloat) rowHeight
{    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size;

    
//    if ([self.text isKindOfClass:[NSNull class]]) {
        size = [self.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    }
//    else {
//        NSLog(@"WTF!");
//        size = [@"S" sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    }
    NSLog(@"text: %f", size.height);    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2) + CELL_TITLE_HEIGHT;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"%@ %@ %@", user, text, profileImageURL];
}

@end
