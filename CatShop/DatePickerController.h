#import <UIKit/UIKit.h>
#import "DatePickerDelegate.h"


@interface DatePickerController : UIViewController

@property (weak) IBOutlet UIDatePicker *datePicker;
@property (weak) IBOutlet UITextField *dateField;

@property (weak) id<DatePickerDelegate> delegate;

@end
