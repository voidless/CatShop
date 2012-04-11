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
@synthesize captureButton;

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
    
//TODO: save imageView
    
    NSLog(@"newCat: %@", createdCat);
//    [newCat save];
//    [delegate KittenCreated:newCat];
    
//    [self doReturn];
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


#pragma mark Image Picker

- (void)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)doPhoto
{
    [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)doGallery
{
    [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage, *editedImage;
    editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageView.image = editedImage;
    } else {
        imageView.image = originalImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark Lifetime


//-(void) keyboardDidShow: (NSNotification *)notif {
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    context = [[DBHelper dbHelper] managedObjectContext];
    
    createdCat = [[Cat alloc] initWithEntity:[Cat entityFromContext:context] insertIntoManagedObjectContext:context];
    
    captureButton.hidden = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO;
    
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
