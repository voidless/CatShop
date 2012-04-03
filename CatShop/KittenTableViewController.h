#import <UIKit/UIKit.h>
#import "KittenFlipperDelegateHolder.h"

@interface KittenTableViewController : UITableViewController
<KittenFlipperDelegateHolder>

- (void)markRowAtIndex:(NSIndexPath*)indexPath;

@end
