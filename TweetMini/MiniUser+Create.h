//
//  MiniUser+Create.h
//  TweetMini
//
//  Created by Ayush on 09/10/12.
//  Copyright (c) 2012 Ayush. All rights reserved.
//

#import "MiniUser.h"

@interface MiniUser (Create)

+ (MiniUser *)createUserWithInfo:(id)info inManagedObjectContext:(NSManagedObjectContext *)context;
+ (MiniUser *)createMiniUserWithInfo:(id)info inManagedObjectContext:(NSManagedObjectContext *)context;

@end
