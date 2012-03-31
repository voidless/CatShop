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
    CGPoint contentOffset = scrollViewOutlet.contentOffset;
    CGFloat pageWidth = scrollViewOutlet.frame.size.width;
    
    contentOffset.x = pageWidth * page;
    
    [scrollViewOutlet setContentOffset:contentOffset animated:NO];
}

#pragma mark - Events

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x - pageWidth/2) / pageWidth + 1;
    if (currentPage != page)
    {
        [self loadPage:page];
    }
}

#pragma mark Delegate

- (void)kittenPhotoClicked
{
    [self performSegueWithIdentifier:@"modalDescSegue" sender:self];
}

- (void)kittenTableReturnClicked:(NSIndexPath*)indexPath
{
    if (indexPath)
    {        
        [self loadPage:indexPath.row];
        [self scrollToPage:indexPath.row];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Segue

//    TODO: refactor this?
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
    
    KittenTableViewController *tvc = segue.destinationViewController;
    BOOL isTableCont = [tvc isKindOfClass:[KittenTableViewController class]];
    
    if (isTableCont && [segue.identifier isEqualToString:@"modalTableSegue"])
    {
        tvc.delegate = self;
        
        [tvc markRowAtIndex:[NSIndexPath indexPathForRow:currentPage inSection:0]];
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
    
    scrollViewOutlet.contentSize = CGSizeMake(scrollViewOutlet.frame.size.width * kittens.count,
                                        scrollViewOutlet.frame.size.height);
    scrollViewOutlet.delegate = self;
    
    [self loadPage:0];
}

@end
