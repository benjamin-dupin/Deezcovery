//
//  Album.h
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject
@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *cover;
@property (strong, nonatomic) NSString *genre_id;
@property (strong, nonatomic) NSString *record_type;
@property (strong, nonatomic) NSString *tracklist;
@property (assign, nonatomic) BOOL explicit_lyrics;
@property (assign, nonatomic) NSString *type;
@end
