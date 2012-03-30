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

- (id)initWithKittenImage:(UIImage*)img
{
    if ((self = [super init])) {
        kittenImage = img;
    }
    return self;
}

- (void)setKitten:(UIImage*)img
{
    kittenImage = img;
//    NSLog(@"setKitten: %@ %@", kittenImage, self);
}


- (void)viewWillAppear:(BOOL)animated
{
    modalImage.image = kittenImage;
//    NSLog(@"vWA: %@ %@", kittenImage, self);
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    NSLog(@"vWD: %@", self);
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    NSLog(@"vDA: %@", self);
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    NSLog(@"vDD: %@", self);
//}


#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


@end
