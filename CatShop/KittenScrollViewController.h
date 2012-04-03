#import <UIKit/UIKit.h>
#import "KittenPhotoClickDelegate.h"
#import "KittenFlipperDelegateHolder.h"

@interface KittenScrollViewController : UIViewController
<UIScrollViewDelegate, KittenPhotoClickDelegate, KittenFlipperDelegateHolder>

@property (weak) IBOutlet UIScrollView *scrollView;

// cacheNextViewsAmount must be positive
@property NSInteger cacheNextViewsAmount;

@end
