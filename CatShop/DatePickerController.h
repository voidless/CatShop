#import <UIKit/UIKit.h>
#import "DatePickerControllerDelegate.h"


@interface DatePickerController : UIViewController

@property (weak) IBOutlet UIDatePicker *datePicker;
@property (weak) IBOutlet UITextField *dateField;

@property (weak) id <DatePickerControllerDelegate> delegate;

@property (strong) NSDate *date;

@end
