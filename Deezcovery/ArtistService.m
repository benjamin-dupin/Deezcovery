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
- (NSMutableArray *) getRelatedArtists:(NSString *)artistName{
    
    NSLog(@"Allooooo");
    
    // Vive Objective-C qui ne sait pas concaténer...
    NSString *searchArtistUrl = [NSString stringWithFormat:@"%@%@", @"/search/artist?q=", artistName];
    
    //NSLog(searchArtistUrl);
    
    NSLog(@"Get related...");
    
    NSMutableArray *artists = [@[] mutableCopy];
    
    NSString* json = [[SessionManager sharedInstance] getDataFrom:searchArtistUrl];
    
    /*
    [[SessionManager sharedInstance] LIST:searchArtistUrl completion:^(NSArray * JSON) {
        NSDictionary *datas = [JSON objectAtIndex:0];
        
        for (NSDictionary *object in datas){
            Artist *artist = [Artist artistFromJSON:object];
            [artists addObject:artist];
        }
        
    }];
     */
    
    return artists;
}

@end
