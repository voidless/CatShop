#import "KittenEditController.h"
#import "DatePickerController.h"
#import "NSDateFormatter+CatDateFormatter.h"

@interface KittenEditController ()

@property (strong) NSDateFormatter *dateFormatter;

@end


@implementation KittenEditController

@synthesize imageView;
@synthesize nameField;
@synthesize maleSegCont;
@synthesize birthButton;
@synthesize breedField;
@synthesize priceField;
@synthesize captureButton;
@synthesize galleryButton;

@synthesize delegate;
@synthesize catToEdit;

@synthesize context;
@synthesize dateFormatter;

#pragma mark Events

- (void)doReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doSave
{
    if (catToEdit.image == nil) {
        galleryButton.highlighted = YES;
        return;
    }
    if (nameField.text.length == 0) {
        [nameField becomeFirstResponder];
        return;
    }
    if (catToEdit.birth == nil) {
        birthButton.highlighted = YES;
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

    [delegate kittenFinishedEditing:catToEdit];

    [self doReturn];
}

- (IBAction)doneEditingName
{
    catToEdit.name = nameField.text;
}

- (IBAction)doneEditingBreed
{
    catToEdit.breed = breedField.text;
}

- (IBAction)doneEditingPrice
{
    catToEdit.price = [priceField.text integerValue];
}

- (IBAction)doneEditingGender
{
    catToEdit.male = (maleSegCont.selectedSegmentIndex == 0);
}

#pragma mark Child Controllers

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DatePickerController *dpc = segue.destinationViewController;
    if ([dpc isKindOfClass:[DatePickerController class]]
            && [segue.identifier isEqualToString:@"DatePick"]) {
        dpc.delegate = self;
        dpc.date = catToEdit.birth;
    }
}

- (void)datePicked:(NSDate *)date withDateString:(NSString *)dateString
{
    catToEdit.birth = date;
    [birthButton setTitle:dateString forState:UIControlStateNormal];
}


#pragma mark Image Picker

- (void)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.delegate = self;
        imagePicker.sourceType = sourceType;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
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

    catToEdit.image = imageView.image;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Lifetime

- (void)awakeFromNib
{
    dateFormatter = [NSDateFormatter catDateFormatter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    captureButton.hidden = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO;

    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStyleDone target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = save;

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Отменить" style:UIBarButtonItemStyleBordered target:self action:@selector(doReturn)];
    self.navigationItem.leftBarButtonItem = cancel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];

    nameField.text = catToEdit.name;
    breedField.text = catToEdit.breed;
    priceField.text = [NSString stringWithFormat:@"%d", catToEdit.price];
    maleSegCont.selectedSegmentIndex = catToEdit.male ? 0 : 1;
    imageView.image = catToEdit.image;
    [birthButton setTitle:[dateFormatter stringFromDate:catToEdit.birth] forState:UIControlStateNormal];
}

@end
