#import <Foundation/Foundation.h>
#import "Cat.h"

@interface Cat (SortedCat)

+ (NSArray *)catsSortedWithContext:(NSManagedObjectContext *)context;

+ (Cat *)catSortedAtIndex:(NSInteger)index withContext:(NSManagedObjectContext *)context;

+ (void)moveCatSortedFromIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx withContext:(NSManagedObjectContext *)context;

@end