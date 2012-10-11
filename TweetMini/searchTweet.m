//
//  searchTweet.m
//  TweetMini
//
//  Created by Ayush on 11/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "searchTweet.h"

@implementation searchTweet

@synthesize tweetID = _tweetID, text = _text, userName = _userName, userProfileImageURL = _userProfileImageURL;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_TITLE_HEIGHT 30.0f
#define CELL_IMAGE_WIDTH 60.0f

- (CGFloat)rowHeight
{
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - CELL_IMAGE_WIDTH, 20000.0f);
    CGSize size;
    
    size = [self.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height;
    
    return height + (CELL_CONTENT_MARGIN) + CELL_TITLE_HEIGHT;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"Text:%@", self.text];
}
@end
