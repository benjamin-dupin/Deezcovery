//
//  Artist+JSONSerializer.h
//  Deezcovery
//

#import <Foundation/Foundation.h>
#import "Artist.h"

@interface Artist (JSONSerializer)
+ (Artist *)artistFromJSON:(NSDictionary *)JSON;
@end
