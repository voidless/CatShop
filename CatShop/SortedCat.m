#import "SortedCat.h"
#import "DBHelper.h"

@interface SortedCat ()

@end

@implementation SortedCat

+ (NSArray*) catsSortedWithContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    fetchReq.entity = [Cat entityFromContext:context];
    fetchReq.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO]];
    
    return [DBHelper execFetch:fetchReq withContext:context];
}

+ (Cat*) catSortedAtIndex:(NSInteger)index withContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    fetchReq.entity = [Cat entityFromContext:context];
    fetchReq.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO]];
    
    NSArray *cats = [DBHelper execFetch:fetchReq withContext:context];
    
    if (cats.count > index) {
        return [cats objectAtIndex:index];
    }
    return nil;
}

+ (void) moveCatSortedFromIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx withContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    fetchReq.entity = [Cat entityFromContext:context];
    fetchReq.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO]];
    
    NSMutableArray *cats = [[DBHelper execFetch:fetchReq withContext:context] mutableCopy];
    
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
