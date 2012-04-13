#import <UIKit/UIKit.h>
#import "KittenListController.h"
#import "KittenEditControllerDelegate.h"

@interface KittenTableViewController : UIViewController
        <UITableViewDataSource, UITableViewDelegate,
        KittenListController, KittenEditControllerDelegate>

- (void)markRowAtIndex:(NSIndexPath *)indexPath;

@property (weak) IBOutlet UITableView *tableView;

- (IBAction)backButton;

- (IBAction)editButton;

@end
