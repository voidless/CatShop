#import <Foundation/Foundation.h>

@protocol KittenTableReturnDelegate <NSObject>

- (void)kittenTableReturnClicked:(NSIndexPath*)indexPath;

@end
