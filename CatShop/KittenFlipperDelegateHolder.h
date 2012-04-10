#import <Foundation/Foundation.h>

#import "KittenFlipperDelegate.h"

@protocol KittenFlipperDelegateHolder <NSObject>

@property (weak) id<KittenFlipperDelegate> delegate;

@end
