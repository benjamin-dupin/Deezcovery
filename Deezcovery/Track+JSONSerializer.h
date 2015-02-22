//
//  Track+JSONSerializer.h
//  Deezcovery
//

#import <Foundation/Foundation.h>
#import "Track.h"

@interface Track (JSONSerializer)
+ (Track *)trackFromJSON:(NSDictionary *)JSON;
@end
