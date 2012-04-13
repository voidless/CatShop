#import <Foundation/Foundation.h>

#import "KittenListController.h"
#import "CurrentCat.h"

@protocol KittenListControllerDelegate;


@protocol KittenListController <NSObject>

@property (weak) id <KittenListControllerDelegate> delegate;
@property (strong) NSManagedObjectContext *context;
@property (strong) CurrentCat *currentCat;

@end


@protocol KittenListControllerDelegate <NSObject>

- (void)kittenListControllerDidFinish:(UIViewController<KittenListController> *)controller;

@end
