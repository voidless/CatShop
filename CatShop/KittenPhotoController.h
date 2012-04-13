#import <UIKit/UIKit.h>
#import "KittenPhotoControllerDelegate.h"

@interface KittenPhotoController : UIViewController

@property (strong) UIImage *kittenImage;

#pragma mark - IB

@property (weak) IBOutlet UIImageView *imageView;

- (IBAction)doReturn;

#pragma mark - Data

@property (weak) id <KittenPhotoControllerDelegate> delegate;

@end
