#import <UIKit/UIKit.h>
#import "KittenCreateDelegate.h"

@interface KittenCreateTVC : UITableViewController

@property (weak) IBOutlet UIImageView *imageView;

@property (weak) IBOutlet UITextField *nameField;
@property (weak) IBOutlet UISwitch *maleSwitch;
@property (weak) IBOutlet UIButton *birthButton;
@property (weak) IBOutlet UITextField *breedField;
@property (weak) IBOutlet UITextField *priceField;
@property (weak) IBOutlet UIBarButtonItem *saveButton;

@property (weak) id<KittenCreateDelegate> delegate;

@end
