#import "DatePickerController.h"
#import "NSDateFormatter+CatDateFormatter.h"

@interface DatePickerController ()

@property (strong) NSDateFormatter *dateFormatter;
@property (strong) NSCalendar *calendar;

@property (strong) NSDate *selectedDate;

@end


@implementation DatePickerController

@synthesize dateField;
@synthesize datePicker;
@synthesize delegate;

@synthesize dateFormatter;
@synthesize calendar;
@synthesize selectedDate;

@synthesize date;

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

- (void)awakeFromNib
{
    calendar = [NSCalendar currentCalendar];
    dateFormatter = [NSDateFormatter catDateFormatter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [datePicker addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventValueChanged];

    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStyleDone target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = save;

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Отменить" style:UIBarButtonItemStyleBordered target:self action:@selector(doReturn)];
    self.navigationItem.leftBarButtonItem = cancel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSDate *currDate = [NSDate date];
    NSDateComponents *offsetComponents = [NSDateComponents new];
    [offsetComponents setYear:-1];

    datePicker.maximumDate = currDate;
    datePicker.minimumDate = [calendar dateByAddingComponents:offsetComponents toDate:currDate options:0];

    datePicker.date = date ? date : currDate;
    [self dateSelected];
}

@end
