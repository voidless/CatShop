#import <UIKit/UIKit.h>
#import "KittenPhotoClickDelegate.h"
#import "Kitten.h"

@interface KittenDescriptionController : UIViewController <KittenPhotoClickDelegate>

#pragma mark - IBOutlet

@property (weak) IBOutlet UIImageView *kittenView;
@property (weak) IBOutlet UILabel *kittenGender;
@property (weak) IBOutlet UILabel *kittenBirth;
@property (weak) IBOutlet UILabel *kittenBreed;
@property (weak) IBOutlet UILabel *kittenPrice;

@property (weak) IBOutlet UIButton *motherButton;
@property (weak) IBOutlet UIButton *fatherButton;

#pragma mark - Action

- (IBAction)showFather;
- (IBAction)showMother;

#pragma mark - Data

@property (strong) Kitten *kitten;

@end
