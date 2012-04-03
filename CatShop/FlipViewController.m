#import "FlipViewController.h"

#import "KittenFlipperDelegateHolder.h"

@interface FlipViewController () {
}

@property (strong) UIViewController<KittenFlipperDelegateHolder> *presentingController;

@property BOOL frontSide;

@property (strong) NSString* frontVC;
@property (strong) NSString* backVC;

@end


@implementation FlipViewController

@synthesize presentingController;

@synthesize frontSide;
@synthesize frontVC;
@synthesize backVC;

#pragma mark Delegate

- (void)kittenFlipWithIndex:(NSInteger)index
{
    if (frontSide)
    {
        [self flipToVCWithId:backVC];
        
        NSLog(@"kittenFlip to back: %d", index);
    } else {
        [self flipToVCWithId:frontVC];
        
        NSLog(@"kittenFlip to front: %d", index);
    }
    
    [presentingController selectKittenAtIndex:index];

    frontSide = !frontSide;
}

- (void)flipToVCWithId:(NSString*)newVCId
{
    UIViewController<KittenFlipperDelegateHolder> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];
    [self addChildViewController:newVC];
    
    [self transitionFromViewController:presentingController
                      toViewController:newVC
                              duration:2.
                               options:UIViewAnimationTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL finished)
    {   
        NSLog(@"finished: %d", finished);
        [presentingController removeFromParentViewController];
        presentingController = newVC;
        presentingController.delegate = self;
    }];
    
}

- (void)presentVCWithId:(NSString*)newVCId
{
    UIViewController<KittenFlipperDelegateHolder> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];
    [self addChildViewController:newVC];
    
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
    if (frontVC) {
        [self presentVCWithId:frontVC];
    } else {
        [self presentVCWithId:backVC];
    }
}

- (void)viewDidUnload
{
    [self dismissVC];
}


@end
