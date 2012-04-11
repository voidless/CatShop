#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DBHelper : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DBHelper *)dbHelper;
+ (NSArray *)execFetch:(NSFetchRequest *)request withContext:(NSManagedObjectContext *)context;

@end
