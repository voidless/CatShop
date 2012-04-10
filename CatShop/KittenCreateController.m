#import "KittenCreateController.h"
#import "Cat.h"

@interface KittenCreateController ()

@end


@implementation KittenCreateController

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doSave
{
    if (nameField.text.length > 0
//        && birthButton.titleLabel.text.length > 0
//        && breedField.text.length > 0
//        && priceField.text.length > 0
        )
    {
        Cat *newCat = [[Cat alloc] init];
        newCat.name = nameField.text;
        newCat.breed = breedField.text;
        newCat.price = [priceField.text integerValue];
        NSError *err;
        if (![newCat save:&err])
        {
            NSLog(@"Cat creation failed: %@", [err localizedDescription]);
        }
        
        
        [delegate KittenCreated:newCat];
        
        [self doCancel];
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
