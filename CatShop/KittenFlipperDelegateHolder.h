#import <Foundation/Foundation.h>

#import "KittenFlipperDelegate.h"

@protocol KittenFlipperDelegateHolder <NSObject>

@property id<KittenFlipperDelegate> delegate;

- (void)selectKittenAtIndex:(NSInteger)index;

@end
