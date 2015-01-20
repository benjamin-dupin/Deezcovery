//
//  Album+JSONSerliazer.h
//  Deezcovery
//
//  Created by B'n'J on 20/01/2015.
//  Copyright (c) 2015 B'n'J. All rights reserved.
//

#import "Album.h"

@interface Album (JSONSerliazer)
+ (Album *)albumFromJSON:(NSDictionary *)JSON;
- (NSDictionary *)toJSON;
@end
