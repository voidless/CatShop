#import <UIKit/UIKit.h>
#import "KittenPhotoControllerDelegate.h"
#import "Cat.h"

@interface KittenDescriptionController : UIViewController
        <KittenPhotoControllerDelegate>

#pragma mark - IBOutlet

@property (weak) IBOutlet UIImageView *kittenView;
@property (weak) IBOutlet UILabel *kittenGenderLabel;
@property (weak) IBOutlet UILabel *kittenBirthLabel;
@property (weak) IBOutlet UILabel *kittenBreedLabel;
@property (weak) IBOutlet UILabel *kittenPriceLabel;

@property (weak) IBOutlet UIButton *motherButton;
@property (weak) IBOutlet UIButton *fatherButton;

#pragma mark - IBAction

- (IBAction)showFather;

- (IBAction)showMother;

#pragma mark - Data

@property (strong) Cat *kitten;
@property (strong) NSManagedObjectContext *context;

@end
