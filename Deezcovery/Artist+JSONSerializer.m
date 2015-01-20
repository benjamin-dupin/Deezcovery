//
//  Artist+JSONSerializer.m
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import "Artist+JSONSerializer.h"
#import "Artist.h"

@implementation Artist (JSONSerializer)

+ (Artist *)artistFromJSON:(NSDictionary *)JSON{
    if (!JSON)
        return nil;
    
    Artist *artist = [[Artist alloc] init];
    for (id key in JSON){
        NSLog(@"key: %@", key);
        if([artist respondsToSelector:NSSelectorFromString(key)]){
            NSLog(@"respond to selector!");
            [artist setValue:JSON[key] forKey:key];
        }
    }
    return artist;
}

@end
