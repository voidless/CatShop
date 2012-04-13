#import "FlipController.h"

#import "KittenFlipperDelegateHolder.h"

@interface FlipController ()

@property (strong) UIViewController <KittenFlipperDelegateHolder> *presentingController;

@property BOOL frontSide;

@property (strong) NSString *frontVC;
@property (strong) NSString *backVC;

@end


@implementation FlipController

@synthesize presentingController;

@synthesize frontSide;
@synthesize frontVC;
@synthesize backVC;

#pragma mark Delegate


- (void)flipToVCWithId:(NSString *)newVCId
{
    frontSide = !frontSide;

    UIViewController <KittenFlipperDelegateHolder> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];

    [self addChildViewController:newVC];

    newVC.view.frame = self.view.bounds;
    [self transitionFromViewController:presentingController
                      toViewController:newVC
            // TODO: =0 -> magic. >0 -> seam
                              duration:0
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^
                                       {
                                       }
                            completion:^(BOOL finished)
                                       {
                                           [presentingController removeFromParentViewController];
                                           presentingController = newVC;
                                           presentingController.delegate = self;
                                       }];
}

- (void)kittenFlip
{
    if (frontSide) {
        [self flipToVCWithId:backVC];
    } else {
        [self flipToVCWithId:frontVC];
    }
}

- (void)presentVCWithId:(NSString *)newVCId
{
    UIViewController <KittenFlipperDelegateHolder> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];
    newVC.view.frame = self.view.bounds;

    presentingController = newVC;
    [self addChildViewController:presentingController];
    [self.view addSubview:presentingController.view];
    presentingController.delegate = self;
}

- (void)dismissVC
{
    [presentingController.view removeFromSuperview];
    [presentingController removeFromParentViewController];
    presentingController = nil;
}

#pragma mark Lifetime

- (void)awakeFromNib
{
    [super awakeFromNib];

    frontVC = @"KittenScrollVC";
    backVC = @"KittenTableVC";

    frontSide = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (frontVC) {
        [self presentVCWithId:frontVC];
    } else {
        [self presentVCWithId:backVC];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self dismissVC];
}


@end
