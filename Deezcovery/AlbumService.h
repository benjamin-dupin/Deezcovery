//
//  TodoManager.h
//  TodoList
//
//  Created by Julien Sarazin on 19/12/14.
//  Copyright (c) 2014 Julien Sarazin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"

@interface AlbumService : NSObject
#pragma mark - Singleton Pattern -
+ (instancetype)sharedInstance;

- (void)getAlbumsWithcompletion:(void (^)(NSArray *))completion;

@end
