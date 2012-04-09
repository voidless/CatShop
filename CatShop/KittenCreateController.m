#import "KittenCreateController.h"
#import "Cat.h"

@interface KittenCreateController ()

@end


@implementation KittenCreateController

@synthesize imageView;
@synthesize nameField;
@synthesize maleSwitch;
@synthesize birthLabel;
@synthesize breedField;
@synthesize priceField;
@synthesize saveButton;

- (IBAction)doCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doSave
{
    if (nameField.text.length > 0
        && birthLabel.text.length > 0
        && breedField.text.length > 0
        && priceField.text.length > 0)
    {
        Cat *newCat = [[Cat alloc] init];
        newCat.name = nameField.text;
        newCat.breed = breedField.text;
        newCat.price = [priceField.text integerValue];
//        newCat.birth = 
    }
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


- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
