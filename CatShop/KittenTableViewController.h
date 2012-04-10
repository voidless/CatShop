#import <UIKit/UIKit.h>
#import "KittenFlipperDelegateHolder.h"
#import "KittenCreateDelegate.h"

@interface KittenTableViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate,
KittenFlipperDelegateHolder, KittenCreateDelegate>

- (void)markRowAtIndex:(NSIndexPath*)indexPath;

@property (weak) IBOutlet UITableView *tableView;

- (IBAction)backButton;
- (IBAction)editButton;

@end
