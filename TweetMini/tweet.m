//
//  tweet.m
//  TweetMini
//
//  Created by Ayush on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tweet.h"

@implementation tweet

@synthesize tweetId, user, text, rowHeight;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_TITLE_HEIGHT 30.0f
#define CELL_IMAGE_WIDTH 60.0f

-(CGFloat) rowHeight
{    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - CELL_IMAGE_WIDTH, 20000.0f);
    CGSize size;

    size = [self.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = size.height;
    
    return height + (CELL_CONTENT_MARGIN) + CELL_TITLE_HEIGHT;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"User:%@ Text:%@", user, text];
}

- (id)init {
    self = [super init];
    if (self) {
            // Initialize self.
        self.user = [[miniUser alloc] init];
    }
    return self;
}

@end
