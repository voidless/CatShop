#import "DatePickerController.h"

@interface DatePickerController ()

@property (strong) NSDateFormatter *dateFormatter;
@property (strong) NSCalendar *calendar;

@property (strong) NSDate *selectedDate;

@end


@implementation DatePickerController {
    dispatch_once_t onceToken;
}

@synthesize dateField;
@synthesize datePicker;
@synthesize delegate;

@synthesize dateFormatter;
@synthesize calendar;
@synthesize selectedDate;

- (void)dateSelected
{
    selectedDate = datePicker.date;
    dateField.text = [dateFormatter stringFromDate:selectedDate];
}

- (void)doSave
{
    if (selectedDate) {
        [delegate datePicked:selectedDate withDateString:dateField.text];
        [self doReturn];
    } else {
        [dateField becomeFirstResponder];
    }
}

- (void)doReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
        
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterLongStyle;
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    });
    
    NSDate *currDate = [NSDate date];
    NSDateComponents *offsetComponents = [NSDateComponents new];
    [offsetComponents setYear:-1];
    
    [datePicker addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventValueChanged];
    datePicker.maximumDate = currDate;
    datePicker.minimumDate = [calendar dateByAddingComponents:offsetComponents toDate:currDate options:0];
    
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStyleDone target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = save;
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Отменить" style:UIBarButtonItemStyleBordered target:self action:@selector(doReturn)];
    self.navigationItem.leftBarButtonItem = cancel;
}

@end
