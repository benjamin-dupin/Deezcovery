//
//  Artist.m
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import "Artist.h"

@implementation Artist
- (instancetype)init{
    self = [super init];
    if (self){
        self.name = nil;
        self.picture = nil;
        self._id = nil;
    }
    
    return self;
}

@end
