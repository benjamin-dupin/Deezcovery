//
//  Track.m
//  Deezcovery
//

#import "Track.h"

@implementation Track
- (instancetype)init{
    self = [super init];
    if (self){
        self.title= nil;
        self.preview = nil;
        self._id = nil;
        self.previewData = nil;
    }
    
    return self;
}

@end
