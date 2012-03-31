#import <UIKit/UIKit.h>
#import "KittenPhotoClickDelegate.h"
#import "KittenTableReturnDelegate.h"

@interface KittenScrollViewController : UIViewController
<UIScrollViewDelegate, KittenPhotoClickDelegate, KittenTableReturnDelegate>

@property (weak) IBOutlet UIScrollView *scrollViewOutlet;

// cacheNextViewsAmount must be positive
@property NSInteger cacheNextViewsAmount;

@end
