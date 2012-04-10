#import <Foundation/Foundation.h>
#import "Cat.h"

@protocol KittenCreateDelegate <NSObject>

- (void)KittenCreated:(Cat*)newCat;

@end
