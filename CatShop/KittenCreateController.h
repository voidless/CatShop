#import <UIKit/UIKit.h>
#import "KittenCreateDelegate.h"
#import "DatePickerDelegate.h"

@interface KittenCreateController : UITableViewController <DatePickerDelegate>

@property (weak) IBOutlet UIImageView *imageView;

@property (weak) IBOutlet UITextField *nameField;
@property (weak) IBOutlet UISegmentedControl *maleSegCont;
@property (weak) IBOutlet UIButton *birthButton;
@property (weak) IBOutlet UITextField *breedField;
@property (weak) IBOutlet UITextField *priceField;

@property (weak) id<KittenCreateDelegate> delegate;

@end
