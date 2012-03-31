#import <UIKit/UIKit.h>
#import "KittenTableReturnDelegate.h"

@interface KittenTableViewController : UITableViewController

- (void)markRowAtIndex:(NSIndexPath*)indexPath;

@property (weak) id<KittenTableReturnDelegate> delegate;

@end
