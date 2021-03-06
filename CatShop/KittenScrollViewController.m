#import "KittenScrollViewController.h"
#import "Cat+SortedCat.h"
#import "KittenPhotoController.h"
#import "KittenDescriptionController.h"

@interface KittenScrollViewController ()

@property (strong) NSMutableArray *viewControllers;

@end


@implementation KittenScrollViewController

@synthesize scrollView;
@synthesize cacheNextViewsAmount;
@synthesize delegate;

@synthesize viewControllers;
@synthesize context;
@synthesize currentCat;

#pragma mark Load Unload

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= [Cat countWithContext:context]) {
        return;
    }

    KittenPhotoController *kpc = [viewControllers objectAtIndex:page];
    if ((id)kpc == [NSNull null]) {
        Cat *k = [Cat catSortedAtIndex:page withContext:context];

        UIImage *image = k.image;

        kpc = [self.storyboard instantiateViewControllerWithIdentifier:@"fullscreenView"];
        kpc.kittenImage = image;
        kpc.delegate = self;

        [viewControllers replaceObjectAtIndex:page withObject:kpc];

        [self addChildViewController:kpc];
        [kpc didMoveToParentViewController:self];
        [scrollView addSubview:kpc.view];

        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        kpc.view.frame = frame;
    }
}

- (void)unloadScrollViewWithPage:(NSUInteger)page
{
    if (page >= [Cat countWithContext:context]) {
        return;
    }

    KittenPhotoController *kpc = [viewControllers objectAtIndex:page];
    if ((id) kpc != [NSNull null]) {
        [kpc.view removeFromSuperview];
        [kpc willMoveToParentViewController:nil];
        [kpc removeFromParentViewController];
        [viewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (NSInteger)currentPage
{
    if (currentCat.currentCatId == nil) {
        return 0;
    }

    NSArray *cats = [Cat catsSortedWithContext:context];

    NSUInteger index = [cats indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop)
                                                      {
                                                          Cat *cat = (Cat *) obj;
                                                          *stop = ([cat.objectID isEqual:currentCat.currentCatId]);
                                                          return *stop;
                                                      }];

    if (index != NSNotFound) {
        return index;
    }
    return 0;
}

- (void)setCurrentPage:(NSUInteger)page
{
    currentCat.currentCatId = [[Cat catSortedAtIndex:page withContext:context] objectID];
}

- (void)reloadScrollViews
{
    NSAssert(cacheNextViewsAmount >= 0, @"cacheNextViewsAmount must be positive. had %d", cacheNextViewsAmount);

    NSInteger currentPage = [self currentPage];

    NSInteger leftLimit = currentPage - cacheNextViewsAmount;
    NSInteger rightLimit = currentPage + cacheNextViewsAmount;

    for (NSUInteger page = 0; page < [Cat countWithContext:context]; page++) {
        if (page >= leftLimit && page <= rightLimit) {
            [self loadScrollViewWithPage:page];
        } else {
            [self unloadScrollViewWithPage:page];
        }
    }
}

#pragma mark Actions


- (void)scrollToCurrentPage
{

    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat pageWidth = scrollView.frame.size.width;

    contentOffset.x = pageWidth * [self currentPage];
    scrollView.contentOffset = contentOffset;
}

#pragma mark - Events

- (void)scrollViewDidScroll:(UIScrollView *)source
{
    CGFloat pageWidth = source.frame.size.width;
    NSUInteger page = (NSUInteger) ((source.contentOffset.x - pageWidth / 2) / pageWidth + 1);
    if ([self currentPage] != page) {
        [self setCurrentPage:page];
        [self reloadScrollViews];
    }
}

#pragma mark Delegate

- (void)kittenPhotoClicked
{
    [self performSegueWithIdentifier:@"DescSegue" sender:self];
}

- (IBAction)kittenInfoClicked
{
    [delegate kittenListControllerDidFinish:self];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KittenDescriptionController *kdc = segue.destinationViewController;
    BOOL isDescrCont = [kdc isKindOfClass:[KittenDescriptionController class]];

    if (isDescrCont && [segue.identifier isEqualToString:@"DescSegue"]) {
        kdc.kitten = [Cat catWithId:currentCat.currentCatId andContext:context];
        kdc.context = context;
    }
}

#pragma mark - Lifetime

- (void)viewDidLoad
{
    [super viewDidLoad];

    viewControllers = [[NSMutableArray alloc] initWithCapacity:[Cat countWithContext:context]];

    for (NSInteger idx = 0; idx < [Cat countWithContext:context]; idx++) {
        [viewControllers addObject:[NSNull null]];
    }

    cacheNextViewsAmount = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [Cat countWithContext:context],
            scrollView.frame.size.height);

    [self reloadScrollViews];
    [self scrollToCurrentPage];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
