//
//  Track.m
//  Deezcovery
//
//  Created by B'n'J on 12/02/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import "Track.h"

@implementation Track
- (instancetype)init{
    self = [super init];
    if (self){
        self.title= nil;
        self.preview = nil;
    }
    
    return self;
}

@end
