#import <UIKit/UIKit.h>
#import "KittenEditControllerDelegate.h"
#import "DatePickerControllerDelegate.h"
#import "Cat.h"

@interface KittenEditController : UITableViewController
        <DatePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak) IBOutlet UIImageView *imageView;

@property (weak) IBOutlet UITextField *nameField;
@property (weak) IBOutlet UISegmentedControl *maleSegCont;
@property (weak) IBOutlet UIButton *birthButton;
@property (weak) IBOutlet UITextField *breedField;
@property (weak) IBOutlet UITextField *priceField;
@property (weak) IBOutlet UIButton *captureButton;
@property (weak) IBOutlet UIButton *galleryButton;

@property (weak) id <KittenEditControllerDelegate> delegate;

@property (strong) Cat *catToEdit;
@property (strong) NSManagedObjectContext *context;

@end
