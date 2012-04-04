#import "KittenPhotoController.h"

@interface KittenPhotoController ()

@property (strong) UIImage *kittenImage;

@end


@implementation KittenPhotoController

@synthesize modalImage;

@synthesize kittenImage;

@synthesize delegate;


#pragma mark - Action

- (IBAction)doReturn
{
    [delegate kittenPhotoClicked];
}

#pragma mark - Lifetime

- (void)setKitten:(UIImage*)img
{
    kittenImage = img;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    modalImage.image = kittenImage;
    
    NSLog(@"vWA: %@", self);
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


@end
