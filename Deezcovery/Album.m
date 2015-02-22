//
//  Album.m
//  Deezcovery
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
        self._id = @"id";
    }
    
    return self;
}
@end