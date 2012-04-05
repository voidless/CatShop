#import "KittenScrollViewController.h"
#import "Kitten.h"
#import "KittenPhotoController.h"
#import "KittenDescriptionController.h"
#import "KittenTableViewController.h"

@interface KittenScrollViewController ()

// TODO: remove this, use sorted
@property (strong) NSArray *kittens;

@property (strong) NSMutableArray *viewControllers;

@property NSInteger currentPage;

@end


@implementation KittenScrollViewController

@synthesize scrollView;
@synthesize cacheNextViewsAmount;
@synthesize delegate;

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
        Kitten *k = [kittens objectAtIndex:page];
        
        UIImage *image = [UIImage imageWithContentsOfFile:k.imagePath];
        
        kpc = [self.storyboard instantiateViewControllerWithIdentifier:@"fullscreenView"];
        [kpc setKitten:image];
        kpc.delegate = self;
        
        [viewControllers replaceObjectAtIndex:page withObject:kpc];
        
        [self addChildViewController:kpc];
        [scrollView addSubview:kpc.view];
        
        CGRect frame = scrollView.frame;
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
        [kpc.view removeFromSuperview];
        [kpc removeFromParentViewController];
        [viewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)reloadScrollViews
{
    NSAssert(cacheNextViewsAmount >= 0, @"cacheNextViewsAmount must be positive. had %d", cacheNextViewsAmount);
    
    NSInteger leftLimit = currentPage - cacheNextViewsAmount;
    NSInteger rightLimit = currentPage + cacheNextViewsAmount;
    
    for (NSInteger page = 0; page < kittens.count; page++)
    {
        if (page >= leftLimit && page <= rightLimit)
        {
            [self loadScrollViewWithPage:page];
        } else {
            [self unloadScrollViewWithPage:page];
        }
    }
}

- (void)loadPage:(NSInteger)page
{
    currentPage = page;
    [self reloadScrollViews];
}

#pragma mark Actions


- (void)scrollToPage:(NSInteger)page
{
    NSLog(@"scrolled to: %d", page);
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat pageWidth = scrollView.frame.size.width;
    
    contentOffset.x = pageWidth * page;
    
    [scrollView setContentOffset:contentOffset animated:NO];
}

#pragma mark - Events

- (void)scrollViewDidScroll:(UIScrollView *)source
{
    CGFloat pageWidth = source.frame.size.width;
    int page = (source.contentOffset.x - pageWidth/2) / pageWidth + 1;
    if (currentPage != page)
    {
        [self loadPage:page];
        [delegate kittenSetCurrent:page];
    }
}

#pragma mark Delegate

- (void)kittenPhotoClicked
{
    [self performSegueWithIdentifier:@"DescSegue" sender:self];
}

- (IBAction)kittenInfoClicked
{
    [delegate kittenFlip];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KittenDescriptionController *kdc = segue.destinationViewController;
    BOOL isDescrCont = [kdc isKindOfClass:[KittenDescriptionController class]];
    
    if (isDescrCont && [segue.identifier isEqualToString:@"DescSegue"])
    {   
        kdc.kitten = [kittens objectAtIndex:currentPage];
    }
}

- (void)selectKittenAtIndex:(NSInteger)index;
{
    if (self.isViewLoaded && self.view.window)
    {
        NSLog(@"selected while visible: %d", index);
        [self loadPage:index];
        [self scrollToPage:index];
    } else {
        NSLog(@"selected while invisible: %d", index);
        currentPage = index;
    }
}

#pragma mark - Lifetime

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    kittens = [Kitten kittens];
    
    viewControllers = [[NSMutableArray alloc] initWithCapacity:kittens.count];
    
    for (NSInteger idx = 0; idx < kittens.count; idx++)
    {
        [viewControllers addObject:[NSNull null]];
    }
    
    cacheNextViewsAmount = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kittens.count,
                                        scrollView.frame.size.height);
    
    NSLog(@"vWA scrollView %d", currentPage);
    [self reloadScrollViews];
    [self scrollToPage:currentPage];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"vDA scrollView %d", currentPage);
}

@end
