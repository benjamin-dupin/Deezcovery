//
//  AlbumListViewController.h
//  Deezcovery
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@interface AlbumListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) Artist *artist;
@property (assign) BOOL controlFav;

@end
