#import <UIKit/UIKit.h>
#import "KittenPhotoClickDelegate.h"

@interface KittenPhotoController : UIViewController

- (void)setKitten:(UIImage*)img;

#pragma mark - Outlet

@property (weak) IBOutlet UIImageView *modalImage;

#pragma mark - Data

@property (weak) id<KittenPhotoClickDelegate> delegate;

@end
