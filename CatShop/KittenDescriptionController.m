#import "KittenDescriptionController.h"
#import "Cat.h"
#import "KittenPhotoController.h"
#import "DBHelper.h"
#import "NSDateFormatter+CatDateFormatter.h"

@interface KittenDescriptionController ()

- (void)showKitten:(Cat*)k;

@property (strong) NSManagedObjectContext *context;

@end


@implementation KittenDescriptionController

#pragma mark - IBOutlet

@synthesize kittenView;
@synthesize kittenGenderLabel;
@synthesize kittenBirthLabel;
@synthesize kittenBreedLabel;
@synthesize kittenPriceLabel;

@synthesize motherButton;
@synthesize fatherButton;

#pragma mark - Data

@synthesize kitten;

@synthesize context;

#pragma mark - Kitten Business


- (void)showKitten:(Cat*)k
{
    kittenView.image = k.image;
    
    self.navigationItem.title = k.name;
    
    kittenGenderLabel.text = k.gender;
    
    kittenBreedLabel.text = k.breed;
    
    if (k.price > 0)
    {
        NSString *pr = [[NSString alloc] initWithFormat:@"$ %d", k.price];
        kittenPriceLabel.text = pr;        
    } else {
        kittenPriceLabel.text = @"Не продается";
    }

    NSDateFormatter *df = [NSDateFormatter catDateFormatter];
    kittenBirthLabel.text = [df stringFromDate:k.birth];
    
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
    
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    fetchReq.entity = [Cat entityFromContext:context];
    fetchReq.predicate = [NSPredicate predicateWithFormat:@"myId = %d", showId];
    
    NSArray *cats = [DBHelper execFetch:fetchReq withContext:context];
    if (cats.count != 0)
    {
        kdc.kitten = [cats objectAtIndex:0];
        [self.navigationController pushViewController:kdc animated:YES];
    } else {
        NSLog(@"kitten with id: %d not found", showId);
    }
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
            kpc.kittenImage = kittenView.image;
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
    
    context = [[DBHelper dbHelper] managedObjectContext];
    
    [self showKitten:kitten];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
