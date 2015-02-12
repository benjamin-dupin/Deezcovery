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
    
    // Pour chaque clef du NSDico
    for (id key in JSON){
        
        // Si la clef correspond à un attribut du model
        if([artist respondsToSelector:NSSelectorFromString(key)]){
            
            // Attribut = valeur de la clef
            [artist setValue:JSON[key] forKey:key];
        }
        
        // Sinon, si la clef vaut id
        else if ([key isEqualToString:@"id"]) {
            
            // Attribut _id = valeur de la clef id
            artist._id = JSON[key];
        }
    }
    
    return artist;
}

@end
