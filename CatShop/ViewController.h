#import <UIKit/UIKit.h>
#import "Kitten.h"

@interface ViewController : UIViewController

#pragma mark - Outlet

@property (weak) IBOutlet UIButton *prev;
@property (weak) IBOutlet UIButton *next;

@property (weak) IBOutlet UIView *imageContainerView;

#pragma mark - Action

- (IBAction)nextKitten;
- (IBAction)prevKitten;

@end
