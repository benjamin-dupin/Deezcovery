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
    
    // ==========================
    // Search artist by name
    // ==========================
    
    // Search artist URL
    NSString *searchArtistUrl = [NSString stringWithFormat:@"%@%@", @"/search/artist?q=", artistName];
    
    // Get JSON string from request
    NSString* jsonString = [[SessionManager sharedInstance] getDataFrom:searchArtistUrl];
    
    // Convert String to Dictionnary
    NSData *webData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    NSLog(@"JSON DIct: %@", jsonDict);
    
    // Artists Array
    NSMutableArray *artists = [@[] mutableCopy];
    
    NSDictionary *firstArtistFromSearch = [[jsonDict objectForKey:@"data"] objectAtIndex:0];
    Artist *firstArtist = [Artist artistFromJSON:firstArtistFromSearch];
    [artists addObject:firstArtist];
    
    // ==========================
    // Search related artists
    // ==========================
    
    // Related artists URL
    NSString *searchRelatedArtistsUrl = [NSString stringWithFormat:@"%@%@%@", @"/artist/", firstArtist._id, @"/related"];
    
    // Get JSON
    jsonString = [[SessionManager sharedInstance] getDataFrom:searchRelatedArtistsUrl];
    
    // Convert to dictionary
    webData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    NSLog(@"JSON DIct: %@", jsonDict);
    
    for (NSDictionary *object in [jsonDict objectForKey:@"data"]) {
        Artist *artist = [Artist artistFromJSON:object];
        [artists addObject:artist];
    }
    
    return artists;
}

@end
