#import "KittenPhotoController.h"

@interface KittenPhotoController ()

@end


@implementation KittenPhotoController

@synthesize imageView;

@synthesize kittenImage;

@synthesize delegate;


#pragma mark - Action

- (IBAction)doReturn
{
    [delegate kittenPhotoClicked];
}

#pragma mark - Lifetime

- (void)viewDidLoad
{
    [super viewDidLoad];

    imageView.image = kittenImage;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


@end
