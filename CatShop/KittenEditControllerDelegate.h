#import <Foundation/Foundation.h>
#import "Cat.h"

@protocol KittenEditControllerDelegate <NSObject>

- (void)kittenFinishedEditing:(Cat*)newCat;

@end
