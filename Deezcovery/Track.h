//
//  Track.h
//  Deezcovery
//

#import <Foundation/Foundation.h>

@interface Track : NSObject
@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *preview;
@property (strong, nonatomic) NSData *previewData;
@end
