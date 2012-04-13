#import <UIKit/UIKit.h>
#import "KittenListController.h"
#import "KittenPhotoControllerDelegate.h"

@interface KittenScrollViewController : UIViewController
        <UIScrollViewDelegate, KittenPhotoControllerDelegate, KittenListController>

// cacheNextViewsAmount must be positive
@property NSInteger cacheNextViewsAmount;

@property (weak) IBOutlet UIScrollView *scrollView;

- (IBAction)kittenInfoClicked;

@end
