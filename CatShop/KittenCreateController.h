#import <UIKit/UIKit.h>

@interface KittenCreateController : UIViewController

@property (weak) IBOutlet UIImageView *imageView;

@property (weak) IBOutlet UITextField *nameField;
@property (weak) IBOutlet UISwitch *maleSwitch;
@property (weak) IBOutlet UILabel *birthLabel;
@property (weak) IBOutlet UITextField *breedField;
@property (weak) IBOutlet UITextField *priceField;
@property (weak) IBOutlet UIBarButtonItem *saveButton;

@end
