#import "ViewController.h"
#import "Kitten.h"
#import "KittenPhotoController.h"
#import "KittenDescriptionController.h"

@interface ViewController ()

- (void)showKittenAtIndex:(int)idx;

@property (strong) NSArray *kittens;

@property int kittenIndex;

@property BOOL isShowingLandscapeView;

@property (strong) KittenPhotoController *kittenSubController;

@end


#pragma mark - Implementation

@implementation ViewController

@synthesize kittens;

@synthesize kittenIndex;

@synthesize isShowingLandscapeView;

@synthesize kittenSubController;


@synthesize next;
@synthesize prev;

@synthesize imageContainerView;

#pragma mark - Kitten Business

- (void)showKittenAtIndex:(int)idx
{
    Kitten *k = [kittens objectAtIndex:idx];
    
    UIImage *image = [UIImage imageWithContentsOfFile:k.imagePath];
    
    NSArray *sba = [imageContainerView subviews];
    for (UIView *v in sba)
    {
        [v removeFromSuperview];
    }
    
    kittenSubController = [self.storyboard instantiateViewControllerWithIdentifier:@"fullscreenView"];
    [kittenSubController setKitten:image];
    
    [self addChildViewController:kittenSubController];
    
    [imageContainerView addSubview:kittenSubController.view];
    kittenSubController.view.frame = imageContainerView.frame;
}


- (void)showNextKitten:(BOOL)forward
{
    int nextIndex = kittenIndex + (forward ? 1 : -1);
    if (nextIndex < 0 || kittens.count <= nextIndex) {
        return;
    }
    
    kittenIndex = nextIndex;
    [self showKittenAtIndex:kittenIndex];
    prev.hidden = kittenIndex <= 0;
    next.hidden = kittenIndex >= (kittens.count - 1);
}

#pragma mark - Actions

- (IBAction)nextKitten
{
    [self showNextKitten:YES];
}

- (IBAction)prevKitten
{
    [self showNextKitten:NO];
}

- (void)dismissModalKittenPhotoController
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UINavigationController *nc = segue.destinationViewController;
    
    BOOL isNavCont = [nc isKindOfClass:[UINavigationController class]];
    
    if (isNavCont && [segue.identifier isEqualToString:@"modalDescSegue"])
    {
        KittenDescriptionController *kdc = [nc.viewControllers objectAtIndex:0];
        if ([kdc isKindOfClass:[KittenDescriptionController class]])
        {
            kdc.kitten = [kittens objectAtIndex:kittenIndex];
            
            UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:@"Вернуться" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalKittenPhotoController)];
            kdc.navigationItem.leftBarButtonItem = b;
        }
    }
}

#pragma mark - Swipe handling

- (void)attachSwipeRecognizerWithDirection:(UISwipeGestureRecognizerDirection)direction
{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = direction;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        switch (sender.direction) {
            case UISwipeGestureRecognizerDirectionLeft:
                [self prevKitten];
                break;
            case UISwipeGestureRecognizerDirectionRight:
                [self nextKitten];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self attachSwipeRecognizerWithDirection:UISwipeGestureRecognizerDirectionLeft];
    [self attachSwipeRecognizerWithDirection:UISwipeGestureRecognizerDirectionRight];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    kittens = [Kitten kittensOnSale];
    
    [self showKittenAtIndex:kittenIndex];
    
    prev.hidden = YES;
    if (kittens.count <= 1) {
        next.hidden = YES;
    }
}


@end
