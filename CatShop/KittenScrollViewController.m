#import "KittenScrollViewController.h"
#import "Kitten.h"
#import "KittenPhotoController.h"
#import "KittenDescriptionController.h"
#import "KittenTableViewController.h"

@interface KittenScrollViewController ()

@property (strong) NSMutableArray *viewControllers;

@property NSInteger currentPage;

@end


@implementation KittenScrollViewController

@synthesize scrollView;
@synthesize cacheNextViewsAmount;
@synthesize delegate;

@synthesize viewControllers;
@synthesize currentPage;

#pragma mark Load Unload

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= [Kitten count])
    {
        return;
    }
    
    KittenPhotoController *kpc = [viewControllers objectAtIndex:page];
    if ((NSNull *)kpc == [NSNull null])
    {
        Kitten *k = [Kitten kittenSortedAtIndex:page];
        
        UIImage *image = k.image;
        
        kpc = [self.storyboard instantiateViewControllerWithIdentifier:@"fullscreenView"];
        kpc.kittenImage = image;
        kpc.kittenIndex = page;
        kpc.delegate = self;
        
        [viewControllers replaceObjectAtIndex:page withObject:kpc];
        
        [self addChildViewController:kpc];
        [kpc didMoveToParentViewController:self];
        [scrollView addSubview:kpc.view];
        
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        kpc.view.frame = frame;
        NSLog(@"kpc %d - %@", page, NSStringFromCGRect(frame));
    }
}

- (void)unloadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= [Kitten count])
    {
        return;
    }
    
    KittenPhotoController *kpc = [viewControllers objectAtIndex:page];
    if ((NSNull *)kpc != [NSNull null])
    {
        [kpc.view removeFromSuperview];
        [kpc willMoveToParentViewController:nil];
        [kpc removeFromParentViewController];
        [viewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)reloadScrollViews
{
    NSAssert(cacheNextViewsAmount >= 0, @"cacheNextViewsAmount must be positive. had %d", cacheNextViewsAmount);
    
    NSInteger leftLimit = currentPage - cacheNextViewsAmount;
    NSInteger rightLimit = currentPage + cacheNextViewsAmount;
    
    for (NSInteger page = 0; page < [Kitten count]; page++)
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
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat pageWidth = scrollView.frame.size.width;
    
    contentOffset.x = pageWidth * page;
    scrollView.contentOffset = contentOffset;
    NSLog(@"CO: %@", NSStringFromCGPoint(scrollView.contentOffset));
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
        kdc.kitten = [Kitten kittenSortedAtIndex:currentPage];
    }
}

- (void)selectKittenAtIndex:(NSInteger)index;
{
    if (self.isViewLoaded && self.view.window)
    {
        [self loadPage:index];
        [self scrollToPage:index];
    } else {
        currentPage = index;
    }
}

#pragma mark - Lifetime

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    viewControllers = [[NSMutableArray alloc] initWithCapacity:[Kitten count]];
    
    for (NSInteger idx = 0; idx < [Kitten count]; idx++)
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
    [super viewWillAppear:animated];

    NSLog(@"vWA scroll pre");
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [Kitten count],
                                        scrollView.frame.size.height);
    
    [self reloadScrollViews];
    [self scrollToPage:currentPage];
    NSLog(@"vWA scroll post");

    [self.navigationController setNavigationBarHidden:YES animated:YES];

}


- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"vDA pre");
    
    [super viewDidAppear:animated];
    
    NSLog(@"vDA post");
}
@end
