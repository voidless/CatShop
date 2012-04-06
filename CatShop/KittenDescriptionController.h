#import <UIKit/UIKit.h>
#import "KittenPhotoClickDelegate.h"
#import "KittenFlipperDelegateHolder.h"
#import "Kitten.h"

@interface KittenDescriptionController : UIViewController
<KittenPhotoClickDelegate>

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

@property (strong) Kitten *kitten;

@end
