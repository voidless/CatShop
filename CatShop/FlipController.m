#import "FlipController.h"
#import "DBManager.h"

@interface FlipController ()

@property (strong) UIViewController <KittenListController> *currentController;

@property BOOL frontSide;

@property (strong) NSString *frontVC;
@property (strong) NSString *backVC;

@property (strong) DBManager *dbManager;
@property (strong) CurrentCat *currentCat;

@end


@implementation FlipController

@synthesize currentController;

@synthesize frontSide;
@synthesize frontVC;
@synthesize backVC;

@synthesize dbManager;
@synthesize currentCat;

#pragma mark Delegate


- (void)flipToVCWithId:(NSString *)newVCId
{
    frontSide = !frontSide;

    UIViewController <KittenListController> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];
    newVC.context = [dbManager managedObjectContext];
    newVC.currentCat = currentCat;

    [self addChildViewController:newVC];

    newVC.view.frame = self.view.bounds;
    [self transitionFromViewController:currentController
                      toViewController:newVC
            // TODO: =0 -> magic. >0 -> seam
                              duration:0
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^
                                       {
                                       }
                            completion:^(BOOL finished)
                                       {
                                           [currentController removeFromParentViewController];
                                           currentController = newVC;
                                           currentController.delegate = self;
                                       }];
}

- (void)kittenListControllerDidFinish:(UIViewController <KittenListController> *)controller
{
    if (frontSide) {
        [self flipToVCWithId:backVC];
    } else {
        [self flipToVCWithId:frontVC];
    }
}

- (void)presentVCWithId:(NSString *)newVCId
{
    UIViewController <KittenListController> *newVC = [self.storyboard instantiateViewControllerWithIdentifier:newVCId];
    currentController = newVC;

    currentController.context = [dbManager managedObjectContext];
    currentController.currentCat = currentCat;

    currentController.view.frame = self.view.bounds;

    [self addChildViewController:currentController];
    [self.view addSubview:currentController.view];
    currentController.delegate = self;
}

- (void)dismissVC
{
    [currentController.view removeFromSuperview];
    [currentController removeFromParentViewController];
    currentController = nil;
}

#pragma mark Lifetime

- (void)awakeFromNib
{
    [super awakeFromNib];

    frontVC = @"KittenScrollVC";
    backVC = @"KittenTableVC";

    frontSide = YES;

    dbManager = [DBManager new];
    currentCat = [[CurrentCat alloc] initWithContext:[dbManager managedObjectContext]];
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
