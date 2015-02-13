//
//  Track+JSONSerializer.m
//  Deezcovery
//
//  Created by B'n'J on 12/02/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import "Artist+JSONSerializer.h"
#import "Track.h"

@implementation Track (JSONSerializer)

+ (Track *)trackFromJSON:(NSDictionary *)JSON{
    if (!JSON)
        return nil;
    
    Track *track = [[Track alloc] init];
    
    // Pour chaque clef du NSDico
    for (id key in JSON){
        
        // Si la clef correspond à un attribut du model
        if([track respondsToSelector:NSSelectorFromString(key)]){
            
            // Attribut = valeur de la clef
            [track setValue:JSON[key] forKey:key];
        }
    }
    
    return track;
}

@end