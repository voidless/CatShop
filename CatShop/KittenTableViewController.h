#import <UIKit/UIKit.h>
#import "KittenFlipperDelegateHolder.h"

@interface KittenTableViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, KittenFlipperDelegateHolder>

- (void)markRowAtIndex:(NSIndexPath*)indexPath;

@property (weak) IBOutlet UITableView *tableView;

- (IBAction)backButton;
- (IBAction)editButton;

@end
