#import "KittenCreateTVC.h"

@interface KittenCreateTVC ()

@end

@implementation KittenCreateTVC


@synthesize imageView;
@synthesize nameField;
@synthesize maleSwitch;
@synthesize birthButton;
@synthesize breedField;
@synthesize priceField;
@synthesize saveButton;

@synthesize delegate;

- (IBAction)doCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doSave
{
    if (nameField.text.length == 0) {
        [nameField becomeFirstResponder];
        return;
    }
    
//    if (nameField.text.length > 0
        //        && birthButton.titleLabel.text.length > 0
        //        && breedField.text.length > 0
        //        && priceField.text.length > 0

    Cat *newCat = [[Cat alloc] init];
    newCat.name = nameField.text;
    newCat.breed = breedField.text;
    newCat.price = [priceField.text integerValue];
    [newCat save];
    
    [delegate KittenCreated:newCat];
    
    [self doCancel];
}

- (IBAction)doPhoto
{
    
}

- (IBAction)doSelectDate
{
    
}

//- (void)checkInput
//{
//    saveButton.enabled = YES;
//}

-(void) keyboardDidShow: (NSNotification *)notif {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:)name: UIKeyboardDidShowNotification object:nil];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStyleDone target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = save;
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Отменить" style:UIBarButtonItemStyleBordered target:self action:@selector(doCancel)];
    self.navigationItem.leftBarButtonItem = cancel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
