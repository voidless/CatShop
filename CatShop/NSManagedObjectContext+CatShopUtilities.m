#import "NSManagedObjectContext+CatShopUtilities.h"

@implementation NSManagedObjectContext (CatShopUtilities)

- (NSArray *)execFetch:(NSFetchRequest *)request
{
    NSError *err;
    NSArray *result = [self executeFetchRequest:request error:&err];
    NSAssert(err == nil, @"executeFetchRequest failed: %@", [err localizedDescription]);
    return result;
}

@end
