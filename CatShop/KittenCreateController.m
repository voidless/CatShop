#import "KittenCreateController.h"
#import "DBHelper.h"
#import "DatePickerController.h"

@interface KittenCreateController ()

@property (strong) NSManagedObjectContext *context;

@property (strong) Cat *createdCat;

@end


@implementation KittenCreateController

@synthesize imageView;
@synthesize nameField;
@synthesize maleSegCont;
@synthesize birthButton;
@synthesize breedField;
@synthesize priceField;
@synthesize delegate;

@synthesize context;
@synthesize createdCat;

- (void)doReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doSave
{
    if (nameField.text.length == 0) {
        [nameField becomeFirstResponder];
        return;
    }
    if (breedField.text.length == 0) {
        [breedField becomeFirstResponder];
        return;
    }
    if (priceField.text.length == 0) {
        [priceField becomeFirstResponder];
        return;
    }
    
    createdCat.name = nameField.text;
    createdCat.breed = breedField.text;
    createdCat.price = [priceField.text integerValue];
    createdCat.male = (maleSegCont.selectedSegmentIndex == 0);
    
    NSLog(@"newCat: %@", createdCat);
//    [newCat save];
//    [delegate KittenCreated:newCat];
    
//    [self doReturn];
}

- (IBAction)doPhoto
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DatePickerController *dpc = segue.destinationViewController;
    if ([dpc isKindOfClass:[DatePickerController class]]
        && [segue.identifier isEqualToString:@"DatePick"]) {
        dpc.delegate = self;
    }
}

- (void)datePicked:(NSDate *)date withDateString:(NSString *)dateString
{
    createdCat.birth = date;
    [birthButton setTitle:dateString forState:UIControlStateNormal];
}


//-(void) keyboardDidShow: (NSNotification *)notif {
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    context = [[DBHelper dbHelper] managedObjectContext];
    
    createdCat = [[Cat alloc] initWithEntity:[Cat entityFromContext:context] insertIntoManagedObjectContext:context];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:)name: UIKeyboardDidShowNotification object:nil];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStyleDone target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = save;
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Отменить" style:UIBarButtonItemStyleBordered target:self action:@selector(doReturn)];
    self.navigationItem.leftBarButtonItem = cancel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
