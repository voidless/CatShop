#import <UIKit/UIKit.h>
#import "Cat.h"

@interface SortedCat : NSManagedObject

#pragma mark Sorting

+ (NSArray*) catsSortedWithContext:(NSManagedObjectContext*)context;

+ (Cat*) catSortedAtIndex:(NSInteger)index withContext:(NSManagedObjectContext*)context;

+ (void) moveCatSortedFromIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx withContext:(NSManagedObjectContext*)context;

@end
