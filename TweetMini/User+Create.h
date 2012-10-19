//
//  User+Create.h
//  TweetMini
//
//  Created by Ayush on 10/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "User.h"
#import "MiniUser+Create.h"

@interface User (Create)

+ (User *)createUserWithInfo:(id)info inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)addImageData:(NSData *)data inContext:(NSManagedObjectContext *)context;

@end
