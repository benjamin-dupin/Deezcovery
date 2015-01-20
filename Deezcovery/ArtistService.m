//
//  ArtistService.m
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import "ArtistService.h"
#import "SessionManager.h"
#import "Artist+JSONSerializer.h"

@implementation ArtistService

static ArtistService *sharedInstance = nil;

#pragma mark - Singleton Pattern -
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (sharedInstance == nil)
            sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}
+ (id)allocWithZone:(NSZone *)zone{
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone{
    return self;
}
- (id)init{
    if(nil != (self = [super init]))
    {}
    return self;
}


/**
    Search related artist from artist name
 */
- (void) getRelatedArtists:(NSString *)artistName completion:(void (^)(NSArray *))completion{
    
    // Vive Objective-C qui ne sait pas concaténer...
    NSString * searchArtistUrl = [NSString stringWithFormat:@"%@/%@/%@", @"/search/artist?q='", artistName, @"'"];
    
    [[SessionManager sharedInstance] LIST:searchArtistUrl completion:^(NSArray * JSON) {
        NSMutableArray *artists = [@[] mutableCopy];
        NSDictionary *datas = [JSON objectAtIndex:0];
        
        for (NSDictionary *object in datas){
            Artist *artist = [Artist artistFromJSON:object];
            [artists addObject:artist];
        }
        
        if (completion) completion(artists);
        
    }];
}

@end
