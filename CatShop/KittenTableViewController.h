#import <UIKit/UIKit.h>
#import "KittenFlipperDelegateHolder.h"
#import "KittenEditControllerDelegate.h"

@interface KittenTableViewController : UIViewController
        <UITableViewDataSource, UITableViewDelegate,
        KittenFlipperDelegateHolder, KittenEditControllerDelegate>

- (void)markRowAtIndex:(NSIndexPath *)indexPath;

@property (weak) IBOutlet UITableView *tableView;

- (IBAction)backButton;

- (IBAction)editButton;

@end
