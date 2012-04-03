#import "KittenScrollViewController.h"
#import "Kitten.h"
#import "KittenPhotoController.h"
#import "KittenDescriptionController.h"
#import "KittenTableViewController.h"

@interface KittenScrollViewController ()

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
    }
}

#pragma mark Delegate

- (void)kittenPhotoClicked
{
    [self performSegueWithIdentifier:@"DescSegue" sender:self];
}

- (IBAction)kittenInfoClicked
{
    [delegate kittenFlipWithIndex:currentPage];
}


//- (void)kittenTableReturnClicked:(NSIndexPath*)indexPath
//{
//    if (indexPath)
//    {        
//        [self loadPage:indexPath.row];
//        [self scrollToPage:indexPath.row];
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//- (void)kittenDescriptionReturnClicked
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KittenDescriptionController *kdc = segue.destinationViewController;
    BOOL isDescrCont = [kdc isKindOfClass:[KittenDescriptionController class]];
    
    if (isDescrCont && [segue.identifier isEqualToString:@"DescSegue"])
    {   
        kdc.kitten = [kittens objectAtIndex:currentPage];
    }
    
//    KittenTableViewController *tvc = segue.destinationViewController;
//    BOOL isTableCont = [tvc isKindOfClass:[KittenTableViewController class]];
//    
//    if (isTableCont && [segue.identifier isEqualToString:@"modalTableSegue"])
//    {
////        tvc.delegate = self;
//        
//        [tvc markRowAtIndex:[NSIndexPath indexPathForRow:currentPage inSection:0]];
//    }
}

- (void)selectKittenAtIndex:(NSInteger)index;
{
    [self loadPage:index];
    [self scrollToPage:index];
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
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kittens.count,
                                        scrollView.frame.size.height);
    scrollView.delegate = self;
    
    [self loadPage:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
