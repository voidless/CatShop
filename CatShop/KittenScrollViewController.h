#import <UIKit/UIKit.h>
#import "KittenPhotoClickDelegate.h"
#import "KittenFlipperDelegateHolder.h"

@interface KittenScrollViewController : UIViewController
        <UIScrollViewDelegate, KittenPhotoClickDelegate, KittenFlipperDelegateHolder>

// cacheNextViewsAmount must be positive
@property NSInteger cacheNextViewsAmount;


@property (weak) IBOutlet UIScrollView *scrollView;

- (IBAction)kittenInfoClicked;

@end
