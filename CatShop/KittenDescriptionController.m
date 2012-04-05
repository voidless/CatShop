#import "KittenDescriptionController.h"
#import "Kitten.h"
#import "KittenPhotoController.h"

@interface KittenDescriptionController ()

- (void)showKitten:(Kitten*)k;

@end


@implementation KittenDescriptionController

#pragma mark - IBOutlet

@synthesize kittenView;
@synthesize kittenGender;
@synthesize kittenBirth;
@synthesize kittenBreed;
@synthesize kittenPrice;

@synthesize motherButton;
@synthesize fatherButton;

#pragma mark - Data

@synthesize kitten;

#pragma mark - Kitten Business


- (void)showKitten:(Kitten*)k
{    
    kittenView.image = k.image;
    
    self.navigationItem.title = k.name;
    
    kittenGender.text = k.gender;
    
    kittenBreed.text = k.breed;
    
    if (k.price > 0)
    {
        NSString *pr = [[NSString alloc] initWithFormat:@"$ %d", k.price];
        kittenPrice.text = pr;        
    } else {
        kittenPrice.text = @"Не продается";
    }

    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"MMM yyyy"];
    kittenBirth.text = [df stringFromDate:k.birth];
    
    if (!k.motherId)
    {
        motherButton.hidden = YES;
    }
    if (!k.fatherId)
    {
        fatherButton.hidden = YES;
    }
}


- (void)showKittenById:(NSInteger)showId
{
    KittenDescriptionController *kdc = [self.storyboard instantiateViewControllerWithIdentifier:@"descrView"];
    
    kdc.kitten = [Kitten kittenWithKittenId:showId];
    
    [self.navigationController pushViewController:kdc animated:YES];
}


#pragma mark - Actions

- (IBAction)showFather
{
    [self showKittenById:kitten.fatherId];
}

- (IBAction)showMother
{
    [self showKittenById:kitten.motherId];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"modalEnlarge"])
    {        
        KittenPhotoController *kpc = segue.destinationViewController;
        if ([kpc isKindOfClass:[KittenPhotoController class]]) {
            kpc.delegate = self;
            [kpc setKitten:kittenView.image];
        }
    }
}


#pragma mark - Delegate

- (void)kittenPhotoClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Lifetime

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showKitten:kitten];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
