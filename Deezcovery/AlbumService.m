//
//  TodoManager.m
//  TodoList
//
//  Created by Julien Sarazin on 19/12/14.
//  Copyright (c) 2014 Julien Sarazin. All rights reserved.
//

#import "AlbumService.h"
#import "SessionManager.h"
#import "Album+JSONSerliazer.h"

@implementation AlbumService
static AlbumService *sharedInstance = nil;

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

- (void)createAlbum:(Album *)album completion:(void (^)(Album *))completion{
    [[SessionManager sharedInstance] POST:@"/album" data:@{@"album" : album.toJSON} completion:^(NSDictionary *JSON) {
        Album *createdAlbum = [Album albumFromJSON:JSON];
        if (completion) completion(createdAlbum);
    }];
}

- (void)updateAlbum:(Album *)album completion:(void (^)(Album *))completion{
    [[SessionManager sharedInstance] PUT:@"/todo" data:@{@"todo" : album.toJSON} completion:^(NSDictionary *JSON) {
        Album *updatedTodo = [Album albumFromJSON:JSON];
        if (completion) completion(updatedTodo);
    }];
}

- (void)deleteAlbum:(Album *)album completion:(void (^)(Album *))completion{
    NSString *url = [NSString stringWithFormat:@"/todo/%@", album._id];
    [[SessionManager sharedInstance] DELETE:url data:nil completion:^(NSDictionary *JSON) {
        Album *deletedTodo = [Album albumFromJSON:JSON];
        if (completion) completion(deletedTodo);
    }];
}

- (void)getAlbumsWithcompletion:(void (^)(NSArray *))completion{
    [[SessionManager sharedInstance] LIST:@"artist/27/albums" completion:^(NSArray * JSON) {
        NSMutableArray *albums = [@[] mutableCopy];
        for (NSDictionary *object in JSON){
            Album *album = [Album albumFromJSON:object];
            [albums addObject:album];
        }
        
        if (completion) completion(albums);
    }];
}

@end
