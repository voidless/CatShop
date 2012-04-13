#import <UIKit/UIKit.h>
#import "KittenPhotoClickDelegate.h"

@interface KittenPhotoController : UIViewController

@property (strong) UIImage *kittenImage;

#pragma mark - IB

@property (weak) IBOutlet UIImageView *modalImageView;

- (IBAction)doReturn;

#pragma mark - Data

@property (weak) id <KittenPhotoClickDelegate> delegate;
@property (assign) NSUInteger kittenIndex;

@end
