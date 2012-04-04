#import <Foundation/Foundation.h>

@protocol KittenFlipperDelegate <NSObject>

- (void)kittenFlip;

- (void)kittenSetCurrent:(NSInteger)index;

@end
