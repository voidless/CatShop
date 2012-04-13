#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (CatShopUtilities)

- (NSArray *)execFetch:(NSFetchRequest *)request;

@end
