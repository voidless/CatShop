#import "KittenPhotoController.h"

@interface KittenPhotoController ()

@end


@implementation KittenPhotoController

@synthesize modalImageView;

@synthesize kittenImage;
@synthesize kittenIndex;

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
    
    modalImageView.image = kittenImage;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


@end
