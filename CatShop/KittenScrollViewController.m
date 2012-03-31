#import "KittenScrollViewController.h"
#import "Kitten.h"
#import "KittenPhotoController.h"
#import "KittenDescriptionController.h"
#import "KittenTableViewController.h"

@interface KittenScrollViewController ()

@property (strong) NSArray *kittens;
@property (strong) NSMutableArray *viewControllers;

@property unsigned currentPage;

@end


@implementation KittenScrollViewController

@synthesize scrollViewOutlet;
@synthesize cacheNextViewsAmount;

@synthesize kittens;
@synthesize viewControllers;
@synthesize currentPage;

#pragma mark Load Unload

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= kittens.count)
    {
        return;
    }
    
    KittenPhotoController *kpc = [viewControllers objectAtIndex:page];
    if ((NSNull *)kpc == [NSNull null])
    {
//        NSLog(@"loaded kitten page: %d", page);
        
        Kitten *k = [kittens objectAtIndex:page];
        
        UIImage *image = [UIImage imageWithContentsOfFile:k.imagePath];
        
        kpc = [self.storyboard instantiateViewControllerWithIdentifier:@"fullscreenView"];
        [kpc setKitten:image];
        kpc.delegate = self;
        
        [viewControllers replaceObjectAtIndex:page withObject:kpc];
        
        [self addChildViewController:kpc];        
        [scrollViewOutlet addSubview:kpc.view];
        
        CGRect frame = scrollViewOutlet.frame;
        frame.origin.x = frame.size.width * page;
        kpc.view.frame = frame;
    }
}

- (void)unloadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= kittens.count)
    {
        return;
    }
    
    KittenPhotoController *kpc = [viewControllers objectAtIndex:page];
    if ((NSNull *)kpc != [NSNull null])
    {
//        NSLog(@"unloaded kitten page: %d", page);
        
        [kpc.view removeFromSuperview];
        [kpc removeFromParentViewController];
        [viewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


- (void)reloadScrollViews
{
    
    signed leftLimit = currentPage - cacheNextViewsAmount;
    signed rightLimit = currentPage + cacheNextViewsAmount;
    
    for (signed page = 0; page < kittens.count; page++)
    {
        if (page >= leftLimit && page <= rightLimit)
        {
            [self loadScrollViewWithPage:page];
        } else {
            [self unloadScrollViewWithPage:page];
        }
    }
}

#pragma mark Actions

- (void)switchToPage:(unsigned)page
{
    currentPage = page;
    [self reloadScrollViews];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page = (scrollView.contentOffset.x - pageWidth/2) / pageWidth + 1;
    if (currentPage != page)
    {
//        NSLog(@"switching page to: %d (%d)", page, cacheNextViewsAmount);
        [self switchToPage:page];
    }
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
            kdc.kitten = [kittens objectAtIndex:currentPage];
            
            UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:@"Вернуться" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalViewControllerAnimated:)];
            kdc.navigationItem.leftBarButtonItem = b;
        }
    }
    
//    TODO: refactor this
    KittenTableViewController *tvc = segue.destinationViewController;
    BOOL isTableCont = [tvc isKindOfClass:[KittenTableViewController class]];
    
    if (isTableCont && [segue.identifier isEqualToString:@"modalTableSegue"]) {
//        TODO: add dismiss delegate with position change
        tvc.delegate = self;
    }
}

#pragma mark Delegate

- (void)kittenPhotoClicked
{
    [self performSegueWithIdentifier:@"modalDescSegue" sender:self];
}

- (void)kittenTableReturnClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Lifetime

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    kittens = [Kitten kittens];
    
    viewControllers = [[NSMutableArray alloc] initWithCapacity:kittens.count];
    
    for (unsigned idx = 0; idx < kittens.count; idx++)
    {
        [viewControllers addObject:[NSNull null]];
    }
    
    cacheNextViewsAmount = 1;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollViewOutlet.contentSize = CGSizeMake(scrollViewOutlet.frame.size.width * kittens.count,
                                        scrollViewOutlet.frame.size.height);
    scrollViewOutlet.delegate = self;
    
    [self switchToPage:0];
}

@end
