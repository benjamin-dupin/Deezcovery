//
//  Album.m
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import "Album.h"

@implementation Album
- (instancetype)init{
    self = [super init];
    if (self){
        self.title = @"title";
        self.link = @"link";
        self.cover = @"cover";
        self.genre_id = @"genre_id";
        self.record_type = @"record_type";
        self.tracklist = @"tracklist";
        self.explicit_lyrics = NO;
        self.type = @"type";
        self.artist = nil;
    }
    
    return self;
}
@end