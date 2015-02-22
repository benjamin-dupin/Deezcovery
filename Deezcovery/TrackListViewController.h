//
//  TrackListViewController.h
//  Deezcovery
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "Album.h"

@interface TrackListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Album *album;
@property (strong, nonatomic) AVPlayer *player;

@end
