//
//  Artist+JSONSerializer.h
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artist.h"

@interface Artist (JSONSerializer)
+ (Artist *)artistFromJSON:(NSDictionary *)JSON;
@end
