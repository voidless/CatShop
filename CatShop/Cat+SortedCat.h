#import <Foundation/Foundation.h>
#import "Cat.h"

@interface Cat (SortedCat)

+ (NSArray *)catsSortedWithContext:(NSManagedObjectContext *)context;

+ (Cat *)catSortedAtIndex:(NSUInteger)index withContext:(NSManagedObjectContext *)context;

+ (void)moveCatSortedFromIndex:(NSUInteger)sourceIdx toIndex:(NSUInteger)destinationIdx withContext:(NSManagedObjectContext *)context;

@end