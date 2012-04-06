#import <UIKit/UIKit.h>
#import "KittenPhotoClickDelegate.h"

@interface KittenPhotoController : UIViewController

- (void)setKitten:(UIImage*)img;

#pragma mark - IB

@property (weak) IBOutlet UIImageView *modalImageView;

- (IBAction)doReturn;

#pragma mark - Data

@property (weak) id<KittenPhotoClickDelegate> delegate;

@end
