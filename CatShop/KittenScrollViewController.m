#import "KittenScrollViewController.h"
#import "Kitten.h"
#import "KittenPhotoController.h"

@interface KittenScrollViewController ()

@property (strong) NSArray *kittens;
@property (strong) NSMutableArray *viewControllers;

@end


@implementation KittenScrollViewController

@synthesize scrollViewOutlet;

@synthesize kittens;
@synthesize viewControllers;

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
    {
        return;
    }
    if (page >= kittens.count)
    {
        return;
    }
    
    KittenPhotoController *kpc = [viewControllers objectAtIndex:page];
    if ((NSNull *)kpc == [NSNull null])
    {
        NSLog(@"loaded kitten page: %d", page);
        
        Kitten *k = [kittens objectAtIndex:page];
        
        UIImage *image = [UIImage imageWithContentsOfFile:k.imagePath];
        
        kpc = [self.storyboard instantiateViewControllerWithIdentifier:@"fullscreenView"];
        [viewControllers replaceObjectAtIndex:page withObject:kpc];
        [kpc setKitten:image];
        
        [self addChildViewController:kpc];        
        [scrollViewOutlet addSubview:kpc.view];
        
        CGRect frame = scrollViewOutlet.frame;
        frame.origin.x = frame.size.width * page;
        kpc.view.frame = frame;
    }
}

- (void)unloadScrollViewWithPage:(int)page
{
    if (page < 0)
    {
        return;
    }
    if (page >= kittens.count)
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page = (scrollView.contentOffset.x - pageWidth/2) / pageWidth + 1;

    [self unloadScrollViewWithPage:page - 2];
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    [self unloadScrollViewWithPage:page + 2];
}

#pragma mark Lifetime

- (void)awakeFromNib
{
    kittens = [Kitten kittens];
    
    viewControllers = [[NSMutableArray alloc] initWithCapacity:kittens.count];
    
    for (unsigned idx = 0; idx < kittens.count; idx++)
    {
        [viewControllers addObject:[NSNull null]];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollViewOutlet.contentSize = CGSizeMake(scrollViewOutlet.frame.size.width * kittens.count,
                                        scrollViewOutlet.frame.size.height);
    scrollViewOutlet.delegate = self;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}



//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

@end
