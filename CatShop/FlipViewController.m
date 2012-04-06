#import "FlipViewController.h"

#import "KittenFlipperDelegateHolder.h"

@interface FlipViewController ()

@property (strong) UIViewController<KittenFlipperDelegateHolder> *presentingController;

@property BOOL frontSide;

@property (strong) NSString* frontVC;
@property (strong) NSString* backVC;

@property NSInteger currentIndex;

@end


@implementation FlipViewController

@synthesize presentingController;

@synthesize frontSide;
@synthesize frontVC;
@synthesize backVC;

@synthesize currentIndex;
#define CURRENT_INDEX_KEY @"currentIndex"

#pragma mark Delegate


- (void)flipToVCWithId:(NSString*)newVCId andIndex:(NSInteger)index
{
    frontSide = !frontSide;
    
    UIViewController<KittenFlipperDelegateHolder> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];
    [newVC selectKittenAtIndex:index];

    [self addChildViewController:newVC];
    
    newVC.view.frame = self.view.bounds;
    [self transitionFromViewController:presentingController
                      toViewController:newVC
     // TODO: =0 -> magic. >0 -> seam
                              duration:0
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
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
    if (frontSide)
    {
        [self flipToVCWithId:backVC andIndex:currentIndex];
    } else {
        [self flipToVCWithId:frontVC andIndex:currentIndex];
    }
}

- (void)kittenSetCurrent:(NSInteger)index
{
    currentIndex = index;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:currentIndex forKey:CURRENT_INDEX_KEY];
    [ud synchronize];
}

- (void)presentVCWithId:(NSString*)newVCId
{
    UIViewController<KittenFlipperDelegateHolder> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];
    newVC.view.frame = self.view.bounds;
    
    presentingController = newVC;
    [self addChildViewController:presentingController];
    [self.view addSubview:presentingController.view];
    presentingController.delegate = self;
    [presentingController selectKittenAtIndex:currentIndex];
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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    currentIndex = [ud integerForKey:CURRENT_INDEX_KEY];
    
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
