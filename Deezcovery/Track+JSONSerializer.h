//
//  Track+JSONSerializer.h
//  Deezcovery
//
//  Created by B'n'J on 12/02/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"

@interface Track (JSONSerializer)
+ (Track *)trackFromJSON:(NSDictionary *)JSON;
@end
