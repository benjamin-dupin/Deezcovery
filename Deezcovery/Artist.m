//
//  Artist.m
//  Deezcovery
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
