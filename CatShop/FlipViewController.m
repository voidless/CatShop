#import "FlipViewController.h"

#import "KittenFlipperDelegateHolder.h"

@interface FlipViewController ()

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


- (void)flipToVCWithId:(NSString*)newVCId andIndex:(NSInteger)index
{
    frontSide = !frontSide;
    
    UIViewController<KittenFlipperDelegateHolder> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];
    [self addChildViewController:newVC];
    
    [self transitionFromViewController:presentingController
                      toViewController:newVC
                              duration:.3
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                [newVC selectKittenAtIndex:index];
                            }
                            completion:^(BOOL finished)
    {   
//        NSLog(@"finished: %d", finished);
        [presentingController removeFromParentViewController];
        presentingController = newVC;
        presentingController.delegate = self;
        
//        NSLog(@"flipvc self: %@", self.view);
//        NSLog(@"flipvc sub: %@", presentingController.view);
//        presentingController.view.frame = self.view.frame;
    }];
}

- (void)kittenFlipWithIndex:(NSInteger)index
{
    if (frontSide)
    {
        [self flipToVCWithId:backVC andIndex:index];
        
//        NSLog(@"kittenFlip to back: %d", index);
    } else {
        [self flipToVCWithId:frontVC andIndex:index];
        
//        NSLog(@"kittenFlip to front: %d", index);
    }
}

- (void)presentVCWithId:(NSString*)newVCId
{
    UIViewController<KittenFlipperDelegateHolder> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];
    [self addChildViewController:newVC];
    
    presentingController = newVC;
    [self addChildViewController:presentingController];
    [self.view addSubview:presentingController.view];
    presentingController.delegate = self;
    
//    NSLog(@"flipvc self: %@", self.view);
//    NSLog(@"flipvc sub: %@", presentingController.view);
//    presentingController.view.frame = self.view.frame;
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
