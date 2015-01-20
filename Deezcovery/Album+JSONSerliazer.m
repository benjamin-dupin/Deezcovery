//
//  Todo+JSONSerliazer.m
//  TodoList
//
//  Created by Julien Sarazin on 18/01/15.
//  Copyright (c) 2015 Julien Sarazin. All rights reserved.
//

#import "Album+JSONSerliazer.h"

@implementation Album (JSONSerliazer)

+ (Album *)albumFromJSON:(NSDictionary *)JSON{
    if (!JSON)
        return nil;
    
    Album *album = [[Album alloc] init];
    for (id key in JSON){
        NSLog(@"key: %@", key);
        if([album respondsToSelector:NSSelectorFromString(key)]){
            NSLog(@"respond to selector!");
            [album setValue:JSON[key] forKey:key];
        }
    }
    return album;
}

- (NSDictionary *)toJSON{
    
    NSMutableDictionary *json = [@{} mutableCopy];
    if (self._id)
        [json setObject:self._id forKey:@"id"];
    if (self.title)
        [json setObject:self.title forKey:@"title"];
    if (self.link)
        [json setObject:self.link forKey:@"link"];
    if (self.cover)
        [json setObject:self.cover forKey:@"cover"];
    if (self.genre_id)
        [json setObject:self.genre_id forKey:@"genre_id"];
    if (self.record_type)
        [json setObject:self.record_type forKey:@"record_type"];
    if (self.tracklist)
        [json setObject:self.tracklist forKey:@"tracklist"];
    if (self.type)
        [json setObject:self.type forKey:@"type"];
    
    if (self.explicit_lyrics) {
        
        NSString *isExplicit;
        [json setObject:isExplicit forKey:@"type"];
        
        if ([isExplicit isEqualToString:@"true"])
            self.explicit_lyrics = YES;
        else
            self.explicit_lyrics = NO;
    }
        
    
    
    return json;
}
@end
