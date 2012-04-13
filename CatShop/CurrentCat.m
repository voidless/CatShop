#import "CurrentCat.h"
#import "DBHelper.h"

@interface CurrentCat ()

#define CURRENT_CAT_OBJECT_KEY @"currentCatObjectKey"

@end


@implementation CurrentCat {
    NSManagedObjectID *_currentCatId;
}

- (NSManagedObjectID *)currentCatId
{
    if (_currentCatId == nil) {
        NSPersistentStoreCoordinator *store = [[DBHelper dbHelper] persistentStoreCoordinator];

        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSURL *url = [ud URLForKey:CURRENT_CAT_OBJECT_KEY];
        _currentCatId = [store managedObjectIDForURIRepresentation:url];
    }
    return _currentCatId;
}

- (void)setCurrentCatId:(NSManagedObjectID *)currentCatId
{
    NSAssert(currentCatId.isTemporaryID == NO, @"setCurrentCatId received temporary id: %@", currentCatId);

    _currentCatId = currentCatId;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setURL:[currentCatId URIRepresentation] forKey:CURRENT_CAT_OBJECT_KEY];

    [ud synchronize];
}

// remove this
+ (CurrentCat *)currentCat
{
    static CurrentCat *instance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        instance = [[self alloc] init];
    });

    return instance;
}

@end
