#import "Cat+SortedCat.h"
#import "NSManagedObjectContext+CatShopUtilities.h"


@implementation Cat (SortedCat)

+ (NSArray *)catsSortedWithContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    fetchReq.entity = [Cat entityFromContext:context];
    fetchReq.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO]];

    return [context execFetch:fetchReq];
}

+ (Cat *)catSortedAtIndex:(NSInteger)index withContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    fetchReq.entity = [Cat entityFromContext:context];
    fetchReq.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO]];

    NSArray *cats = [context execFetch:fetchReq];

    if (cats.count > index) {
        return [cats objectAtIndex:index];
    }
    return nil;
}

+ (void)moveCatSortedFromIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx withContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    fetchReq.entity = [Cat entityFromContext:context];
    fetchReq.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO]];

    NSMutableArray *cats = [[context execFetch:fetchReq] mutableCopy];

    Cat *cat = [cats objectAtIndex:sourceIdx];
    [cats removeObjectAtIndex:sourceIdx];
    [cats insertObject:cat atIndex:destinationIdx];

    NSInteger rating = cats.count;
    for (cat in cats) {
        cat.rating = rating--;
    }

    NSError *err;
    [context save:&err];
    NSAssert(err == nil, @"DB save error: %@", [err localizedDescription]);
}

@end