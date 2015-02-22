//
//  Album+JSONSerliazer.h
//  Deezcovery
//

#import "Album.h"

@interface Album (JSONSerliazer)
+ (Album *)albumFromJSON:(NSDictionary *)JSON;
- (NSDictionary *)toJSON;
@end
