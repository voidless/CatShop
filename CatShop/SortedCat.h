#import <UIKit/UIKit.h>
#import "Cat.h"

@interface SortedCat : NSManagedObject

#pragma mark Sorting

+ (Cat*) catSortedAtIndex:(NSInteger)index;

+ (void) moveCatSortedFromIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx;


@property NSInteger sortRating;
@property NSInteger catId;

@end
