#import <UIKit/UIKit.h>
#import "KittenTableReturnDelegate.h"

@interface KittenTableViewController : UITableViewController

@property (weak) id<KittenTableReturnDelegate> delegate;

@end
